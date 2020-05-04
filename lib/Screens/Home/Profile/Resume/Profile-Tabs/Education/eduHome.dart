import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/currentEdu.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/diploma.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/tenth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:flutter/material.dart';

class EducationOverview extends StatefulWidget {
  @override
  _EducationOverviewState createState() => _EducationOverviewState();
}

double height, width;

class _EducationOverviewState extends State<EducationOverview> {

  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: basicColor,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              education,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
          ),
        ),
        preferredSize: Size.fromHeight(55),
      ),
      body: ScrollConfiguration(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(width * 0.05, 40.0, width * 0.05, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Text(
              clg,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
              child: Container(
                width: width,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                      child: Text(
                        noDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                        child: FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CurrentEducation())),
                            child: Text(
                              "Add now",
                              style: TextStyle(
                                  color: basicColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ),
            ),
            Text(
              otherCourses,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
              child: Container(
                width: width,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                      child: Text(
                        noDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                        child: FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CurrentEducation())),
                            child: Text(
                              "Add now",
                              style: TextStyle(
                                  color: basicColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ),
            ),
            Text(
              twelve,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
              child: Container(
                width: width,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                      child: Text(
                        noDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                        child: FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Diploma())),
                            child: Text(
                              "Add now",
                              style: TextStyle(
                                  color: basicColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ),
            ),
            Text(
              ten,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
              child: Container(
                width: width,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                      child: Text(
                        noDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 10.0),
                        child: FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tenth())),
                            child: Text(
                              "Add now",
                              style: TextStyle(
                                  color: basicColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ),
            ),
                SizedBox(height: 40,)
          ]),
        )),
        behavior: MyBehavior(),
      ),
    );
  }
}
