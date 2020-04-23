import 'package:apli/Screens/Login-Signup/updatePassword.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  String email;
  ForgotPassword({this.email});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

double height, width;

class _ForgotPasswordState extends State<ForgotPassword> {

  bool loading = false, loading2 = false;

  Future<String> userDetails() async {
    String ph_no;
    DocumentReference doc = Firestore.instance.collection('candidates').document(widget.email);
    await doc.get().then((snapshot) {
      if(!snapshot.exists) {
        ph_no = null;
      } else {
        ph_no = snapshot.data['ph_no'].toString();
        if(ph_no == null) {
          ph_no =  'noPhoneNo';
        } else {
          if(ph_no.length == 10) {
            ph_no =  '+91' + ph_no;
          } else {
            ph_no =  ph_no;
          }
        }
      }
    });
    return ph_no;
  }

  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone(String phoneNo) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      setState(() {
        loading2 = false;
      });
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('1');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
            print(verificationId);
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePassword(email: widget.email)));
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message} verification failed');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: Container(
              height: 100,
              child: Column(children: [
                PinCodeTextField(
                  length: 6,
                  activeFillColor: basicColor,
                  activeColor: basicColor,
                  inactiveFillColor: Colors.black,
                  selectedColor: basicColor,
                  inactiveColor: Colors.black,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  onChanged: (value) {
                    setState(() {
                      this.smsOTP = value;
                    });
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Next'),
                onPressed: () {
                  setState(() {
                    loading2 = true;
                  });
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      setState(() {
                        loading2 = false;
                      });
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePassword(email: widget.email)));
                    } else {
                      signIn();
                    }
                  });
//                  _auth.currentUser().then((user) {
//                    signIn();
//                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      setState(() {
        loading2 = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePassword(email: widget.email,)));
    } catch (e) {
      setState(() {
        loading2 = false;
      });
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: userDetails(),
          builder: (BuildContext context,
              AsyncSnapshot<String>snapshot) {
            print(snapshot.data);
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              String ph_no = snapshot.data;
              if(ph_no == null)
                return Center(child: Text('Account does not exist'),);
              else if(ph_no == 'NoNumber')
                return Center(child: Text('No Number Given'),);
              else {
                return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.3, right: width * 0.5),
                        child: Image.asset("Assets/Images/logo.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.1,
                        ),
                        child: Text('OTP will been sent to' + ph_no),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.1,
                        ),
                        child: FlatButton(
                            child: Text('Send OTP?'),
                            onPressed: () async {
                              setState(() {
                                loading2 = true;
                              });
                              verifyPhone(ph_no);
                            }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.1,
                        ),
                        child: FlatButton(
                            child: Text('Or Contact Us'),
                            onPressed: () async {
                              const url =
                                  'mailto:ojask2002@gmail.com?subject=Regarding Apli App';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                        ),
                      ),
                    ],
                );
              }
            } else if(snapshot.hasError) {
              print(snapshot.error);
              return Padding(padding: EdgeInsets.fromLTRB(100, 400, 100, 0),child: Text('Error occured while fetching data', textAlign: TextAlign.center,),);
            } else {
              return Container(
                height: height,
                child: Loading(),
              );
            }
        }
        ),
      ),
    );
  }
}
