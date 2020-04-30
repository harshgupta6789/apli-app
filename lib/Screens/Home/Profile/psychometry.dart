import 'package:apli/Screens/Home/Profile/psychometryTest.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Psychometry extends StatefulWidget {
  String email;
  Psychometry({this.email});
  @override
  _PsychometryState createState() => _PsychometryState();
}

enum States { none, resume, done }

class _PsychometryState extends State<Psychometry> {
  States _currentState;
  Map<String, dynamic> questions, answeredQuestions;
  String email;

  userInit() async {
    await SharedPreferences.getInstance().then((prefs) async {
      setState(() {
        email = prefs.getString('email');
      });
      await Firestore.instance
          .collection('candPsychoQues')
          .document('all_ques')
          .get()
          .then((snapshot) async {
        setState(() {
          questions = snapshot.data;
        });
        await Firestore.instance
            .collection('candidates')
            .document(email)
            .get()
            .then((snapshot2) {
          setState(() {
            answeredQuestions = snapshot2.data['psycho_ques'];
          });
          if (answeredQuestions == null) {
            setState(() {
              _currentState = States.none;
            });
          } else if (answeredQuestions.length < questions.length) {
            setState(() {
              _currentState = States.resume;
            });
          } else {
            setState(() {
              _currentState = States.done;
            });
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    userInit();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case States.none:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                  child: Align(
                      child: Text(psychometryTestSlogan,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                  child: Align(
                      child: Text("Instructions to follow",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: basicColor)),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 35, 8, 8),
                  child: Align(
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 22, right: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: basicColor, width: 1.5),
                      ),
                      child: Text(
                        'Start Test',
                        style: TextStyle(
                            color: basicColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PsychometryTest(
                                      email: email,
                                      questions: questions,
                                      answeredQuestions: answeredQuestions,
                                    )));
                      },
                    ),
                    alignment: Alignment.center,
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case States.resume:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                  child: Align(
                      child: Text("Finish your psychometic test!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 4, 8, 40),
                  child: Align(
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 22, right: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: basicColor, width: 1.5),
                      ),
                      child: Text(
                        'Resume Test',
                        style: TextStyle(
                            color: basicColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PsychometryTest(
                                      email: email,
                                      questions: questions,
                                      answeredQuestions: answeredQuestions,
                                    )));
                      },
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                  child: Align(
                      child: Text("Instructions to follow",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: basicColor)),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
              ],
            ),
          ),
        );
        break;
      case States.done:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                  child: Align(
                      child: Text(
                          'You have attempted the psychometric\n test! Your answers have been recorded.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      alignment: Alignment.center),
                ),
              ],
            ),
          ),
        );
        break;
      default:
        return Loading();
    }
  }
}
