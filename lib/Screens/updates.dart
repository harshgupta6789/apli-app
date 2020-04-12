import 'package:apli/Shared/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
             
              IconButton(
                  icon: Icon(
                    EvaIcons.menu2Outline,
                    color: Colors.white,
                  ),
                  onPressed: null),
            ],
            title: Text(
              updates,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[]),
        ));
  }
}
