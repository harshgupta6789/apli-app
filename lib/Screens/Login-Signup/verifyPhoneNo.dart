
import 'package:apli/Screens/Login-Signup/register.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class VerifyPhoneNo extends StatefulWidget {
  @override
  _VerifyPhoneNoState createState() => _VerifyPhoneNoState();
}

double height, width;

class _VerifyPhoneNoState extends State<VerifyPhoneNo> {

  String countryCode = '+91';
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      setState(() {
        loading = false;
      });
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('1');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
            print(verificationId);
          },
          codeSent: smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
            print('verification complete');
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
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
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
                child: Text('Done'),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      print('user not null');
                      setState(() {
                        loading = false;
                      });
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register()
                        ),
                      );
                    } else {
                      signIn();
                    }
                  });
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
      assert(user.uid == user.uid);
      print('sign in');
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Register()
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
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
          print('invalid case');
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.only(left: 80, top: 10, bottom: 5),
              child: Row(
                children: <Widget>[
                  Text('Already have an account? ', style: TextStyle(color: Colors.white),),
                  FlatButton(
                    child: Text('Sign In', style: TextStyle(color: Colors.blue),),
                    onPressed: (){Navigator.pop(context);},
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Let's get you signed up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 100,),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                          title: _buildCountryPickerDropdown(hasPriorityList: true)),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Text('By signing up, you are agreeing to our terms & conditions'),
                Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.05, left: width * 0.1, right: width * 0.1),
                    child: Container(
                      height: height * 0.08,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: basicColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
//                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
//                              if (result == null) {
//                                setState(() {
//                                  error = 'Invalid email or password';
//                                  loading = false;
//                                });
//                              }
//                              if (result == -1) {
//                                setState(() {
//                                  error = 'Account not Verified, Check your email';
//                                  loading = false;
//                                });
//                              }
                              var net = await Connectivity().checkConnectivity();
                              if(net == ConnectivityResult.none) {
                                setState(() {
                                  error = 'No Internet Connection';
                                });
                              }
                              verifyPhone();
                            }

                          }),
                    )),
                SizedBox(height: 100,),
                Center(
                  child: Text('Or Sign Up With'),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Image.asset("Assets/Images/logo.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCountryPickerDropdown(
      {bool filtered = false,
        bool sortedByIsoCode = false,
        bool hasPriorityList = false}) =>
      Row(
        children: <Widget>[
          CountryPickerDropdown(
            initialValue: 'IN',
            itemBuilder: _buildDropdownItem,
            itemFilter: filtered
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            priorityList: hasPriorityList
                ? [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              setState(() {
                countryCode = country.isoCode;
              });
              print("${country.name}");
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Mobile No'
              ),
              onChanged: (text) {
                setState(() => phoneNo = countryCode + text);
              },
              validator: (value) {
                if (value.length != 10 && isNumeric(value)) {
                  return 'invalid phone number';
                }
                return null;
              },
            ),
          )
        ],
      );

  Widget _buildDropdownItem(Country country) => Container(
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("+${country.phoneCode}(${country.isoCode})"),
      ],
    ),
  );

}
