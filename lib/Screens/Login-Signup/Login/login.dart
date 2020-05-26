import 'package:apli/Screens/Home/mainScreen.dart';
import 'package:apli/Screens/Login-Signup/Login/forgotPassword.dart';
import 'package:apli/Screens/Login-Signup/Signup/verifyPhoneNo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/auth.dart';

double height, width;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '', password = '', error = '';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool loading = false;
  bool rememberMe = true;
  bool forgotPassword = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              if (forgotPassword)
                setState(() {
                  forgotPassword = false;
                });
              else {
                if (Theme.of(context).platform == TargetPlatform.android) {
                  SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop', true);
                }
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Visibility(
                          visible: forgotPassword,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.1,
                                  left: width * 0.1,
                                  right: width * 0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: forgotPassword ? height * 0.2 : height * 0.3,
                              right: width * 0.5),
                          child: Image.asset("Assets/Images/logo.png"),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.05,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: forgotPassword
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  hintText: 'Email Address',
                                  prefixIcon: Icon(EvaIcons.emailOutline,
                                      color: basicColor)),
                              onChanged: (text) {
                                setState(() => email = text);
                              },
                              validator: (value) {
                                if (!validateEmail(value)) {
                                  return 'please enter valid email';
                                }
                                return null;
                              },
                            )),
                        Visibility(
                          visible: !forgotPassword,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.1,
                                  right: width * 0.1),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                toolbarOptions: ToolbarOptions(
                                    copy: false,
                                    paste: false,
                                    selectAll: false,
                                    cut: false),
                                obscureText: obscure,
                                decoration: loginFormField.copyWith(
                                    hintText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: !obscure
                                          ? Icon(
                                              EvaIcons.eyeOffOutline,
                                              color: basicColor,
                                            )
                                          : Icon(
                                              EvaIcons.eyeOutline,
                                              color: Colors.grey,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: basicColor)),
                                onChanged: (text) {
                                  setState(() => password = text);
                                },
                                validator: (value) {
                                  if (!validatePassword(value)) {
                                    return 'password must contain 8 characters with atleast \n one lowercase, one uppercase, one digit, \n and one special character';
                                  }
                                  return null;
                                },
                              )),
                        ),
                        Visibility(
                          visible: !forgotPassword,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Checkbox(
                                        value: rememberMe,
                                        activeColor: basicColor,
                                        onChanged: (bool temp) {
                                          setState(() {
                                            rememberMe = !rememberMe;
                                          });
                                        }),
                                    Text(rememberMeText),
                                  ],
                                ),
                                FlatButton(
                                    splashColor: Colors.white,
                                    child: Text(
                                      'Forgot\nPassword',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: basicColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        forgotPassword = true;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: forgotPassword
                                ? EdgeInsets.only(
                                    top: height * 0.1,
                                    left: width * 0.1,
                                    right: width * 0.1)
                                : EdgeInsets.only(
                                    top: height * 0.01,
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
                                    forgotPassword ? 'Submit' : login,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    if (forgotPassword) if (validateEmail(
                                            (email)) &&
                                        email != '' &&
                                        email != null) {
                                      setState(() {
                                        loading = true;
                                      });
                                      var net = await Connectivity()
                                          .checkConnectivity();
                                      if (net == ConnectivityResult.none) {
                                        showToast('No Internet', context,
                                            color: Colors.red);
                                      } else {
                                        DocumentReference doc = Firestore
                                            .instance
                                            .collection('users')
                                            .document(email);
                                        await doc.get().then((onValue) {
                                          if (onValue.exists) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPassword(
                                                          email: email,
                                                        )));
                                            setState(() {
                                              forgotPassword = false;
                                            });
                                          } else {
                                            showToast('Account does not exist',
                                                context,
                                                color: Colors.red);
                                          }
                                        });
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      showToast('Enter Valid Email', context);
                                    }
                                    else if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth
                                          .signInWithoutAuth(email, password);
                                      if (result == -10) {
                                        showToast(
                                            'Account does not exists', context,
                                            color: Colors.red);
                                        setState(() {
                                          loading = false;
                                        });
                                      } else if (result == -1) {
                                        showToast(
                                            'Invalid username and password',
                                            context,
                                            color: Colors.red);
                                        setState(() {
                                          loading = false;
                                        });
                                      } else if (result == -2) {
                                        showToast(
                                            'Cannot connect server', context,
                                            color: Colors.red);
                                        setState(() {
                                          loading = false;
                                        });
                                      } else if (result == 1) {
                                        showToast('Login Successful', context);
                                        setState(() {
                                          loading = false;
                                        });
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString('email', email);
                                        prefs.setBool('rememberMe', rememberMe);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen()));
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        showToast(
                                            'Failed, try again later', context,
                                            color: Colors.red);
                                      }
                                    }
                                  }),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.05,
                              left: width * 0.1,
                              right: width * 0.1),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: forgotPassword
                                    ? 'Remember Password? '
                                    : signup,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                                  TextSpan(
                                      text: forgotPassword
                                          ? 'Login'
                                          : " Signup here",
                                      style: TextStyle(color: basicColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          forgotPassword
                                              ? setState(() {
                                                  forgotPassword = false;
                                                })
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VerifyPhoneNo()),
                                                );
                                        }),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
