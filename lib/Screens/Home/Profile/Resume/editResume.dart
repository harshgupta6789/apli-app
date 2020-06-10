import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/eduHome.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/ExtraCurriculars/extraCurricular.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Projects/project.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../HomeLoginWrapper.dart';
import 'Profile-Tabs/Experience/experience.dart';
import 'Profile-Tabs/awards.dart';
import 'Profile-Tabs/intro.dart';
import 'Profile-Tabs/skills.dart';

class EditResume extends StatefulWidget {
  @override
  _EditResumeState createState() => _EditResumeState();
}

class _EditResumeState extends State<EditResume> {
  double height, width;
  bool result = false;

  Widget resumeTile(String text, Widget x) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4))),
          child: InkWell(
            splashColor: basicColor,
            onTap: () async {
              result = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => x));
              print(result);
              if (result != null) {
                setState(() {
                  result = true;
                });
              }
              setState(() {
                result = true;
              });
            },
            child: ListTile(
                title: Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(EvaIcons.arrowIosForwardOutline)),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        if (result == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Wrapper(
                        currentTab: 4,
                      )),
              (Route<dynamic> route) => false);
        } else
          Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: AppBar(
              backgroundColor: basicColor,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (result == true) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Wrapper(
                                      currentTab: 4,
                                    )),
                            (Route<dynamic> route) => false);
                      } else
                        Navigator.pop(context);
                    }),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  editResume,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              )),
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
                resumeTile(education, EducationOverview()),
                resumeTile(experience, Experience()),
                resumeTile(projects, Project()),
                resumeTile(extra, ExtraCurricular()),
                resumeTile(awards, Awards()),
                resumeTile(skills, Skills()),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )),
        ),
      ),
    );
  }
}
