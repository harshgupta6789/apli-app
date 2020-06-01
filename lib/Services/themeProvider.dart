import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  SharedPreferences prefs;
  Color accentColor;

  ThemeChanger() {
    this._themeData = lightTheme();
    this.accentColor = basicColor;
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "light";
    if (theme == "light") {
      updateTheme(lightTheme());
    } else if (theme == "dark") {
      updateTheme(darkTheme());
    } else if (theme == "black") {
      updateTheme(blackTheme());
    }
  }

  getTheme() {
    return _themeData;
  }

  updateTheme(ThemeData theme) async {
    _themeData = theme;
    //print(_themeData.backgroundColor);
    notifyListeners();
  }

  setTheme(ThemeData theme) async {
    if (theme == lightTheme()) {
      prefs.setString("theme", "light");
    } else if (theme == darkTheme()) {
      prefs.setString("theme", "dark");
    } else if (theme == blackTheme()) {
      prefs.setString("theme", "black");
    }
    _themeData = theme;
    notifyListeners();
  }
}

darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(headline4: TextStyle(color: Colors.white)),
    appBarTheme: AppBarTheme(color: basicColor),
    fontFamily: 'Sans',
    accentColor: basicColor,
    cardColor: Colors.black,
    cardTheme: CardTheme(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Colors.black87,
  );
}

blackTheme() {
  return ThemeData(
      primarySwatch: Colors.blue,
      appBarTheme: AppBarTheme(color: basicColor),
      fontFamily: 'Sans',
      cardColor: Colors.black87,
      cardTheme: CardTheme(color: Colors.black87),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      textTheme: TextTheme());
}

lightTheme() {
  return ThemeData(
      textTheme: TextTheme(headline4: TextStyle(color: Colors.black)),
      primarySwatch: Colors.blue,
      appBarTheme: AppBarTheme(color: basicColor),
      fontFamily: 'Sans',
      //cardColor: Colors.white,
      //cardTheme: CardTheme(color: Colors.white.withOpacity(0.9)),
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.grey),
      backgroundColor: Colors.white);
}
