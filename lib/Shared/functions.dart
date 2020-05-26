import 'package:apli/Shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

showToast(String msg, BuildContext context,
    {int duration, Color color, int gravity}) {
  Toast.show(msg, context,
      backgroundColor: color ?? basicColor,
      duration: duration ?? 3,
//      border: Border.all(
//        color: color ?? basicColor,
//      ),
      textColor: Colors.white,
      backgroundRadius: 4,
      gravity: gravity ?? Toast.BOTTOM);
}

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

int decimalToBinary(int decimal) {
  int binary = 0, i = 1;
  while (decimal > 0) {
    binary = binary + (decimal % 2) * i;
    decimal = (decimal / 2).floor();
    i = i * 10;
  }
  return binary;
}

int binaryToDecimal(int binary) {
  int decimal = 0, n = 0;
  decimal = int.tryParse(binary.toString(), radix: 2);
  return decimal;
}

String getFileNameFromURL(String url) {
  Pattern pattern = r'[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))';
  RegExp regExp = new RegExp(pattern);
  return regExp.stringMatch(url);
}

String dateToReadableTimeConverter(DateTime dt) {
  String time, monthString;
  switch (dt.month) {
    case 1:
      monthString = "Jan";
      break;
    case 2:
      monthString = "Feb";
      break;
    case 3:
      monthString = "March";
      break;
    case 4:
      monthString = "April";
      break;
    case 5:
      monthString = "May";
      break;
    case 6:
      monthString = "June";
      break;
    case 7:
      monthString = "July";
      break;
    case 8:
      monthString = "Aug";
      break;
    case 9:
      monthString = "Sep";
      break;
    case 10:
      monthString = "Oct";
      break;
    case 11:
      monthString = "Nov";
      break;
    case 12:
      monthString = "Dec";
      break;
    default:
      monthString = "Invalid month";
      break;
  }
  time = dt.day.toString() + ' ' + monthString + ' ' + dt.year.toString();
  TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dt);
  time = time +
      ', ' +
      (timeOfDay.hour.toString().length == 1
          ? '0' + timeOfDay.hour.toString()
          : timeOfDay.hour.toString()) +
      ':' +
      (timeOfDay.minute.toString().length == 1
          ? '0' + timeOfDay.minute.toString()
          : timeOfDay.minute.toString()) +
      ' ' +
      ((timeOfDay.period == DayPeriod.am) ? 'AM' : 'PM');
  return time;
}

InputDecoration x(String t) {
  return InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 13,
            ),
            Text(t + " : "),
          ],
        ),
      ),
      //hintText: t,

      border:
          OutlineInputBorder(borderSide: BorderSide(color: Color(0xff4285f4))),
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Color(0xff4285f4))),
      contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      hintStyle: TextStyle(fontWeight: FontWeight.w400),
      labelStyle: TextStyle(color: Colors.black));
}
