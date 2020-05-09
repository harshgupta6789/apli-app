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
                isUg = data.documents[0].data['is_ug'];
                if (s.data['education'] == null) {
                  completeEducation['XII'] = {
                    'board': "",
                    'certificate': null,
                    'institute': "",
                    'score': "",
                    'score_unit': "%",
                    'specialization': "",
                  };
                  completeEducation['X'] = {
                    'board': "",
                    'certificate': null,
                    'institute': "",
                    'score': "",
                    'score_unit': "%",
                    'specialization': "",
                  };
                } else {
                  completeEducation['XII'] = s.data['education']['XII'] ??
                      {
                        'board': "",
                        'certificate': null,
                        'institute': "",
                        'score': "",
                        'score_unit': "%",
                        'specialization': "",
                      };
                  completeEducation['X'] = s.data['education']['X'] ??
                      {
                        'board': "",
                        'certificate': null,
                        'institute': "",
                        'score': "",
                        'score_unit': "%",
                        'specialization': "",
                      };
                  completeEducation[course] = s.data['education'][course] ?? {};
                }
                print(isUg);

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
                      completeEducation[course]['sem_records'] =  sems;

                    } else {
                      for (int i = 0; i < semToBuild; i++) {
                        sems[i] = {
                          'certificate': '',
                          'closed_backlog': '',
                          'live_backlog': '',
                          'semester_score': ''
                        };
                      }
                      completeEducation[course] = {
                        'score': '',
                        'total_closed_backlogs': '',
                        'total_live_backlogs': '',
                        'sem_records' : sems,
                      };
                    }
                  } else {
                    for (int i = 0; i < semToBuild; i++) {
                      sems[i] = {
                        'certificate': '',
                        'closed_backlog': '',
                        'live_backlog': '',
                        'semester_score': ''
                      };
                    }
                    completeEducation[course] = {
                      'score': '',
                      'total_closed_backlogs': '',
                      'total_live_backlogs': '',
                      'sem_records' : sems,
                    };
                  }
                } else {
                  for (int i = 0; i < semToBuild; i++) {
                    sems[i] = {
                      'certificate': '',
                      'closed_backlog': '',
                      'live_backlog': '',
                      'semester_score': ''
                    };
                  }
                  completeEducation[course] = {
                    'score': '',
                    'total_closed_backlogs': '',
                    'total_live_backlogs': '',
                    'sem_records' : sems,
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
                        onButtonPressed: () {
                          pageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear,
                          );
                        },
                      ),
                      Tenth(
                          x: completeEducation,
                          popOrOther: true,
                          onButtonPressed: () {
                            if (isUg != null && isUg == true) {
                              pageController.animateToPage(
                                3,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear,
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          }),
                      Other(
                          x: completeEducation,
                          popOrOther: isUg,
                          onButtonPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ), onWillPop: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        tittle: "Are You Sure?",
                        desc: "Yes!",
                        btnCancelText: "Cancel",
                        btnCancelOnPress: () {
                          //Navigator.of(context).pop();
                        },
                        btnOkOnPress: () async {
                         Navigator.pop(context);
                        },
                        btnOkText: "I Understand!",
                      ).show();
          return null;
                },
            );
  }
}
