import 'dart:io';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCoursesHome.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

class Other extends StatefulWidget {
  final Map<dynamic, dynamic> oth;
  final List allFiles, otherCourses, nameofOtherCourses;
  final String courseEdu, type;
  final bool old;
  final int index;

  const Other(
      {Key key,
      @required this.oth,
      this.allFiles,
      this.courseEdu,
      this.old,
      this.otherCourses,
      this.nameofOtherCourses,
      this.index,
      this.type})
      : super(key: key);
  @override
  _OtherState createState() => _OtherState();
}

class _OtherState extends State<Other> {
  double height, width, scale;
  File file;
  List allFiles;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit;
  List otherCourses, nameofOtherCourses;
  String institute, board, cgpa, email, fos, certificate, courseName;
  Timestamp start, end;
  Map<dynamic, dynamic> education;
  int index;

  void init() {
    index = widget.index;
    otherCourses = widget.otherCourses;
    if (widget.old == false) {
      otherCourses.add({});
      courseName = '';
    } else {
      courseName = widget.nameofOtherCourses[index];
    }
    setState(() {
      allFiles = widget.allFiles;
      education = widget.oth;
      institute = widget.otherCourses[index]['institute'] ?? "";
      certificate = widget.otherCourses[index]['certificate'] ?? null;
      board = widget.otherCourses[index]['board'] ?? "";
      cgpa = widget.otherCourses[index]['score'] == null ? null : widget.otherCourses[index]['score'].toString();
      fos = widget.otherCourses[index]['specialization'];
      start = widget.otherCourses[index]['start'] ?? Timestamp.now();
      end = widget.otherCourses[index]['end'] ?? Timestamp.now();
      unit = widget.otherCourses[index]['score_unit'] ?? '%';
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
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherCoursesHome(
          allFiles: allFiles,
          education: education,
          courseEdu:
          widget.courseEdu,
          type: widget.type,
        )));
      },
      child: Scaffold(
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: basicColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Other Courses',
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
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherCoursesHome(
                        allFiles: allFiles,
                        education: education,
                        courseEdu:
                        widget.courseEdu,
                        type: widget.type,
                      )));
                    }),
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
                        initialValue: courseName ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Course Name"),
                        onChanged: (text) {
                          setState(() => courseName = text);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'course cannot be empty';
                          else
                            return null;
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
                        decoration: x('Board/University'),
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
                              initialValue: cgpa == null ? '' : cgpa.toString(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(),
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              obscureText: false,
                              decoration: x("Score"),
                              onChanged: (text) {
                                cgpa = text;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'cgpa cannot be empty';
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
                                    decoration: x("Unit"),
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
                                            color: Colors.black,
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
                              return 'cannot be empty';
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
                                initialDate:
                                currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            var temp = start != null
                                ? format
                                .format(DateTime
                                .fromMicrosecondsSinceEpoch(start
                                .microsecondsSinceEpoch))
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
                      SizedBox(height: 15.0),
                      DateTimeField(
                          validator: (value) {
                            if (value == null) {
                              return 'cannot be empty';
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
                                initialDate:
                                currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            var temp = end != null
                                ? format
                                .format(DateTime
                                .fromMicrosecondsSinceEpoch(end
                                .microsecondsSinceEpoch))
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
                                  if(file == null) {
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
                      SizedBox(height: height * 0.2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
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
                                  widget.old == true ? 'Delete' : 'Cancel',
                                  style: TextStyle(color: basicColor),
                                ),
                                onPressed: () {
                                  if(widget.old == true) {
                                    education.remove(courseName);
                                    allFiles[3].removeAt(index);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherCoursesHome(
                                      allFiles: allFiles,
                                      education: education,
                                      courseEdu:
                                      widget.courseEdu,
                                      type: widget.type,
                                    )));
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherCoursesHome(
                                      allFiles: allFiles,
                                      education: education,
                                      courseEdu:
                                      widget.courseEdu,
                                      type: widget.type,
                                    )));
                                  }
                                }),
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
                                  'Done',
                                  style: TextStyle(color: basicColor),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    allFiles[3].add(file);
                                    otherCourses[index]['start'] = start ?? Timestamp.now();
                                    otherCourses[index]['end'] = end ?? Timestamp.now();
                                    otherCourses[index]['institute'] = institute;
                                    otherCourses[index]['board'] = board;
                                    otherCourses[index]['score'] = cgpa;
                                    otherCourses[index]['score_unit'] = unit ?? '%';
                                    otherCourses[index]['certificate'] = certificate;
                                    otherCourses[index]['specialization'] = '';
                                    if(widget.old)
                                      education[
                                              widget.nameofOtherCourses[index]] =
                                          otherCourses[index];
                                    else {
                                      education[courseName] =
                                      otherCourses[index];
                                    }
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherCoursesHome(
                                      allFiles: allFiles,
                                      education: education,
                                      courseEdu:
                                      widget.courseEdu,
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
              ),
            ),
          )),
    );
  }

}
