import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  bool isSuccessful;

  Review(bool isSuccessful) {
    this.isSuccessful = isSuccessful;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(40, 200.0, 40, 0),
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
              padding: EdgeInsets.only(top: 100.0),
              child: Center(child: Image.asset("Assets/Images/job.png")),
            ),
          ],
        ),
      ),
    );
  }
}
