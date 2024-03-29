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

class CollegeNotFound extends StatefulWidget {
  final String phoneNo;
  CollegeNotFound({this.phoneNo});
  @override
  _CollegeNotFoundState createState() => _CollegeNotFoundState();
}

double height, width;

class _CollegeNotFoundState extends State<CollegeNotFound> {
  // THIS SCREEN IS TO BE SHOWED WHEN USER'S COLLEGE IS NOT PRESENT IN THE DROPDOWN LIST THAT WE PROVIDE DURING SIGNUP //
  // THIS SCREEN HAS ALMOST SIMILAR FIELDS TO THAT OF REGISTER PAGE , ONCE USER FILLS HIS DETAILS HE IS REDIRECTED TO REVIEW.DART //

  final _formKey = GlobalKey<FormState>();
  String name = '',
      fieldOfStudy = '',
      state = '',
      city = '',
      college = '',
      email = '';
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
              return null;
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: loginFormField.copyWith(
                                  hintText: 'Name',
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => name = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'name cannot be empty';
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
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: loginFormField.copyWith(
                                  hintText: 'Email Address',
                                  prefixIcon: Icon(
                                    EvaIcons.email,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => email = text);
                              },
                              validator: (value) {
                                if (!validateEmail(value)) {
                                  return 'email invalid';
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: loginFormField.copyWith(
                                  hintText: 'College',
                                  prefixIcon: Icon(
                                    Icons.school,
                                    color: basicColor,
                                  )),
                              onChanged: (text) {
                                setState(() => college = text);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'college cannot be empty';
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: loginFormField.copyWith(
                                  hintText: 'Field of Study',
                                  prefixIcon: Icon(
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
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: loginFormField.copyWith(
                                  hintText: 'State',
                                  prefixIcon: Icon(
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
                              textInputAction: TextInputAction.done,
                              decoration: loginFormField.copyWith(
                                  hintText: 'City',
                                  prefixIcon: Icon(Icons.location_city,
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
                                     if (_formKey.currentState.validate()) {
                                       setState(() {
                                         loading = true;
                                       });
                                       var net = await Connectivity()
                                           .checkConnectivity();
                                       if (net == ConnectivityResult.none) {
                                         setState(() {
                                           loading = false;
                                         });
                                         showToast('No Internet', context);
                                       } else {
                                         //add to excel sheet
 //                                        String body =
 //                                            'Email: $email, College: $college, Field of Study: $fieldOfStudy, State: $state, City: $city, Contact: ${widget.phoneNo}';
                                         final MailerService _mail =
                                             MailerService(
                                                 name: name,
                                                 email: email,
                                                 workplace: college,
                                                 work_email: email,
                                                 contact: widget.phoneNo,
                                                 user_type: 'Candidate');
                                         dynamic result = await _mail.reachUs();
                                         setState(() {
                                           loading = false;
                                         });
                                         if (result == -2) {
                                           showToast(
                                               'Could not connect to server',
                                               context);
                                         } else if (result == 0) {
                                           //failed
                                           showToast('Failed, try again later',
                                               context);
 //                                        Navigator.pop(context);
                                         } else if (result == 1) {
                                           //success
                                           Navigator.pushReplacement(
                                               context,
                                               MaterialPageRoute(
                                                   builder: (context) =>
                                                       Review(false)));
                                         } else {
                                           showToast('Failed, try again later',
                                               context);
 //                                        Navigator.pop(context);
                                         }
                                       }
                                     }
//                                    Navigator.pushReplacement(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) =>
//                                                Review(false)));
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
