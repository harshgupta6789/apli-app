import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: FlatButton(
              padding: EdgeInsets.only(bottom: 40),
              onPressed: () {},
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                    "Need Help ? ",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    children: [
                      TextSpan(
                        text: "Email Us",
                        style: TextStyle(color: basicColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url =
                                'mailto:info@apli.ai?subject=Regarding Apli App';
                            if (await canLaunch(url)) {
                            await launch(url);
                            } else {
                            throw 'Could not launch $url';
                            }
                          },
                      ),
                      TextSpan(
                        text: ' Or '
                      ),
                      TextSpan(
                        text: 'Call Us',
                        style: TextStyle(color: basicColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url =
                                'tel:8169634498';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                      )
                    ]),
              ),
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
                      : "Oops, Maybe you were not able to find your college or maybe it's not registered",
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
//              Container(
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 10, bottom: 5),
//                  child: FlatButton(
//                      child: Text(
//                        'Need Help ? Contact Us',
//                        style: TextStyle(color: basicColor, fontSize: 18),
//                      ),
//                      onPressed: () async {
//                        const url =
//                            'mailto:info@apli.ai?subject=Regarding Apli App';
//                        if (await canLaunch(url)) {
//                          await launch(url);
//                        } else {
//                          throw 'Could not launch $url';
//                        }
//                      }),
//                ),
//              ),
//              Container(
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 0, bottom: 5),
//                  child: FlatButton(
//                      child: Text(
//                        ' Or Call Us',
//                        style: TextStyle(color: basicColor, fontSize: 18),
//                      ),
//                      onPressed: () async {
//                        const url =
//                            'tel:8169634498';
//                        if (await canLaunch(url)) {
//                          await launch(url);
//                        } else {
//                          throw 'Could not launch $url';
//                        }
//                      }),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
