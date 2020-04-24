import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';

class PsychometryTest extends StatefulWidget {

  Map<String, dynamic> questions, answeredQuestions;
  @override
  _PsychometryTestState createState() => _PsychometryTestState();
}

class _PsychometryTestState extends State<PsychometryTest> {

  @override
  Widget build(BuildContext context) {
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
