import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../HomeLoginWrapper.dart';

class PsychometryTest extends StatefulWidget {
  String email;
  int status;
  Map<String, dynamic> questions, answeredQuestions;
  PsychometryTest(
      {this.email, this.questions, this.answeredQuestions, this.status});
  @override
  _PsychometryTestState createState() => _PsychometryTestState();
}

class _PsychometryTestState extends State<PsychometryTest> {
  double width, height;

  // ONCE CANDIDATE HAS CHOSEN TO START THE TEST HE IS REDIRECTED HERE //
  // THE LIST OF OPTION IS STAIC //

  Map<String, dynamic> questions, answeredQuestions;
  List<List<String>> remainingQuestions = [];
  List<String> options = [
    'Completely Agree',
    'Very Much Agree',
    'Somewhat Agree',
    'Somewhat Disagree',
    'Very Much Disagree',
    'Completely Disagree'
  ];

  bool allDone = false, visibleNext = false, loading = false;

  PageController controller =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  var currentPageValue = 0.0;

  findRemainingQuestions() {
    remainingQuestions = [];
    questions = widget.questions;
    answeredQuestions = widget.answeredQuestions ?? {};
    questions.forEach((k1, v1) {
      bool temp = true;
      if (answeredQuestions != null) {
        answeredQuestions.forEach((k2, v2) {
          if (v2['question'] == v1) {
            temp = false;
          }
        });
      }
      if (temp) {
        remainingQuestions.add([k1, v1, null]);
      }
      if (mounted) setState(() {});
    });
  }

  sortRemainingQuestions() {
    List<List<String>> temp = [];
    for (int i = 0; i < remainingQuestions.length; i++) {
      temp.add([]);
    }
    for (int i = 0; i < remainingQuestions.length; i++) {
      temp[int.parse(remainingQuestions[i][0].substring(1)) - 1] =
          remainingQuestions[i];
    }
    remainingQuestions = temp;
    setState(() {});
  }

  checkCount() {
    int count = 0;
    remainingQuestions.forEach((f) {
      if (f[2] != null) count++;
    });
    if (count == remainingQuestions.length)
      setState(() {
        allDone = true;
      });
  }

  @override
  void initState() {
    super.initState();
    findRemainingQuestions();
    sortRemainingQuestions();
    controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return;
      },
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(55),
                child: AppBar(
                  backgroundColor: basicColor,
                  title: Text(
                    'Psychometric Test',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Visibility(
                visible: allDone,
                child: FloatingActionButton.extended(
                  elevation: 5,
                  onPressed: () async {

                 // THIS IS THE METHOD WHICH UPDATES THE CANDIDATE'S QUESTIONS ETC , AFTER HE HAS CLICKED NEXT //
                 // AGAIN IT USES FIREBASE DATABASE TO WRITE AND CAN BE REFERRED FOR FUTURE USE //

                    setState(() {
                      loading = true;
                    });
                    int j = 0;
                    for (int i = 1; i < questions.length + 1; i++) {
                      if (!answeredQuestions.containsKey(i.toString()))
                        answeredQuestions[i.toString()] = {
                          'question': remainingQuestions[j][1],
                          'response': remainingQuestions[j++][2]
                        };
                    }
                    int temp = decimalToBinary(widget.status);
                    temp = ((temp ~/ 10) * 10) + 1;
                    temp = binaryToDecimal(temp);
                    await Firestore.instance
                        .collection('candidates')
                        .document(widget.email)
                        .setData({
                      'psycho_ques': answeredQuestions,
                      'profile_status': temp
                    }, merge: true).then((f) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Wrapper(
                                    currentTab: 4,
                                    profileTab: 2,
                                  )),
                          (Route<dynamic> route) => false);
                    });
                  },
                  backgroundColor: basicColor,
                  label: Text(
                    'SUBMIT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              body: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: PageView.builder(
                  itemCount: remainingQuestions.length,
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, position) {
                    return ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 8, 12),
                                  child: Align(
                                      child: Text('Q${position + 1}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      alignment: Alignment.topLeft)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(remainingQuestions[position][1],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              border: Border.all(
                                                  width: remainingQuestions[
                                                              position][2] ==
                                                          (i + 1).toString()
                                                      ? 1
                                                      : 2,
                                                  color: remainingQuestions[
                                                              position][2] ==
                                                          (i + 1).toString()
                                                      ? basicColor
                                                      : Colors.grey
                                                          .withOpacity(0.4))),
                                          child: ListTile(
                                            dense: false,
                                            title: Text(
                                              options[i],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: remainingQuestions[
                                                              position][2] ==
                                                          (i + 1).toString()
                                                      ? basicColor
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          .color,
                                                  fontSize: 13),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                remainingQuestions[position]
                                                    [2] = (i + 1).toString();
                                                checkCount();
                                                visibleNext = true;
                                              });
                                            },
                                          )),
                                    );
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Visibility(
                                    visible:
                                        false, //position == 0 ? false : true,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                                      child: Align(
                                        child: RaisedButton(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          padding: EdgeInsets.only(
                                              left: 22, right: 22),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            side: BorderSide(
                                                color: basicColor, width: 1.5),
                                          ),
                                          child: Text(
                                            'Back',
                                            style: TextStyle(color: basicColor),
                                          ),
                                          onPressed: () {
                                            controller.animateToPage(
                                                position - 1,
                                                duration:
                                                    Duration(milliseconds: 200),
                                                curve: Curves.linear);
                                          },
                                        ),
                                        alignment: Alignment.bottomLeft,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleNext,
                                    child: Visibility(
                                      visible: position ==
                                              remainingQuestions.length - 1
                                          ? false
                                          : true,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                                        child: Align(
                                          child: RaisedButton(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: basicColor,
                                                  width: 1.5),
                                            ),
                                            child: Text(
                                              'Next',
                                              style:
                                                  TextStyle(color: basicColor),
                                            ),
                                            onPressed: () {
                                              controller.animateToPage(
                                                  position + 1,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.linear);
                                              setState(() {
                                                visibleNext = false;
                                              });
                                            },
                                          ),
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Leaving the test midway will not save your answers! You will have to reattempt the test later. Are you sure you want to leave the test?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
