import 'package:apli/Screens/Login-Signup/login.dart';
import 'package:apli/Screens/mainScreen.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPref() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('seen') == null) {
      setState(() {
        preferences.setBool('seen', false);
      });
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(color: basicColor),
            accentColor: basicColor,
            fontFamily: 'Sans'),
        home: preferences.getBool('seen') ? MainScreen() : Login());
  }
}
