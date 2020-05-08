import 'dart:io';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentEducation extends StatefulWidget {
  final Map<dynamic, dynamic> education;
  final int sem;
  final String course, branch, duration;

  const CurrentEducation(
      {Key key,
      @required this.education,
      this.sem,
      this.course,
      this.branch,
      this.duration})
      : super(key: key);
  @override
  _CurrentEducationState createState() => _CurrentEducationState();
}

class _CurrentEducationState extends State<CurrentEducation> {
  double height, width, scale;
  File file;
  bool loading = false, error = false;
  String institute = '', email;
  final format = DateFormat("yyyy-MM");
  final _formKey = GlobalKey<FormState>();
  String userEmail;
  String batchId;
  double heightOfContainer = 90;
  String course, branch, duration;
  int semToBuild = 1;
  Map<dynamic, dynamic> edu = {};

  void init() {
    setState(() {
      course = widget.course;
      branch = widget.branch;
      duration = widget.duration;
      semToBuild = widget.sem;
      edu = widget.education;
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
    //getInfo();
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width < 360)
      scale = semToBuild.toDouble() + 1;
    else
      scale = semToBuild.toDouble();
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
        body: ScrollConfiguration(
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.1, top: 20, right: width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Row(
                    children: <Widget>[
                      Container(
                          width: width * 0.2,
                          child: Text(
                            "Course",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                      Container(
                        width: width * 0.6,
                        child: TextFormField(
                          enabled: false,
                          initialValue: course,
                          obscureText: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              labelStyle: TextStyle(color: Colors.black)),
                          keyboardType: TextInputType.numberWithOptions(),
                         
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      Container(
                          width: width * 0.2,
                          child: Text(
                            "Branch",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                      Container(
                        width: width * 0.6,
                        child: TextFormField(
                          enabled: false,
                          initialValue: branch,
                          obscureText: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              labelStyle: TextStyle(color: Colors.black)),
                          keyboardType: TextInputType.numberWithOptions(),
                         
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      Container(
                          width: width * 0.2,
                          child: Text(
                            "Duration",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                      Container(
                          width: width * 0.6,
                          child: TextFormField(
                            enabled: false,
                            initialValue: duration,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                labelStyle: TextStyle(color: Colors.black)),
                            keyboardType: TextInputType.numberWithOptions(),
                           
                          )),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Semester Scores",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  SizedBox(height: 20.0),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: semToBuild,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Sem ${index + 1}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                initialValue:
                                    edu[course]['sem_records'][index] != null
                                        ? edu[course]['sem_records'][index]
                                            ['semester_score']
                                        : null,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                obscureText: false,
                                decoration: x("Score"),
                                keyboardType: TextInputType.numberWithOptions(),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Score cannot be empty';
                                  else
                                    return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    edu[course]['sem_records'][index]
                                        ['semester_score'] = text;
                                  });
                                },
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                initialValue:
                                    edu[course]['sem_records'][index] != null
                                        ? edu[course]['sem_records'][index]
                                            ['closed_backlog']
                                        : null,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                obscureText: false,
                                decoration: x("Closed Backlogs"),
                                keyboardType: TextInputType.numberWithOptions(),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Backlogs cannot be empty';
                                  else
                                    return null;
                                },
                                onChanged: (text) {
                                  setState(() => edu[course]['sem_records']
                                      [index]['closed_backlog'] = text);
                                },
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                initialValue:
                                    edu[course]['sem_records'][index] != null
                                        ? edu[course]['sem_records'][index]
                                            ['live_backlog']
                                        : null,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                obscureText: false,
                                decoration: x("Live Backlogs"),
                                keyboardType: TextInputType.numberWithOptions(),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Backlogs cannot be empty';
                                  else
                                    return null;
                                },
                                onChanged: (text) {
                                  setState(() => edu[course]['sem_records']
                                      [index]['live_backlog'] = text);
                                },
                              ),
                              SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintText: 'Certificate',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5)),
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 10.0),
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.w400),
                                            labelStyle: TextStyle(
                                                color: Colors.black))),
                                  ),
                                  Container(
                                    color: Colors.grey,
                                    width: width * 0.25,
                                    child: TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            hintText: 'Browse',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 10.0),
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                            labelStyle: TextStyle(
                                                color: Colors.black))),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0)
                            ]);
                      }),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: basicColor),
                            borderRadius: BorderRadius.circular(5),
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: basicColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  
                                }
                                print(edu);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          behavior: MyBehavior(),
        ));
  }
}
