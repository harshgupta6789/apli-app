import 'dart:io';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'diploma.dart';

class CurrentEducation extends StatefulWidget {
  final Map<dynamic, dynamic> education;
  final int sem;
  final bool isUg;
  final String course, branch, duration;
  final VoidCallback onButtonPressed;

  CurrentEducation(
      {@required this.onButtonPressed,
      this.education,
      this.sem,
      this.course,
      this.branch,
      this.duration,
      this.isUg});
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

  Future<void> _uploadFile(File file, String filename, int index) async {
    await SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("documents/${value.getString("email")}/$filename");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());

      if (uploadTask.isInProgress) {
        print('abd');
        setState(() {
          isUploading = true;
        });
      }

      if (url != null) {
        setState(() {
          currentFileNames[index] = url;
          edu[course]["sem_records"][index]['certificate'] =
              currentFileNames[index];
          temp = index;
          isUploading = false;
        });
        print(currentFileNames);
        print(temp);
      } else if (url == null) {}
    });
  }

  Widget uploading() {
    return StreamBuilder<StorageTaskEvent>(
        stream: uploadTask.events,
        builder: (context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            final StorageTaskEvent event = asyncSnapshot.data;
            final StorageTaskSnapshot snapshot = event.snapshot;
            return Column(
              children: <Widget>[
                Loading(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(value: 0.2),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("üploading Files")),
              ],
            );
          }
          return Align(child: Text("Uploading Your Resume!..."));
        });
  }

  Future uploadAll() {
    for (int i = 0; i < semToBuild; i++) {
      if (currentFiles[i] != null) {
        // String fileName = p.basename(currentFiles[i].path);
        _uploadFile(currentFiles[i], "Sem $i", i);
      } else {}
    }
    return null;
  }

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
        body: isUploading
            ? uploading()
            : ScrollConfiguration(
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
                          children: <Widget>[
                            Container(
                                width: width * 0.2,
                                child: Text(
                                  "Course",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )),
                            Container(
                              width: width * 0.7,
                              child: TextFormField(
                                enabled: false,
                                initialValue: course,
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff4285f4))),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )),
                            Container(
                              width: width * 0.7,
                              child: TextFormField(
                                enabled: false,
                                initialValue: branch,
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff4285f4))),
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )),
                            Container(
                                width: width * 0.7,
                                child: TextFormField(
                                  enabled: false,
                                  initialValue: duration,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                )),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          initialValue: edu[course]['score'] != null
                              ? edu[course]['score'].toString()
                              : null,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Average Score"),
                          onChanged: (text) {
                            setState(
                                () => edu[course]['score'] = int.parse(text));
                          },
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: (value) {
                            if (value.isEmpty)
                              return 'score cannot be empty';
                            else
                              return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Semester Scores",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 15.0),
                                    TextFormField(
                                      initialValue: edu[course]['sem_records']
                                                  [index] !=
                                              null
                                          ? edu[course]['sem_records'][index]
                                                  ['semester_score']
                                              .toString()
                                          : null,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      obscureText: false,
                                      decoration: x("Score"),
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      onChanged: (text) {
                                        setState(() {
                                          edu[course]['sem_records'][index]
                                                  ['semester_score'] =
                                              int.parse(text);
                                        });
                                      },
                                    ),
                                    SizedBox(height: 15.0),
                                    TextFormField(
                                      initialValue: edu[course]['sem_records']
                                                  [index] !=
                                              null
                                          ? edu[course]['sem_records'][index]
                                                  ['closed_backlog']
                                              .toString()
                                          : null,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      obscureText: false,
                                      decoration: x("Closed Backlogs"),
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      onChanged: (text) {
                                        setState(() => edu[course]
                                                    ['sem_records'][index]
                                                ['closed_backlog'] =
                                            int.parse(text));
                                      },
                                    ),
                                    SizedBox(height: 15.0),
                                    TextFormField(
                                      initialValue: edu[course]['sem_records']
                                                  [index] !=
                                              null
                                          ? edu[course]['sem_records'][index]
                                                  ['live_backlog']
                                              .toString()
                                          : null,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      obscureText: false,
                                      decoration: x("Live Backlogs"),
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      onChanged: (text) {
                                        setState(() => edu[course]
                                                ['sem_records'][index]
                                            ['live_backlog'] = int.parse(text));
                                      },
                                    ),
                                    SizedBox(height: 15.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Color(0xff4285f4))),
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
                                                                currentFiles[
                                                                        index]
                                                                    .path) ??
                                                            ''
                                                        : "No Certificate",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                // Visibility(
                                                //   visible:
                                                //       currentFiles[index] != null,
                                                //   child: IconButton(
                                                //     icon: Icon(Icons.clear),
                                                //     onPressed: () {
                                                //       setState(() {
                                                //         currentFiles[index] = null;
                                                //         currentFileNames[index] =
                                                //             null;
                                                //       });
                                                //     },
                                                //     padding: EdgeInsets.all(0),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: MaterialButton(
                                              onPressed: () {
                                                filePicker(context, index);
                                              },
                                              child: Text("Browse"),
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
                          initialValue: edu[course]['total_closed_backlogs'] !=
                                  null
                              ? edu[course]['total_closed_backlogs'].toString()
                              : null,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Total Closed Backlog"),
                          onChanged: (text) {
                            setState(() => edu[course]
                                ['total_closed_backlogs'] = int.parse(text));
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field name cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: edu[course]['total_live_backlogs'] !=
                                  null
                              ? edu[course]['total_live_backlogs'].toString()
                              : null,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.numberWithOptions(),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Total Live Backlog"),
                          onChanged: (text) {
                            setState(() => edu[course]['total_live_backlogs'] =
                                int.parse(text));
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.0),
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
                                    padding:
                                        EdgeInsets.only(left: 22, right: 22),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: basicColor, width: 1.2),
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
                                    side: BorderSide(
                                        color: basicColor, width: 1.2),
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
                                          'certificate': edu[course]
                                              ['sem_records'][i]['certificate'],
                                          'closed_backlog': edu[course]
                                                  ['sem_records'][i]
                                              ['closed_backlog'],
                                          'live_backlog': edu[course]
                                                  ['sem_records'][i]
                                              ['live_backlog'],
                                          'semester_score': edu[course]
                                                  ['sem_records'][i]
                                              ['semester_score'],
                                        };
                                        sems.add(x);
                                      }
                                      print(sems);
                                   
                                      edu[course]['sem_records'] = sems;
                                     

                                     print(edu);
                                      //uploadAll();
//                                print(edu);
//                                await SharedPreferences.getInstance().then((value) async {
//                                  for(int i = 0; i < currentFiles.length; i++) {
//                                    if(currentFiles[i] != null) {
//                                      StorageReference storageReference;
//                                      storageReference =
//                                          FirebaseStorage.instance.ref().child("candidate_resumes/${value.getString('email')}-${Random().nextInt(999999999).toString()}");
//                                      uploadTask = storageReference.putFile(currentFiles[i]);
//                                      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
//                                      await downloadUrl.ref.getDownloadURL().then((url) {
//                                        print(edu[course]['sem_records'][i]['semester_score'].runtimeType);
//                                        edu[course]['sem_records'][i]['semester_score'] = url;
//                                        print(edu[course]['sem_records'][i]['certificate']);
//                                        setState(() {
//                                          temp = temp + 1;
//                                        });
//                                      });
//                                    } else setState(() {
//                                      temp = temp + 1;
//                                    });
//                                  }
//                                });
//                                while(true) {
//                                  if(temp == currentFiles.length) {
//                                    break;
//                                  }
//                                }
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Diploma(
                                                    courseEdu: course,
                                                    xii: edu,
                                                    allFiles: [
                                                      [currentFiles]
                                                    ],
                                                    isUg: widget.isUg,
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
