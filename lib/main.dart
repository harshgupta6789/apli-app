import 'package:apli/Screens/HomeLoginWrapper.dart';
import 'package:apli/Services/themeProvider.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ChangeNotifierProvider<ThemeChanger>(
    create: (_) => ThemeChanger(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apli',
      theme: theme.getTheme(),
      // theme: ThemeData(
      //     primarySwatch: Colors.blue,
      //     appBarTheme: AppBarTheme(color: basicColor),
      //     accentColor: basicColor,
      //     fontFamily: 'Sans'),
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
      backgroundColor: Theme.of(context).backgroundColor,
      seconds: 1,
      navigateAfterSeconds: Wrapper(),   // USED A WRAPPER CLASS TO ROUTE EASILY BETWEEN LOGIN AND HOMESCREEN PAGE//
      image: Image.asset('Assets/Images/logo.png'),
      photoSize: 100.0,
      loaderColor: basicColor,
    );
  }
}
