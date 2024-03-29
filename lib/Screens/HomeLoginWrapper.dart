import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/mainScreen.dart';
import 'Login-Signup/Login/login.dart';

class Wrapper extends StatefulWidget {
  final int currentTab;
  final int profileTab;
  Wrapper({this.currentTab, this.profileTab});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences preferences;
  String email;

  getPref() async {
    // IF EMAIL IS SAVED THEN => GO TO HOMESCREEN //
    // ELSE ASK HIM TO LOGIN //

    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('email')) {
      if (preferences.containsKey('rememberMe')) {
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
      return MainScreen(
        currentTab: widget.currentTab,
        profileTab: widget.profileTab,
      );
    }
  }
}
