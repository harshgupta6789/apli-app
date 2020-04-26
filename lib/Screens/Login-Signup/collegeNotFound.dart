import 'package:apli/Screens/Login-Signup/register.dart';
import 'package:apli/Screens/Login-Signup/review.dart';
import 'package:apli/Services/mailer.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:flutter/material.dart';

class CollegeNotFound extends StatefulWidget {
  String phoneNo;
  CollegeNotFound({this.phoneNo});
  @override
  _CollegeNotFoundState createState() => _CollegeNotFoundState();
}

double height, width;

class _CollegeNotFoundState extends State<CollegeNotFound> {
  final _formKey = GlobalKey<FormState>();
  String fieldOfStudy = '', state = '', city = '', college = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register(widget.phoneNo)));
      },
          child: Scaffold(
              body: SingleChildScrollView(
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
                                icon:
                                    Icon(Icons.location_city, color: basicColor)),
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
                              right: width * 0.1),
                          child: Container(
                              height: height * 0.08,
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                color: basicColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    //add to excel sheet
                                    Map<String, String> data = {
                                      'college': college,
                                      'state': state,
                                      'city': city
                                    };
                                    MailerService(
                                        username: apliEmailID,
                                        password: apliPassword,
                                        data: data);
                                    setState(() {
                                      loading = false;
                                    });

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Review(false)));
                                  }
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
        );
  }
}
