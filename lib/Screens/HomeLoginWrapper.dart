import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/mainScreen.dart';
import 'Login-Signup/login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences preferences;
  String email;

  getPref() async{
    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('email')) {
      if(preferences.containsKey('rememberMe')){
        setState(() {
          email = preferences.getString('email');
        });
      }
      else preferences.clear();
    }
    preferences.setString('email', 'harshhvg999@gmail.com');

  }
  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    if(email == null) {
      return MainScreen();
    } else {
      return MainScreen();
    }
//    if (user == null) {
//      return Login();
//    } else {
//      return MainScreen();
//    }
  }
}
