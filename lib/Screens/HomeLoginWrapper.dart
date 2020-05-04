import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/mainScreen.dart';
import 'Login-Signup/Login/login.dart';

class Wrapper extends StatefulWidget {
  int currentTab;
  Wrapper({this.currentTab});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences preferences;
  String email;

  getPref() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString('email', 'harshhvg999@gmail.com');
    setState(() {
      email = 'harshhvg999@gmail.com';
    });
    if (preferences.containsKey('email')) {
      if(preferences.containsKey('rememberMe')) {
        if (preferences.getBool('rememberMe')) {
          setState(() {
            email = preferences.getString('email');
          });
        } else {
          preferences.clear();
        }
      } else {
        preferences.clear();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (email == null) {
      return Login();
    } else {
      return MainScreen(currentTab: widget.currentTab);
    }
  }
}
