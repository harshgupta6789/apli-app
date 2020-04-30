import 'package:apli/Screens/Home/Profile/Profile-Tabs/edu.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  bool isSuccessful;

  Review(bool isSuccessful) {
    this.isSuccessful = isSuccessful;
  }

  double height, width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(40, height * 0.2, 40, 0),
                child: Center(
                    child: Text(
                      isSuccessful
                          ? 'We have send you a verification email Please check your email and login again.'
                          : 'Your data is submitted for review!! We will reach you shortly.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: basicColor),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.1),
                child: Center(child: Image.asset("Assets/Images/job.png")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
