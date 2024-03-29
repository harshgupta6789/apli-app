import 'dart:async';
import 'dart:io';

import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCoursesHome.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class Tenth extends StatefulWidget {
  final Map<dynamic, dynamic> x;
  final List allFiles;
  final bool isUg;
  final String courseEdu, type;

  const Tenth(
      {Key key,
      @required this.x,
      this.allFiles,
      this.isUg,
      this.courseEdu,
      this.type})
      : super(key: key);
  @override
  _TenthState createState() => _TenthState();
}

class _TenthState extends State<Tenth> {

  // ALMOST THE SAME UI AND PARAMETERS AS OF DIPLOMA FILE //
  // THE ONLY DIFFERENCE IS USER CAN CALL THE API IN THIS CLASS IF HE DOESNT HAVE ANY OTHER EXTRA COURSES //

  double height, width, scale;
  File file;
  List allFiles;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit;
  String institute, stream, board, cgpa, email, specialization, certificate;
  Timestamp start, end;
  StorageUploadTask uploadTask;
  Map<dynamic, dynamic> education;
  List filenames;
  final apiService = APIService(profileType: 7);

  Future<List> upload() async {

  // THIS FUNCTION HANDLES THE ENTIRE UPLOADING OF THE FILES //
  // ONLY IF THE USER DOES NOT HAVE ANY PG COURSES , HE CAN CALL THIS FUNCTION HERE //
  // ONCE UPLOADED , WE COLLECT ALL THE LINKS AND CALL THE API //
  // THE API TAKES THE ENTIRE EDUCATION MAP AGAIN , SO THAT IT IS UPDATED IN THE FIREBASE DATABSE //

    List temp = [[]];
    for (int i = 0; i < allFiles.length; i++) {
      if (i == 0) {
        for (int j = 0; j < allFiles[0].length; j++) {
          temp[0].add(null);
        }
      } else if (i == 1)
        temp.add(null);
      else if (i == 2) temp.add(null);
    }
    try {
      await SharedPreferences.getInstance().then((value) async {
        for (int i = 0; i < allFiles.length; i++) {
          if (i == 0)
            for (int j = 0; j < allFiles[0].length; j++) {
              if (allFiles[0][j] != null) {
                final StorageReference storageReference = FirebaseStorage()
                    .ref()
                    .child(
                        "documents/${value.getString("email")}/sem$j${DateTime.now()}");

                final StorageUploadTask uploadTask =
                    storageReference.putFile(allFiles[0][j]);

                final StreamSubscription<StorageTaskEvent> streamSubscription =
                    uploadTask.events.listen((event) {});
                await uploadTask.onComplete;
                streamSubscription.cancel();

                String imageUrl = await storageReference.getDownloadURL();
                temp[0][j] = imageUrl;
              } else
                temp[0][j] = null;
            }
          else if (i == 1) {
            if (allFiles[1] != null) {
              final StorageReference storageReference = FirebaseStorage()
                  .ref()
                  .child(
                      "documents/${value.getString("email")}/TwelfthOrDiploma${DateTime.now()}");

              final StorageUploadTask uploadTask =
                  storageReference.putFile(allFiles[1]);

              final StreamSubscription<StorageTaskEvent> streamSubscription =
                  uploadTask.events.listen((event) {});
              await uploadTask.onComplete;
              streamSubscription.cancel();

              String imageUrl = await storageReference.getDownloadURL();
              temp[1] = imageUrl;
            } else
              temp[1] = null;
          } else if (i == 2) {
            if (allFiles[2] != null) {
              final StorageReference storageReference = FirebaseStorage()
                  .ref()
                  .child(
                      "documents/${value.getString("email")}/Tenth${DateTime.now()}");

              final StorageUploadTask uploadTask =
                  storageReference.putFile(allFiles[2]);

              final StreamSubscription<StorageTaskEvent> streamSubscription =
                  uploadTask.events.listen((event) {});
              await uploadTask.onComplete;
              streamSubscription.cancel();

              String imageUrl = await storageReference.getDownloadURL();
              temp[2] = imageUrl;
            } else
              temp[2] = null;
          }
        }
      });
    } catch (e) {}
    return temp;
  }

  void init() {
    if (widget.x['X'] != null)
      setState(() {
        allFiles = widget.allFiles;
        education = widget.x;
        institute = widget.x['X']['institute'] ?? "";
        board = widget.x['X']['board'] ?? "";
        cgpa = widget.x['X']['score'].toString() ?? "";
        specialization = widget.x['X']['specialization'];
        start = widget.x['X']['start'] ?? Timestamp.now();
        end = widget.x['X']['end'] ?? Timestamp.now();
        unit = widget.x['X']['score_unit'];
        certificate = widget.x['X']['certificate'];
      });
  }

  Future filePicker(BuildContext context) async {
    try {
      File temp = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );
      if (temp != null) {
        setState(() {
          file = temp;
          fileName = p.basename(temp.path);
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
  }

  @override
  void initState() {
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
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return;
      },
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: PreferredSize(
                child: AppBar(
                  backgroundColor: basicColor,
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Class Tenth',
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
                behavior: MyBehavior(),
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
                          SizedBox(height: 30),
                          TextFormField(
                            initialValue: education['X']['institute'] ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: x("Institute Name"),
                            onChanged: (text) {
                              setState(
                                  () => education['X']['institute'] = text);
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Institution cannot be empty';
                              else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue:
                                education['X']['specialization'] ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: x("Stream"),
                            onChanged: (text) {
                              setState(() =>
                                  education['X']['specialization'] = text);
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'stream cannot be empty';
                              else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: education['X']['board'] ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            onChanged: (text) {
                              setState(() => education['X']['board'] = text);
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Board cannot be empty';
                              else
                                return null;
                            },
                            decoration: x('Board'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: width * 0.35,
                                child: TextFormField(
                                  initialValue: education['X']['score'] == null
                                      ? ''
                                      : education['X']['score'].toString(),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  decoration: x("Score"),
                                  onChanged: (text) {
                                    setState(
                                        () => education['X']['score'] = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'incorrect input';
                                    } else if (double.tryParse(value) == null)
                                      return 'incorrect input';
                                    else
                                      return null;
                                  },
                                ),
                              ),
                              Container(
                                width: width * 0.35,
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        enabled: false,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 13,
                                                  ),
                                                  Text("Unit" + " : "),
                                                ],
                                              ),
                                            ),
                                            //hintText: t,
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[600])),
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 10.0),
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.w400),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 5, 0),
                                          child: DropdownButton<String>(
                                            //hint: Text("Unit"),
                                            value: education['X']
                                                    ['score_unit'] ??
                                                '%',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .color,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                            icon: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Icon(
                                                  Icons.keyboard_arrow_down),
                                            ),
                                            underline: SizedBox(),
                                            items: <String>['/4', '/10', '%']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                education['X']['score_unit'] =
                                                    value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          DateTimeField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Date cannot be empty';
                                }
                                return null;
                              },
                              format: format,
                              initialValue: start == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                      start.microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
//                                var temp = start != null
//                                    ? format
//                                            .format(DateTime
//                                                .fromMicrosecondsSinceEpoch(start
//                                                    .microsecondsSinceEpoch))
//                                            .toString() ??
//                                        "DOB"
//                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  start = (date == null)
                                      ? null
                                      : Timestamp.fromMicrosecondsSinceEpoch(
                                          date.microsecondsSinceEpoch);
                                });
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: x("From")),
                          SizedBox(
                            height: 15,
                          ),
                          DateTimeField(
                              validator: (value) {
                                if (value == null) {
                                  return ' Date cannot be empty';
                                }
                                return null;
                              },
                              format: format,
                              initialValue: end == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                      end.microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
//                                var temp = end != null
//                                    ? format
//                                            .format(DateTime
//                                                .fromMicrosecondsSinceEpoch(
//                                                    end.microsecondsSinceEpoch))
//                                            .toString() ??
//                                        "DOB"
//                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  end = (date == null)
                                      ? null
                                      : Timestamp.fromMicrosecondsSinceEpoch(
                                          date.microsecondsSinceEpoch);
                                });
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: x("To")),
                          SizedBox(height: 15.0),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Color(0xff4285f4))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: width * 0.3 * scale,
                                        child: AutoSizeText(
                                          fileName ?? '',
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
                                      if (file == null) {
                                        filePicker(context);
                                      } else {
                                        setState(() {
                                          file = null;
                                          fileName = null;
                                          certificate = null;
                                        });
                                      }
                                    },
                                    child: Text(
                                        file == null ? "Browse" : "Remove"),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    padding:
                                        EdgeInsets.only(left: 22, right: 22),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: basicColor, width: 1.2),
                                    ),
                                    child: Text(
                                      widget.isUg ? 'Save' : 'Next',
                                      style: TextStyle(color: basicColor),
                                    ),
                                    onPressed: () async {

                           // DEPENDING UPON THE isug PARAMETER PASSED , WE DECIDE WHETHER THE USER HAS OTHER COURSE , IF YES SIMPLY HE IS REDIRECTED //
                           // NOW AFTER VALIDATION , WE UPLOAD ALL FILES => CALL THE API => SUBMIT //

                                      if (_formKey.currentState.validate()) {
                                        String formattedTo, formattedFrom;

                                        formattedFrom =
                                            format.format(start.toDate());
                                        formattedFrom =
                                            formattedFrom + " 00:00:00+0000";
                                        education['X']['start'] = formattedFrom;

                                        formattedTo =
                                            format.format(end.toDate());
                                        formattedTo =
                                            formattedTo + " 00:00:00+0000";
                                        education['X']['end'] = formattedTo;
                                        setState(() {
                                          allFiles.add(file);
                                        });
                                        if (widget.isUg != true) {
                                          allFiles.add([]);
                                          education.forEach((key, value) {
                                            if (key != 'X' &&
                                                key != 'XII' &&
                                                key != 'current_education' &&
                                                key != widget.courseEdu &&
                                                key != 'Diploma')
                                              allFiles[3].add(null);
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtherCoursesHome(
                                                        education: education,
                                                        allFiles: allFiles,
                                                        courseEdu:
                                                            widget.courseEdu,
                                                        type: widget.type,
                                                      )));
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });
                                          showToast(
                                              "Uploading..Might Take Some time",
                                              context);
                                          List temp = await upload();
                                          for (int i = 0;
                                              i < allFiles.length;
                                              i++) {
                                            if (i == 0) {
                                              for (int j = 0;
                                                  j < allFiles[0].length;
                                                  j++) {
                                                if (allFiles[0][j] != null) {
                                                  education[widget.courseEdu]
                                                              ['sem_records'][j]
                                                          ['certificate'] =
                                                      temp[0][j];
                                                }
                                              }
                                            } else if (i == 1) {
                                              if (allFiles[i] != null) {
                                                education['XII']
                                                    ['certificate'] = temp[i];
                                              }
                                            } else if (i == 2) {
                                              if (allFiles[i] != null) {
                                                education['X']['certificate'] =
                                                    temp[i];
                                              }
                                            }
                                          }
                                          dynamic result = await apiService
                                              .sendProfileData(education);
                                          if (result == -1) {
                                            showToast('Failed', context);
                                          } else if (result == 0) {
                                            showToast('Failed', context);
                                          } else if (result == -2) {
                                            showToast(
                                                'Could not connect to server',
                                                context);
                                          } else if (result == 1) {
                                            showToast(
                                                'Data Updated Successfully',
                                                context);
                                          } else {
                                            showToast(
                                                'Unexpected error occured',
                                                context);
                                          }
                                          Navigator.pop(context, true);
                                        }
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
                  ),
                ),
              )),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Leaving the form midway will not save your data! You will have to fill the form again from start. Are you sure you want to go back?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
