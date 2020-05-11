import 'dart:io';
import 'dart:math';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCourses.dart';
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
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tenth extends StatefulWidget {
  final Map<dynamic, dynamic> x;
  final List allFiles;
  final bool isUg;
  final String courseEdu;

  const Tenth(
      {Key key, @required this.x, this.allFiles, this.isUg, this.courseEdu})
      : super(key: key);
  @override
  _TenthState createState() => _TenthState();
}

class _TenthState extends State<Tenth> {
  double height, width, scale;
  File file;
  List allFiles;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit;
  String institute, stream, board, cgpa, email, specialization;
  Timestamp start, end;
  StorageUploadTask uploadTask;
  Map<dynamic, dynamic> education;
  List filenames;
  final _APIService = APIService(type: 7);

  Future<String> _uploadFile(
      File file, String filename, int index, String extension) async {
    String url;
    await SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("documents/${value.getString("email")}/$filename$extension");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      url = (await downloadUrl.ref.getDownloadURL());
      if (url != null) {
        print(url);
        setState(() {});
      } else if (url == null) {}
    });
    return url;
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

  void callApi() async {
    dynamic result = await _APIService.sendProfileData(education);
    if (result == -1) {
      showToast('Failed', context);
    } else if (result == 0) {
      showToast('Failed', context);
    } else if (result == -2) {
      showToast('Could not connect to server', context);
    } else if (result == 1) {
      showToast('Data Updated Successfully', context);
      Navigator.pop(context);
    } else {
      showToast('Unexpected error occured', context);
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
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Score"),
                                  onChanged: (text) {
                                    setState(() => education['X']['score'] =
                                        int.tryParse(text));
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'score cannot be empty';
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
                                        decoration: x("Unit"),
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
                                                color: Colors.black,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: width * 0.35,
                                child: DateTimeField(
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
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                      var temp = start != null
                                          ? format
                                                  .format(DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          start
                                                              .microsecondsSinceEpoch))
                                                  .toString() ??
                                              "DOB"
                                          : "DOB";
                                      return date;
                                    },
                                    onChanged: (date) {
                                      setState(() {
                                        String formatted;
                                        if (date != null) {
                                          formatted = format.format(date);
                                          formatted =
                                              formatted + " 00:00:00+0000";
                                          education['X']['start'] = formatted;
                                          print(formatted);
                                        }
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: x("From")),
                              ),
                              Container(
                                width: width * 0.35,
                                child: DateTimeField(
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
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                      var temp = end != null
                                          ? format
                                                  .format(DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          end.microsecondsSinceEpoch))
                                                  .toString() ??
                                              "DOB"
                                          : "DOB";
                                      return date;
                                    },
                                    onChanged: (date) {
                                      setState(() {
                                        String formatted;
                                        if (date != null) {
                                          formatted = format.format(date);
                                          formatted =
                                              formatted + " 00:00:00+0000";
                                          education['X']['end'] = formatted;
                                          print(education['X']['end']);
                                        }
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    decoration: x("To")),
                              ),
                            ],
                          ),
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
                                        width: width * 0.15 * scale,
                                        child: AutoSizeText(
                                          fileName ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Visibility(
                                        visible: file != null,
                                        child: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              file = null;
                                              fileName = null;
                                            });
                                          },
                                          padding: EdgeInsets.all(0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: MaterialButton(
                                    onPressed: () {
                                      filePicker(context);
                                    },
                                    child: Text("Browse"),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.2),
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
                                        allFiles.add(file);
                                        if (widget.isUg != true) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Other(
                                                        oth: education,
                                                        allFiles: allFiles,
                                                      )));
                                        }
                                        setState(() {
                                          loading = true;
                                        });
                                        for (int i = 0;
                                            i < allFiles.length;
                                            i++) {
                                          if (allFiles[i] != null) {
                                            showToast(
                                                'Uploading Documents\n might take some time',
                                                context,
                                                duration: 5);
                                            String ex;

                                            if (i == 0) {
                                              for (int j = 0;
                                                  j < allFiles[0][0].length;
                                                  j++) {
                                                if ((allFiles[0][0][j]) !=
                                                    null) {
                                                  ex = p.extension(p.basename(
                                                      allFiles[0][0][j].path));

                                                  _uploadFile(allFiles[0][0][j],
                                                          "Sem $j", i, ex)
                                                      .then((url) {
                                                    setState(() {
                                                      education[widget
                                                                  .courseEdu]
                                                              ["sem_records"][j]
                                                          ['certificate'] = url;
                                                      if (allFiles[1] == null &&
                                                          allFiles[2] == null) {
                                                        callApi();
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            } else if (i == 1) {
                                              ex = p.basename(allFiles[i].path);

                                              _uploadFile(allFiles[i],
                                                      "Certificate 10th", i, ex)
                                                  .then((url) {
                                                setState(() {
                                                  education["XII"]
                                                      ["certificate"] = url;
                                                  if (allFiles[2] == null) {
                                                    callApi();
                                                  }
                                                });

                                                //print(education);
                                              });
                                            } else if (i == 2) {
                                              ex = p.basename(allFiles[i].path);
                                              _uploadFile(allFiles[i],
                                                      "Certificate 10th", i, ex)
                                                  .then((url) {
                                                setState(() {
                                                  education["X"]
                                                      ["certificate"] = url;
                                                  print(education);
                                                  callApi();
                                                });
                                              });
                                            }
                                          } else {
                                            if (i == 2) {
                                              showToast(
                                                  'Uploading Documents\n might take some time',
                                                  context,
                                                  duration: 5);
                                              dynamic result = await _APIService
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
                                                Navigator.pop(context);
                                              } else {
                                                showToast(
                                                    'Unexpected error occured',
                                                    context);
                                              }
                                            }
                                          }
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
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
