import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
       backgroundColor: Colors.white,
        endDrawer: customDrawer(context),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
             
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
            ],
            title: Text(
              profile,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top:300.0),
               child: Center(child: Image.asset("Assets/Images/job.png")),
             ),
          ]),
        ));
  }
}