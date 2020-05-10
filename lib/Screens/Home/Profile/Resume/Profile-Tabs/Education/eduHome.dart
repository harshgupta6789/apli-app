import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/currentEdu.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/diploma.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCourses.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/tenth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  bool isUg = false;
  String course, branch, duration;
  String unit;
  String institute, stream, board, cgpa;
  DateTime from, to;
  Map<int, dynamic> sems = {};
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
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
                email = s.data['email'];

                semToBuild = data.documents[0].data['total_semester'];
                course = data.documents[0].data['course'];
                branch = data.documents[0].data['branch'];
                duration = data.documents[0].data['batch_year'];
                isUg = data.documents[0].data['is_ug'] ?? false;
                if (s.data['education'] == null) {
                  completeEducation['XII'] = {
                    'board': "",
                    'certificate': null,
                    'institute': "",
                    'score': 0,
                    'score_unit': "%",
                    'specialization': "",
                    'start': Timestamp.now(),
                    'end': Timestamp.now()
                  };
                  completeEducation['X'] = {
                    'board': "",
                    'certificate': null,
                    'institute': "",
                    'score': 0,
                    'score_unit': "%",
                    'specialization': "",
                    'start': Timestamp.now(),
                    'end': Timestamp.now()
                  };
                } else {
                  completeEducation['XII'] = s.data['education']['XII'] ??
                      {
                        'board': "",
                        'certificate': null,
                        'institute': "",
                        'score': 0,
                        'score_unit': "%",
                        'specialization': "",
                        'start': Timestamp.now(),
                        'end': Timestamp.now()
                      };
                  completeEducation['X'] = s.data['education']['X'] ??
                      {
                        'board': "",
                        'certificate': null,
                        'institute': "",
                        'score': 0,
                        'score_unit': "%",
                        'specialization': "",
                        'start': Timestamp.now(),
                        'end': Timestamp.now()
                      };
                  completeEducation[course] = s.data['education'][course] ?? {};
                }

                if (s.data['education'] != null) {
                  if (s.data['education'][course] != null) {
                    if (s.data['education'][course]['sem_records'] != null) {
                      for (int i = 0; i < semToBuild; i++) {
                        sems[i] = {
                          'certificate': s.data['education'][course]
                              ['sem_records'][i]['certificate'],
                          'closed_backlog': s.data['education'][course]
                              ['sem_records'][i]['closed_backlog'],
                          'live_backlog': s.data['education'][course]
                              ['sem_records'][i]['live_backlog'],
                          'semester_score': s.data['education'][course]
                              ['sem_records'][i]['semester_score']
                        };
                      }
                      completeEducation[course]['sem_records'] = sems;
                    } else {
                      for (int i = 0; i < semToBuild; i++) {
                        sems[i] = {
                          'certificate': null,
                          'closed_backlog': 0,
                          'live_backlog': 0,
                          'semester_score': 0
                        };
                      }
                      completeEducation[course] = {
                        'score': 0,
                        'total_closed_backlogs': 0,
                        'total_live_backlogs': 0,
                        'sem_records': sems,
                      };
                    }
                  } else {
                    for (int i = 0; i < semToBuild; i++) {
                      sems[i] = {
                        'certificate': null,
                        'closed_backlog': 0,
                        'live_backlog': 0,
                        'semester_score': 0
                      };
                    }
                    completeEducation[course] = {
                      'score': 0,
                      'total_closed_backlogs': 0,
                      'total_live_backlogs': 0,
                      'sem_records': sems,
                    };
                  }
                } else {
                  for (int i = 0; i < semToBuild; i++) {
                    sems[i] = {
                      'certificate': null,
                      'closed_backlog': 0,
                      'live_backlog': 0,
                      'semester_score': 0
                    };
                  }
                  completeEducation[course] = {
                    'score': 0,
                    'total_closed_backlogs': 0,
                    'total_live_backlogs': 0,
                    'sem_records': sems,
                  };
                  print(completeEducation[course]['sem_records']);
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
            : WillPopScope(
                child: Scaffold(
                  body: PageView(
                    physics: new NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: <Widget>[
                      CurrentEducation(
                        sem: semToBuild,
                        course: course,
                        duration: duration,
                        branch: branch,
                        education: completeEducation,
                        isUg: isUg,
                        onButtonPressed: () {
                          pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Diploma(
                        xii: completeEducation,
                      ),
                      Tenth(
                        x: completeEducation,
                      ),
                      Other(
                        x: completeEducation,
                      )
                    ],
                  ),
                ),
                onWillPop: () {
                  _onWillPop();
                  return;
                },
              );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Leaving the form midway will not save your data! You will have to fill the form again from start. Are you sure you want to go back?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'Yes, I want to go back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
