import 'package:apli/Shared/animations.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';

class PsychometryTest extends StatefulWidget {

  Map<String, dynamic> questions, answeredQuestions;
  PsychometryTest({this.questions, this.answeredQuestions});
  @override
  _PsychometryTestState createState() => _PsychometryTestState();
}

class _PsychometryTestState extends State<PsychometryTest> {

  double width, height;

  Map<String, dynamic> questions, answeredQuestions;

  remainingQuestions() {
    String question;
    for(int i = 0; i < 0; i++){

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
            title: Text('Psychometric Test', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: width * 0.5, child: MyLinearProgressIndicator(seconds: 15000,),),
                    RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 22, right: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: basicColor, width: 1.5),
                      ),
                      child: Text('Pause', style: TextStyle(color: basicColor, fontWeight: FontWeight.bold),),
                      onPressed: () {
                        // TODO: save to firebase
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 3,
                thickness: 3,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(),
              )
            ],
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
