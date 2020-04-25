import 'package:apli/Screens/HomeLoginWrapper.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  @override
  MySplashState createState() => new MySplashState();
}

class MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      navigateAfterSeconds: Wrapper(),
      image: Image.asset('Assets/Images/logo.png'),
      photoSize: 100.0,
      loaderColor: basicColor,
    );
  }
}
