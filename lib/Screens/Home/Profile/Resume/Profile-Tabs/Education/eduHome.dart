import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/currentEdu.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/diploma.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCourses.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/tenth.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationOverview extends StatefulWidget {
  @override
  _EducationOverviewState createState() => _EducationOverviewState();
}

double height, width;

class _EducationOverviewState extends State<EducationOverview> {

  // THIS FILE IS IMPORTANT , BECAUSE IT HANDLES THE ENTIRE FLOW OF EDUCATION //
  // THE FLOW IS : CURRENT EDUCATION => DIPLOMA / XII => TENTH => OTHER COURSES (IF ANY) => API CALL //

  double fontSize = 16;
  bool loading = false, error = false;
  String email;
  String batchId;
  int semToBuild = 1;
  bool isUg = false;
  String course, branch, duration, type;
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

  // THIS METHOD FETCHES THE ENTIRE EDUCATION MAP FROM FIREBASE DATABASE //
  // DEPENDING UPON THE RETURNED DATA , THE MAP EITHER HAS DATA OR IT HAS ONLY KEYS //

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
                completeEducation = s.data['education'] ?? {};
                if (completeEducation['XII'] == null &&
                    completeEducation['Diploma'] == null) {
                  type = null;
                } else if (completeEducation.containsKey('XII'))
                  type = 'XII';
                else
                  type = 'Diploma';
                if (completeEducation['X'] == null) {
                  completeEducation['X'] = {
                    'board': "",
                    'certificate': null,
                    'institute': "",
                    'score': '',
                    'score_unit': "%",
                    'specialization': "",
                    'start': Timestamp.now(),
                    'end': Timestamp.now()
                  };
                }
                completeEducation['current_education'] = course;
                if (completeEducation[course] == null) {
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
              });
            });
          } else {
            setState(() {
              error = true;
            });
          }
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

  // WE USE PAGE VIEW TO HANDLE THE FLOW FROM THIS SCREEN AND AHEAD //

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return error
        ? Scaffold(
            body: Center(
              child: Text('Error occured, try again later'),
            ),
          )
        : email == null
            ? Loading()
            : loading
                ? Loading()
                : WillPopScope(
                    child: Scaffold(
                      backgroundColor: Theme.of(context).backgroundColor,
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
                            type: type,
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
                            oth: completeEducation,
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
                  'Yes',
                  style: TextStyle(),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
