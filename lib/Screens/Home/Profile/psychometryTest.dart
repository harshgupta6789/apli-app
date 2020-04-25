import 'package:apli/Shared/animations.dart';
import 'package:apli/Shared/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class PsychometryTest extends StatefulWidget {
  Map<String, dynamic> questions, answeredQuestions;
  PsychometryTest({this.questions, this.answeredQuestions});
  @override
  _PsychometryTestState createState() => _PsychometryTestState();
}

class _PsychometryTestState extends State<PsychometryTest> {
  double width, height;

  Map<String, dynamic> questions, answeredQuestions, newAnsweredQuestions;
  List<List<String>> remainingQuestions = [];

  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  var currentPageValue = 0.0;

  findRemainingQuestions() {
    remainingQuestions = [];
    questions = widget.questions;
    answeredQuestions = widget.answeredQuestions;
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
      setState(() {});
    });
  }

//  sortRemainingQuestions() {
//    remainingQuestions.sort((a, b) {
//      int x = int.parse(a[0].substring(1));
//      int y = int.parse(b[0].substring(1));
//      return x.compareTo(y);
//    });
//    setState(() {
//
//    });
//  }

  @override
  void initState() {
    super.initState();
    findRemainingQuestions();
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
  }

  void changePageViewPostion(int whichPage) {
    if (controller != null) {
      whichPage = whichPage + 1; // because position will start from 0
      double jumpPosition = MediaQuery.of(context).size.width / 2;
      double orgPosition = MediaQuery.of(context).size.width / 2;
      for (int i = 0; i < remainingQuestions.length; i++) {
        controller.jumpTo(jumpPosition);
        if (i == whichPage) {
          break;
        }
        jumpPosition = jumpPosition + orgPosition;
      }
    }
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: basicColor,
            title: Text(
              'Psychometric Test',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: PageView.builder(
                itemCount: remainingQuestions.length,
                controller: controller,
                physics: PageScrollPhysics(),
                itemBuilder: (context, position) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                                child: Align(
                                    child: Text('Q${position + 1}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    alignment: Alignment.topLeft)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                              child: Align(
                                  child: Text(remainingQuestions[position][1],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  alignment: Alignment.topLeft),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4))),
                                  child: ListTile(
                                    title: Text(
                                      '1. Lorem ipsum dolor sit amet, consectetur',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Visibility(
                                  visible: position == 0 ? false : true,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8.0, 35, 8, 8),
                                    child: Align(
                                      child: RaisedButton(
                                        color: Colors.white,
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
                                          changePageViewPostion(position);
                                        },
                                      ),
                                      alignment: Alignment.bottomLeft,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      position == remainingQuestions.length - 1
                                          ? false
                                          : true,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8.0, 35, 8, 8),
                                    child: Align(
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: basicColor, width: 1.5),
                                        ),
                                        child: Text(
                                          'Next',
                                          style: TextStyle(color: basicColor),
                                        ),
                                        onPressed: () {
                                          changePageViewPostion(position + 2);
                                        },
                                      ),
                                      alignment: Alignment.bottomRight,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'Yes, I want to leave the test',
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
