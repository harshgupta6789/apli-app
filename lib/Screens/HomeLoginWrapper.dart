
import 'package:apli/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/auth.dart';
import 'Home/mainScreen.dart';
import 'Login-Signup/login.dart';
import 'Login-Signup/register.dart';

class HomeLoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: Wrapper()

    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(user == null) {
      return Register();
    } else {
      return MainScreen();
    }
  }
}

