import 'package:apli/Screens/Home/mainScreen.dart';
import 'package:apli/Screens/Login-Signup/Login/forgotPassword.dart';
import 'package:apli/Screens/Login-Signup/Signup/verifyPhoneNo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
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
//        else SystemChannels.platform.invokeMethod('SystemNavigator.pop', true);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
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
                      Visibility(
                        visible: !forgotPassword,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: obscure,
                              decoration: loginFormField.copyWith(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      EvaIcons.eyeOutline,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscure = !obscure;
                                      });
                                    },
                                  ),
                                  icon: Icon(Icons.lock_outline,
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
                                      onPressed: () {
                                        setState(() {
                                          forgotPassword = true;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: forgotPassword
                              ? EdgeInsets.only(
                                  top: height * 0.05,
                                  left: width * 0.1,
                                  right: width * 0.1)
                              : EdgeInsets.only(
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
                                  forgotPassword ? 'Submit' : login,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  if (forgotPassword) if (validateEmail(
                                      (email))) {
                                    setState(() {
                                      loading = true;
                                    });
                                    var net = await Connectivity()
                                        .checkConnectivity();
                                    if (net == ConnectivityResult.none) {
                                      Toast.show('No Internet', context,
                                          backgroundColor: Colors.red);
                                    } else {
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
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    FocusScope.of(context).requestFocus();
                                    Toast.show('Enter Valid Email', context,
                                        backgroundColor: Colors.red);
                                  }
                                  else if (_formKey.currentState.validate()) {
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
                                      Toast.show(
                                          'Invalid username and password',
                                          context,
                                          duration: 5,
                                          backgroundColor: Colors.red);
                                      setState(() {
                                        loading = false;
                                      });
                                    } else if (result == -2) {
                                      Toast.show(
                                          'Cannot connect server', context,
                                          duration: 5,
                                          backgroundColor: Colors.red);
                                      setState(() {
                                        loading = false;
                                      });
                                    } else if (result == 1) {
                                      Toast.show('Login Successfull', context, backgroundColor: Colors.red);
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
                                    var net = await Connectivity()
                                        .checkConnectivity();
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
                      Visibility(
                        visible: !forgotPassword,
                        child: Padding(
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
                                            builder: (context) =>
                                                VerifyPhoneNo()),
                                      );
                                    },
                                    child: Text(
                                      "Signup here",
                                      style: TextStyle(color: basicColor),
                                    ))
                              ],
                            )),
                      ),
                      Visibility(
                        visible: forgotPassword,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.05,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Remember Password,'),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        forgotPassword = false;
                                      });
                                    },
                                    child: Text(
                                      "Login       ",
                                      style: TextStyle(color: basicColor),
                                    ))
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
