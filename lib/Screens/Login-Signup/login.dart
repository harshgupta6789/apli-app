import 'package:apli/Screens/Login-Signup/verifyPhoneNo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height * 0.3, right: width * 0.5),
                child: Image.asset("Assets/Images/logo.png"),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.05, left: width * 0.1, right: width * 0.1),
                  child: TextFormField(
                    obscureText: false,
                    decoration: loginFormField.copyWith(labelText: 'Email Address', icon: Icon(Icons.email, color: basicColor)),
                    onChanged: (text) {
                      setState(() => email = text);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter valid email';
                      }
                      return null;
                    },
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.02, left: width * 0.1, right: width * 0.1),
                  child: TextFormField(
                    obscureText: true,
                    decoration: loginFormField.copyWith(labelText: 'Password', icon: Icon(Icons.lock_outline, color: basicColor)),
                    onChanged: (text) {
                      setState(() => password = text);
                    },
                    validator: (value) {
                      if (!validatePassword(value)) {
                        return 'password must contain 8 characters with atleast one lowercase, one uppercase, one digit, and one special character';
                      }
                      return null;
                    },
                  )),
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
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Invalid email or password';
                                loading = false;
                              });
                            }
                            if (result == -1) {
                              setState(() {
                                error = 'Account not Verified, Check your email';
                                loading = false;
                              });
                            }
                            var net = await Connectivity().checkConnectivity();
                            if(net == ConnectivityResult.none) {
                              setState(() {
                                error = 'No Internet Connection';
                              });
                            }
                          }

                        }),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.05, left: width * 0.1, right: width * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(signup),
                      FlatButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyPhoneNo()
                              ),
                            );
                          },
                          child: Text("Signup here" , style: TextStyle(color:basicColor),))
                    ],
                  )),
              SizedBox(height: 10,),
              Text(error, style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    );
  }
}
