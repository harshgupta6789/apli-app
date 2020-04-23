import 'package:apli/Screens/Home/mainScreen.dart';
import 'package:apli/Screens/Login-Signup/forgotPassword.dart';
import 'package:apli/Screens/Login-Signup/verifyPhoneNo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../Services/auth.dart';

double height, width;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '', password = '', error = '';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool rememberMe = true;

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.length < 8) {
      return false;
    } else {
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    }
  }

  bool validateEmail(String value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.3, right: width * 0.5),
                      child: Image.asset("Assets/Images/logo.png"),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.05,
                            left: width * 0.1,
                            right: width * 0.1),
                        child: TextFormField(
                          obscureText: false,
                          decoration: loginFormField.copyWith(
                              labelText: 'Email Address',
                              icon: Icon(Icons.email, color: basicColor)),
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
                    Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.02,
                            left: width * 0.1,
                            right: width * 0.1),
                        child: TextFormField(
                          obscureText: true,
                          decoration: loginFormField.copyWith(
                              labelText: 'Password',
                              icon:
                                  Icon(Icons.lock_outline, color: basicColor)),
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
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.1,
                      ),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: rememberMe,
                              onChanged: (bool temp) {
                                setState(() {
                                  rememberMe = !rememberMe;
                                });
                              }),
                          Text(rememberMeText),
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.2),
                            child: Container(
                              width: width * 0.3,
                              height: height * 0.1,
                              child: FlatButton(
                                  splashColor: Colors.white,
                                  child: Text(
                                    forgot,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: basicColor),
                                  ),
                                  onPressed: () async {
                                    if (validateEmail((email))) {
                                      setState(() {
                                        loading = true;
                                      });
                                      var net = await Connectivity()
                                          .checkConnectivity();
                                      if (net == ConnectivityResult.none) {
                                        Toast.show('Not Internet', context,backgroundColor: Colors.red);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPassword(
                                                      email: email,
                                                    )));
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      Toast.show(
                                          'Invalid Email Provided', context,backgroundColor: Colors.red);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.1,
                            right: width * 0.1),
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                            color: basicColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                              child: Text(
                                login,
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
                                  dynamic result = await _auth
                                      .signInWithoutAuth(email, password);
                                  if (result == -10) {
                                    Toast.show(
                                        'Account does not exists', context,
                                        duration: 5,
                                        backgroundColor: Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else if (result == -1) {
                                    Toast.show('Invalid username and password',
                                        context,
                                        duration: 5,
                                        backgroundColor: Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else if (result == -2) {
                                    Toast.show('Cannot connect server', context,
                                        duration: 5,
                                        backgroundColor: Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else if (result == 1) {
                                    Toast.show('Login Successfull', context);
                                    setState(() {
                                      loading = false;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('email', email);
                                    prefs.setBool('rememberMe', rememberMe);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  }
                                  var net =
                                      await Connectivity().checkConnectivity();
                                  if (net == ConnectivityResult.none) {
                                    Toast.show(
                                        'No Internet Connection', context,
                                        duration: 5,
                                        backgroundColor: Colors.red);
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.05,
                            left: width * 0.1,
                            right: width * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(signup),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VerifyPhoneNo()),
                                  );
                                },
                                child: Text(
                                  "Signup here",
                                  style: TextStyle(color: basicColor),
                                ))
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
