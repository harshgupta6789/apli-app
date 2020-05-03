import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentEducation extends StatefulWidget {
  @override
  _CurrentEducationState createState() => _CurrentEducationState();
}

class _CurrentEducationState extends State<CurrentEducation> {
  double height, width;
  File file;
  String institute = '';
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String userEmail;

  void fetchInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        setState(() {
          userEmail = prefs.getString('email');
        });
      }
    });
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(type: FileType.custom);
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e,
              body: Text("Error Has Occured"))
          .show();
    }
  }

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                clg,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),
          preferredSize: Size.fromHeight(55),
        ),
        body: FutureBuilder(
          future: Firestore.instance
              .collection('candidates')
              .document(userEmail)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScrollConfiguration(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 18.0),
                                    child: Container(
                                        width: width * 0.2,
                                        child: Text(
                                          "Course",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, left: width * 0.05),
                                    child: Container(
                                      width: width * 0.6,
                                      child: TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => institute = text);
                                        },
                                        validator: (value) {
                                          // if (!validateEmail(value)) {
                                          //   return 'please enter valid email';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 18.0),
                                    child: Container(
                                        width: width * 0.2,
                                        child: Text(
                                          "Branch",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, left: width * 0.05),
                                    child: Container(
                                      width: width * 0.6,
                                      child: TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => institute = text);
                                        },
                                        validator: (value) {
                                          // if (!validateEmail(value)) {
                                          //   return 'please enter valid email';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 18.0),
                                    child: Container(
                                        width: width * 0.2,
                                        child: Text(
                                          "Duration",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, left: width * 0.05),
                                    child: Container(
                                      width: width * 0.6,
                                      child: TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => institute = text);
                                        },
                                        validator: (value) {
                                          // if (!validateEmail(value)) {
                                          //   return 'please enter valid email';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: ListTile(
                                title: Text(
                                  "Semester Scores",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  "Sem1",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 30.0, left: 10.0, right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Score',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff4285f4))),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 10.0),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (text) {
                                    setState(() => institute = text);
                                  },
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 30.0, left: 10.0, right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Closed Backlogs',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff4285f4))),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 10.0),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (text) {
                                    setState(() => institute = text);
                                  },
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 30.0, left: 10.0, right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Live Backlogs',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff4285f4))),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 10.0),
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (text) {
                                    setState(() => institute = text);
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 15.0,
                                      left: 18.0,
                                    ),
                                    child: Text(
                                      "Certificate",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0, right: 10.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          filePicker(context);
                                        },
                                        child: Text("Browse"),
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: basicColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MaterialButton(
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: basicColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () {}),
                                    ),
                                     Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: basicColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MaterialButton(
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: basicColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () {}),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    behavior: MyBehavior(),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text("Error"));
            } else {
              return Loading();
            }
            return Loading();
          },
        ));
  }
}
