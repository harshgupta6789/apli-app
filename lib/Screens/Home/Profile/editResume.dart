import 'package:apli/Screens/Home/Profile/Profile-Tabs/edu.dart';
import 'package:apli/Shared/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class EditResume extends StatefulWidget {
  @override
  _EditResumeState createState() => _EditResumeState();
}

class _EditResumeState extends State<EditResume> {
  Widget resumeTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4))),
          child: ListTile(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForwardOutline),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Education()));
                }),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: basicColor,
          automaticallyImplyLeading: true,
          title: Text(
            editResume,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            resumeTile(intro),
            resumeTile(about),
            resumeTile(experience),
            resumeTile(education),
            resumeTile(licenses),
            resumeTile(skills),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      )),
    );
  }
}
