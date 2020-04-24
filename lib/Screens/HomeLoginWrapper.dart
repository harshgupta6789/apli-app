import 'package:apli/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/auth.dart';
import 'Home/mainScreen.dart';
import 'Login-Signup/login.dart';

//class HomeLoginWrapper extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamProvider<User>.value(
//        value: AuthService().user, child: Wrapper());
//  }
//}

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
      return Login();
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
