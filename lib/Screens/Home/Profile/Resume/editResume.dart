import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'Profile-Tabs/certi.dart';
import 'Profile-Tabs/edu.dart';
import 'Profile-Tabs/exp.dart';
import 'Profile-Tabs/extraC.dart';
import 'Profile-Tabs/intro.dart';
import 'Profile-Tabs/projects.dart';
import 'Profile-Tabs/skills.dart';

class EditResume extends StatefulWidget {
  @override
  _EditResumeState createState() => _EditResumeState();
}

class _EditResumeState extends State<EditResume> {
  double height, width;

  Widget resumeTile(String text, Widget x) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4))),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => x));
            },
            child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: IconButton(
                  icon: Icon(EvaIcons.arrowIosForwardOutline),
                )),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
        preferredSize: Size.fromHeight(50),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.1,
              left: width * 0.05,
              right: width * 0.05,
              bottom: height * 0.1),
          child: Column(
            children: <Widget>[
              resumeTile(intro, BasicIntro()),
              resumeTile(education, Education()),
              resumeTile(experience, Expereince()),
              resumeTile(projects, Projects()),
              resumeTile(extra, ExtraC()),
              resumeTile(awards, Awards()),
              resumeTile(skills, Skills()),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )),
      ),
    );
  }
}
