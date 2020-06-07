import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'diploma.dart';

class CurrentEducation extends StatefulWidget {
  final Map<dynamic, dynamic> education;
  final int sem;
  final bool isUg;
  final String course, branch, duration, type;
  final VoidCallback onButtonPressed;

  CurrentEducation(
      {@required this.onButtonPressed,
      this.education,
      this.sem,
      this.course,
      this.branch,
      this.duration,
      this.isUg,
      this.type});
  @override
  _CurrentEducationState createState() => _CurrentEducationState();
}

class _CurrentEducationState extends State<CurrentEducation> {
  double height, width, scale;
  List<File> currentFiles = [];
  List<String> currentFileNames = [];
  bool loading = false, error = false;
  String institute = '', email;
  final format = DateFormat("yyyy-MM");
  final _formKey = GlobalKey<FormState>();
  String userEmail;
  String batchId;
  String course, branch, duration;
  int semToBuild = 1;
  bool isUploading = false;
  Map<dynamic, dynamic> edu = {};
  StorageUploadTask uploadTask;
  int temp = 0;

  void init() {
    setState(() {
      course = widget.course;
      branch = widget.branch;
      duration = widget.duration;
      semToBuild = widget.sem;
      edu = widget.education;
      for (int i = 0; i < widget.sem; i++) {
        currentFiles.add(null);
        currentFileNames.add(null);
      }
    });
    print(currentFileNames);
    print(currentFiles);
  }

  Future filePicker(BuildContext context, int index) async {
    try {
      File file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );
      if (file != null) {
        setState(() {
          currentFiles[index] = file;
          //currentFileNames[index] = p.basename(file.path);
        });
      } else {}
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e,
              body: Text("Error Has Occured"))
          .show();
    }
    print(currentFileNames);
    print(currentFiles);
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
      scale = 0.7;
    else
      scale = 1;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                  left: width * 0.05, top: 20, right: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: width * 0.35,
                          child: Text(
                            "Course",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          )),
                      Container(
                        width: width * 0.55,
                        //height: height*0.08,
                        child: TextFormField(
                          enabled: false,
                          initialValue: course,
                          obscureText: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              labelStyle: TextStyle(color: Colors.black)),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: width * 0.35,
                          child: Text(
                            "Duration",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          )),
                      Container(
                          width: width * 0.55,
                          child: TextFormField(
                            enabled: false,
                            initialValue: duration,
                            obscureText: false,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                labelStyle: TextStyle(color: Colors.black)),
                            keyboardType: TextInputType.number,
                          )),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    initialValue: edu[course]['score'] == null
                        ? ''
                        : edu[course]['score'].toString(),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: x("Average Score"),
                    onChanged: (text) {
                      setState(() => edu[course]['score'] = text);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'score cannot be empty';
                      } else if (double.tryParse(value) == null)
                        return 'incorrect input';
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.0),
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
                                            .toString()
                                        : null,
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                decoration: x("Score"),
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  setState(() {
                                    edu[course]['sem_records'][index]
                                        ['semester_score'] = text;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field cannot be empty';
                                  } else if (double.tryParse(value) == null)
                                    return 'incorrect input';
                                  else
                                    return null;
                                },
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                initialValue:
                                    edu[course]['sem_records'][index] != null
                                        ? edu[course]['sem_records'][index]
                                                ['closed_backlog']
                                            .toString()
                                        : null,
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                decoration: x("Closed Backlogs"),
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  setState(() => edu[course]['sem_records']
                                      [index]['closed_backlog'] = text);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field cannot be empty';
                                  } else if (double.tryParse(value) == null)
                                    return 'incorrect input';
                                  else
                                    return null;
                                },
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                initialValue:
                                    edu[course]['sem_records'][index] != null
                                        ? edu[course]['sem_records'][index]
                                                ['live_backlog']
                                            .toString()
                                        : null,
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                decoration: x("Live Backlogs"),
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  setState(() => edu[course]['sem_records']
                                      [index]['live_backlog'] = text);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'field cannot be empty';
                                  } else if (double.tryParse(value) == null)
                                    return 'incorrect input';
                                  else
                                    return null;
                                },
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: Color(0xff4285f4))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "Certificate : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.3 * scale,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: width * 0.3 * scale,
                                            child: AutoSizeText(
                                              currentFiles[index] != null
                                                  ? p.basename(
                                                      currentFiles[index].path)
                                                  : '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (currentFiles[index] == null) {
                                            filePicker(context, index);
                                          } else {
                                            setState(() {
                                              currentFiles[index] = null;
                                              currentFileNames[index] = null;
                                            });
                                          }
                                        },
                                        child: Text(currentFiles[index] == null
                                            ? "Browse"
                                            : "Remove"),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.0)
                            ]);
                      }),
                  TextFormField(
                    initialValue: edu[course]['total_closed_backlogs'] != null
                        ? edu[course]['total_closed_backlogs'].toString()
                        : null,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: x("Total Closed Backlog"),
                    onChanged: (text) {
                      setState(
                          () => edu[course]['total_closed_backlogs'] = text);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'score cannot be empty';
                      } else if (double.tryParse(value) == null)
                        return 'incorrect input';
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: edu[course]['total_live_backlogs'] != null
                        ? edu[course]['total_live_backlogs'].toString()
                        : null,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: x("Total Live Backlog"),
                    onChanged: (text) {
                      setState(() => edu[course]['total_live_backlogs'] = text);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'score cannot be empty';
                      } else if (double.tryParse(value) == null)
                        return 'incorrect input';
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          visible: false,
                          child: RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.only(left: 22, right: 22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: basicColor, width: 1.2),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: basicColor),
                              ),
                              onPressed: () {}),
                        ),
                        RaisedButton(
                            color: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.only(left: 22, right: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: basicColor, width: 1.2),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(color: basicColor),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                List sems = [];
                                for (int i = 0; i < widget.sem; i++) {
                                  Map x;
                                  x = {
                                    'certificate': edu[course]['sem_records'][i]
                                        ['certificate'],
                                    'closed_backlog': edu[course]['sem_records']
                                        [i]['closed_backlog'],
                                    'live_backlog': edu[course]['sem_records']
                                        [i]['live_backlog'],
                                    'semester_score': edu[course]['sem_records']
                                        [i]['semester_score'],
                                  };
                                  sems.add(x);
                                }

                                edu[course]['sem_records'] = sems;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Diploma(
                                              courseEdu: course,
                                              xii: edu,
                                              allFiles: [currentFiles],
                                              isUg: widget.isUg,
                                              type: widget.type,
                                            )));
                              }
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
          behavior: MyBehavior(),
        ));
  }
}
