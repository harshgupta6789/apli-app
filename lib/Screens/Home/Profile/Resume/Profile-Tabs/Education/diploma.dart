import 'dart:io';

import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/tenth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
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

class Diploma extends StatefulWidget {
  final Map<dynamic, dynamic> xii;
  final List allFiles;
  final bool isUg;
  final String courseEdu, type;

  const Diploma(
      {Key key,
      @required this.xii,
      this.allFiles,
      this.isUg,
      this.courseEdu,
      this.type})
      : super(key: key);
  @override
  _DiplomaState createState() => _DiplomaState();
}

class _DiplomaState extends State<Diploma> {
  double height, width, scale;
  File file;
  List allFiles;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit, type;
  String score;
  String institute, stream, board, email, specialization, certificate;
  Timestamp start, end;
  StorageUploadTask uploadTask;
  Map<dynamic, dynamic> education;

  void init() {
    setState(() {
      allFiles = widget.allFiles;
      education = widget.xii;
      type = widget.type;
    });
    if (type == null) {
      setState(() {
        type = 'XII';
        institute = '';
        board = '';
        score = '';
        specialization = '';
        start = Timestamp.now();
        end = Timestamp.now();
        unit = '%';
        certificate = null;
      });
    } else {
      print(education.keys);
      print(type);
      setState(() {
        institute = education[type]['institute'] ?? "";
        board = education[type]['board'] ?? "";
        score = education[type]['score'] != null
            ? education[type]['score'].toString()
            : "";
        specialization = education[type]['specialization'] ?? '';
        start = education[type]['start'] ?? Timestamp.now();
        end = education[type]['end'] ?? Timestamp.now();
        unit = education[type]['score_unit'] ?? '%';
        certificate = education[type]['certificate'];
      });
    }
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
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: basicColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  twelve,
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
                      DropdownButton<String>(
                        //hint: Text("Unit"),
                        value: type ?? 'XII',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.headline4.color,
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        underline: SizedBox(),
                        items: <String>['XII', 'Diploma']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            type = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: institute ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Institute Name"),
                        onChanged: (text) {
                          setState(() => institute = text);
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
                        initialValue: specialization ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Stream"),
                        onChanged: (text) {
                          setState(() => specialization = text);
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
                        initialValue: board ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        onChanged: (text) {
                          setState(() => board = text);
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
                              initialValue:
                                  score == null ? '' : score.toString(),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              decoration: x("Score"),
                              onChanged: (text) {
                                setState(() => score = text);
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(left: 10),
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
                                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      child: DropdownButton<String>(
                                        //hint: Text("Unit"),
                                        value: unit ?? '%',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .color,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child:
                                              Icon(Icons.keyboard_arrow_down),
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
                                            unit = value;
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
                            var temp = start != null
                                ? format
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                start.microsecondsSinceEpoch))
                                        .toString() ??
                                    "DOB"
                                : "DOB";
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
                              return 'Date cannot be empty';
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
                            var temp = end != null
                                ? format
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                end.microsecondsSinceEpoch))
                                        .toString() ??
                                    "DOB"
                                : "DOB";
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
                                    fontWeight: FontWeight.w500, fontSize: 14),
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
                                child: Text(file == null ? "Browse" : "Remove"),
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
                                  padding: EdgeInsets.only(left: 22, right: 22),
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
                                  side:
                                      BorderSide(color: basicColor, width: 1.2),
                                ),
                                child: Text(
                                  'Next',
                                  style: TextStyle(color: basicColor),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    String formattedTo, formattedFrom;
                                    setState(() {
                                      formattedFrom =
                                          format.format(start.toDate());
                                      formattedFrom =
                                          formattedFrom + " 00:00:00+0000";

                                      formattedTo = format.format(end.toDate());
                                      formattedTo =
                                          formattedTo + " 00:00:00+0000";
                                    });
                                    String temp = type;
                                    if (widget.type == null) {
                                    } else if (widget.type == temp) {
                                    } else {
                                      education.remove(widget.type);
                                    }
                                    education[temp] = {};
                                    education[temp]['institute'] = institute;
                                    education[temp]['board'] = board;
                                    education[temp]['score'] = score;
                                    education[temp]['specialization'] =
                                        specialization;
                                    education[temp]['start'] = formattedFrom;
                                    education[temp]['end'] = formattedTo;
                                    education[temp]['score_unit'] = unit;
                                    education[temp]['certificate'] =
                                        certificate;
                                    print(education.keys);
                                    print(education);
                                    allFiles.add(file);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Tenth(
                                                  x: education,
                                                  courseEdu: widget.courseEdu,
                                                  allFiles: allFiles,
                                                  isUg: widget.isUg,
                                                  type: temp,
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
