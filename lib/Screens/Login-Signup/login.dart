import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import '../mainScreen.dart';

double height, width;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: height * 0.3, right: width * 0.5),
            child: Image.asset("Assets/Images/logo.png"),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: height * 0.05, left: width * 0.1, right: width * 0.1),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.email, color: basicColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff4285f4))),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.black)),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: height * 0.05, left: width * 0.1, right: width * 0.1),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline, color: basicColor),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff4285f4))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff4285f4))),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black)),
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
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()))),
              )),
              Padding(
              padding: EdgeInsets.only(
                  top: height * 0.05, left: width * 0.1, right: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(signup),
                  FlatButton(onPressed: null, child: Text("Signup here" , style: TextStyle(color:basicColor),))
                ],
              )),
        ],
      ),
    );
  }
}
