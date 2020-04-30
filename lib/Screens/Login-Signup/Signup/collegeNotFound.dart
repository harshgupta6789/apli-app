import 'package:apli/Screens/Login-Signup/Signup/register.dart';
import 'package:apli/Screens/Login-Signup/Signup/review.dart';
import 'package:apli/Services/mailer.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CollegeNotFound extends StatefulWidget {
  String phoneNo;
  CollegeNotFound({this.phoneNo});
  @override
  _CollegeNotFoundState createState() => _CollegeNotFoundState();
}

double height, width;

class _CollegeNotFoundState extends State<CollegeNotFound> {
  final _formKey = GlobalKey<FormState>();
  String fieldOfStudy = '', state = '', city = '', college = '', email = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Register(widget.phoneNo)));
            },
            child: Scaffold(
              body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.2, right: width * 0.5),
                          child: Image.asset("Assets/Images/logo.png"),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  labelText: 'Email Address',
                                  icon: Icon(
                                    EvaIcons.emailOutline,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => email = text);
                              },
                              validator: (value) {
                                if (!validateEmail(value)) {
                                  return 'Email invalid';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  labelText: 'College',
                                  icon: Icon(
                                    Icons.school,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => college = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'college of study cannot be empty';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  labelText: 'Field of Study',
                                  icon: Icon(
                                    Icons.book,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => fieldOfStudy = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'field of study cannot be empty';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  labelText: 'State',
                                  icon: Icon(
                                    Icons.location_on,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => state = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'state cannot be empty';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.1,
                                right: width * 0.1),
                            child: TextFormField(
                              obscureText: false,
                              decoration: loginFormField.copyWith(
                                  labelText: 'City',
                                  icon: Icon(Icons.location_city,
                                      color: basicColor)),
                              onChanged: (text) {
                                setState(() => city = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'city cannot be empty';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.1,
                                left: width * 0.1,
                                right: width * 0.1,
                                bottom: height * 0.1),
                            child: Container(
                                height: 70,
                                width: width * 0.8,
                                decoration: BoxDecoration(
                                  color: basicColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MaterialButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Review(false)));
//                                    if (_formKey.currentState.validate()) {
//                                      setState(() {
//                                        loading = true;
//                                      });
//                                      var net = await Connectivity()
//                                          .checkConnectivity();
//                                      if (net == ConnectivityResult.none) {
//                                        setState(() {
//                                          loading = false;
//                                        });
//                                        Toast.show('Not Internet', context,
//                                            backgroundColor: Colors.red);
//                                      } else {
//                                        //add to excel sheet
//                                        String body = 'Email = $email College = $college Field of Study = $fieldOfStudy State = $state City = $city';
//                                        final MailerService _mail = MailerService(to_email: 'harshhvg999@gmail.com', subject: 'abcd', body: body);
//                                        dynamic result = await _mail.send();
//                                        setState(() {
//                                          loading = false;
//                                        });
//                                        if(result == -2) {
//                                          Toast.show('Could not connect to server', context, duration: 5, backgroundColor: Colors.red);
//                                        } else if(result == 0) {
//                                          //failed
//                                          Toast.show('Failed, try again later', context, duration: 5, backgroundColor: Colors.red);
////                                        Navigator.pop(context);
//                                        } else if(result == 1) {
//                                          //success
//                                          Navigator.pushReplacement(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      Review(false)));
//                                        } else {
//                                          Toast.show('Failed, try again later', context, duration: 5, backgroundColor: Colors.red);
////                                        Navigator.pop(context);
//                                        }
//                                      }
//                                    }
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
