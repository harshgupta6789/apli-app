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
    if (preferences.containsKey('email')) {
      if (preferences.getBool('rememberMe')) {
        setState(() {
          email = preferences.getString('email');
        });
      } else
        preferences.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {

     
      return MainScreen(currentTab: widget.currentTab);
   
}
}
