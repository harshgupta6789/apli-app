import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/currentEdu.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/diploma.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/tenth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationOverview extends StatefulWidget {
  @override
  _EducationOverviewState createState() => _EducationOverviewState();
}

double height, width;

class _EducationOverviewState extends State<EducationOverview> {
  double fontSize = 16;
  bool loading = false, error = false;
  String email;
  String batchId;
  int semToBuild = 1;
  String course, branch, duration;
  String unit;
  String institute, stream, board, cgpa;
  DateTime from, to;
  Map<int, dynamic> sems = {};
  Map<dynamic, dynamic> completeEducation = {
    // 'X': {
    //   'board': "",
    //   'certificate': "",
    //   'institute': "",
    //   'score': "",
    //   'score_unit': "",
    //   'specialization': "",
    //   'start': "",
    //   'end': "",
    // },
    // 'XII': {
    //   'board': "",
    //   'certificate': "",
    //   'institute': "",
    //   'score': "",
    //   'score_unit': "",
    //   'specialization': "",
    //   'start': "",
    //   'end': "",
    // },
  };

  void getInfo() async {
    try {
      await SharedPreferences.getInstance().then((prefs) async {
        await Firestore.instance
            .collection('candidates')
            .document(prefs.getString('email'))
            .get()
            .then((s) {
          batchId = s.data['batch_id'];
          if (batchId != null) {
            var details = Firestore.instance
                .collection('batches')
                .where('batch_id', isEqualTo: batchId)
                .limit(1);
            details.getDocuments().then((data) {
              setState(() {
                if (s.data['education'] == null) {
                  completeEducation['XII'] = {
                    'board': "",
                    'certificate': "",
                    'institute': "",
                    'score': "",
                    'score_unit': "",
                    'specialization': "",
                  };
                  completeEducation['X'] = {
                    'board': "",
                    'certificate': "",
                    'institute': "",
                    'score': "",
                    'score_unit': "",
                    'specialization': "",
                  };
                } else {
                  completeEducation['XII'] = s.data['education']['XII'] ??
                      {
                        'board': "",
                        'certificate': "",
                        'institute': "",
                        'score': "",
                        'score_unit': "",
                        'specialization': "",
                      };
                  completeEducation['X'] = s.data['education']['X'] ??
                      {
                        'board': "",
                        'certificate': "",
                        'institute': "",
                        'score': "",
                        'score_unit': "",
                        'specialization': "",
                      };
                }

                email = s.data['email'];

                semToBuild = data.documents[0].data['total_semester'];
                course = data.documents[0].data['course'];
                branch = data.documents[0].data['branch'];
                duration = data.documents[0].data['batch_year'];

                if (s.data['education'] != null) {
                  if (s.data['education'][course] != null) {
                    if (s.data['education'][course]['sem_records'] != null) {
                      for (int i = 0; i < semToBuild; i++) {
                        sems[i] = {
                          'certificate': s.data['education'][course]
                                  ['sem_records'][i]['certificate']
                              .toString(),
                          'closed_backlog': s.data['education'][course]
                                  ['sem_records'][i]['closed_backlog']
                              .toString(),
                          'live_backlog': s.data['education'][course]
                                  ['sem_records'][i]['live_backlog']
                              .toString(),
                          'semester_score': s.data['education'][course]
                                  ['sem_records'][i]['semester_score']
                              .toString()
                        };
                      }
                      completeEducation[course] = {'sem_records': sems};

                      //print(s.data['education'][course]['sem_records'][0]);

                    }
                  }
                }
                print(completeEducation);
              });
            });
          } else {
            setState(() {
              email = s.data['email'];
            });
          }

          print(email);
        });
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return email == null
        ? Loading()
        : loading
            ? Loading()
            : Scaffold(
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
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, 40.0, width * 0.05, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            clg,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 20.0, 10.0, 20.0),
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 10.0, 10.0),
                                    child: Text(
                                      noDetails,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 10.0, 10.0),
                                      child: FlatButton(
                                          onPressed: () {
                                            print(completeEducation);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CurrentEducation(
                                                            sem: semToBuild,
                                                            course: course,
                                                            duration: duration,
                                                            branch: branch,
                                                            education:
                                                                completeEducation)));
                                          },
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
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 20.0, 10.0, 20.0),
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 10.0, 10.0),
                                    child: Text(
                                      noDetails,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 10.0, 10.0),
                                      child: FlatButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CurrentEducation(
                                                          sem: semToBuild,
                                                          course: course,
                                                          duration: duration,
                                                          branch: branch,
                                                          education:
                                                              completeEducation))),
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
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 20.0, 10.0, 20.0),
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 10.0, 10.0),
                                    child: Text(
                                      noDetails,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 10.0, 10.0),
                                      child: FlatButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Diploma(
                                                      xii: completeEducation))),
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
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0.0, 20.0, 10.0, 10.0),
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 20.0, 10.0, 10.0),
                                    child: Text(
                                      noDetails,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 10.0, 10.0),
                                      child: FlatButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Tenth(
                                                      x: completeEducation))),
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
                          SizedBox(
                            height: 40,
                          )
                        ]),
                  )),
                  behavior: MyBehavior(),
                ),
              );
  }
}
