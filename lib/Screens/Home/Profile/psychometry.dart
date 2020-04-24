import 'package:apli/Screens/Home/Profile/psychometryTest.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:flutter/material.dart';

class Psychometry extends StatefulWidget {
  @override
  _PsychometryState createState() => _PsychometryState();
}

enum states { none, resume, done }

class _PsychometryState extends State<Psychometry> {
  states _currentState = states.none;
  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case states.none:
        return Padding(
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
                          fontWeight: FontWeight.bold,)),
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
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
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
                    child: Text('Start Test', style: TextStyle(color: basicColor, fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PsychometryTest()));
                    },
                  ),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
        );
        break;
      case states.resume:
        return Padding(
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
                            fontWeight: FontWeight.bold,)),
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
                    child: Text('Resume Test', style: TextStyle(color: basicColor, fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PsychometryTest()));
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
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: basicColor)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
            ],
          ),
        );
        break;
      case states.done:
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                child: Align(
                    child: Text('You have attempted the psychometric\n test! Your answers have been recorded.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,)),
                    alignment: Alignment.center),
              ),
            ],
          ),
        );
        break;
      default:
        return Loading();
    }
  }
}
