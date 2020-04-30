import 'package:apli/Screens/Login-Signup/Signup/register.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:toast/toast.dart';

class VerifyPhoneNo extends StatefulWidget {
  @override
  _VerifyPhoneNoState createState() => _VerifyPhoneNoState();
}

double height, width;
AuthCredential globalCredential;
bool register = false;
String phoneNo;

class _VerifyPhoneNoState extends State<VerifyPhoneNo> {
  String countryCode = '+91';
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String smsOTP;
  String verificationId;
  String errorMessage = '';

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

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
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            try {
              await FirebaseAuth.instance.signOut();
            } catch (e) {}
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Register(phoneNo)));
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
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.2),
                  child: AlertDialog(
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
                        child: Text('Verify'),
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          _auth.currentUser().then((user) async {
                            if (user != null) {
                              setState(() {
                                loading = false;
                              });
                              try {
                                await FirebaseAuth.instance.signOut();
                              } catch (e) {}
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register(phoneNo)));
                            } else {
                              signIn();
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
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
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {}
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Register(phoneNo)));
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
    return loading
        ? Loading()
        : Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                child: Container(
                  width: width,
                  height: 60,
                  color: basicColor,
                  padding:
                  EdgeInsets.only(top: 10, bottom: 5),
                  child: Center(
                    child: FlatButton(
                      child: Text(
                        'Already have an account?  Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ),
                ),
              ),
              elevation: 0,
            ),
            body: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, height * 0.1, 10, 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Let's get you signed up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                  title: _buildCountryPickerDropdown(
                                      hasPriorityList: true)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Text(
                            'By signing up, you are agreeing to our terms & conditions'),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.05,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: Container(
                              height: 70,
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
                                      var net = await Connectivity()
                                          .checkConnectivity();
                                      if (net == ConnectivityResult.none) {
                                        Toast.show('No Internet', context);
                                      }
                                      verifyPhone();
                                    }
                                  }),
                            )),
                      ],
                    ),
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
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  labelText: 'Mobile No'),
              onChanged: (text) {
                phoneNo = countryCode + text;
                setState(() => phoneNo = countryCode + text);
              },
              validator: (value) {
                if (value.length != 10) {
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
