import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

bool validateEmail(String value) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(value);
}

bool validatePassword(String value) {
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = new RegExp(pattern);
  if (value.length < 8) {
    return false;
  } else {
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }
}

showToast(String msg, BuildContext context) {
  Toast.show(msg, context, backgroundColor: Colors.red, duration: 3);
}

InputDecoration x(String t) {
  return InputDecoration(
      hintText: t,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff4285f4))),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff4285f4))),
      contentPadding:
      new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      hintStyle: TextStyle(fontWeight: FontWeight.w400),
      labelStyle: TextStyle(color: Colors.black));
}