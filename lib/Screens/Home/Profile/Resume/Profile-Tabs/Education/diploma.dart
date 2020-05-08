import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diploma extends StatefulWidget {
  final Map<dynamic, dynamic> xii;

  const Diploma({Key key, @required this.xii}) : super(key: key);
  @override
  _DiplomaState createState() => _DiplomaState();
}

class _DiplomaState extends State<Diploma> {
  double height, width;
  File file;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit;
  String institute, stream, board, cgpa, email, specialization;
  DateTime from, to;
  StorageUploadTask uploadTask;
  Map<dynamic, dynamic> education;

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("documents/$filename");
    uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    if (url != null) {
    } else if (url == null) {}
  }

  void init() {
    if (widget.xii['XII'] != null)
      setState(() {
        education = widget.xii;
        institute = widget.xii['XII']['institute'] ?? "";
        board = widget.xii['XII']['board'] ?? "";
        cgpa = widget.xii['XII']['score'].toString() ?? "";
        specialization = widget.xii['XII']['specialization'];
        if (widget.xii['XII']['start'] != null &&
            widget.xii['XII']['end'] != null) {
          from = DateTime.fromMicrosecondsSinceEpoch(
              widget.xii['XII']['start'].microsecondsSinceEpoch);
          to = DateTime.fromMicrosecondsSinceEpoch(
              widget.xii['XII']['end'].microsecondsSinceEpoch);
        }

        unit = widget.xii['X']['score_unit'];
      });
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );
      if (file != null) {
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        // _uploadFile(file, fileName);
        // setState(() {
        //   x = currentState.uploading;
        // });
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
    return Scaffold(
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
        body: SingleChildScrollView(
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
                    initialValue: institute,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: x("Institute Name"),
                    onChanged: (text) {
                      setState(() => education['XII']['institute'] = text);
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
                    initialValue: stream ?? null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: x("Stream"),
                    onChanged: (text) {
                      setState(() => education['XII']['stream'] = text);
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
                    initialValue: specialization ?? null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: x("Specialization"),
                    onChanged: (text) {
                      setState(() => education['XII']['specialization'] = text);
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Specialization cannot be empty';
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: board ?? null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    onChanged: (text) {
                      setState(() => education['XII']['board'] = text);
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
                    children: <Widget>[
                      Container(
                        width: width * 0.35,
                        child: TextFormField(
                          initialValue: cgpa ?? null,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("CGPA"),
                          onChanged: (text) {
                            setState(() => education['XII']['score'] = text);
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return 'CGPA cannot be empty';
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
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                                      child: Icon(Icons.keyboard_arrow_down),
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
                                        education['XII']['score_unit'] = value;
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
                    children: <Widget>[
                      Container(
                        width: width * 0.35,
                        child: DateTimeField(
                          initialValue: from ?? null,
                          decoration: InputDecoration(
                              hintText: "From:",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 10.0),
                              hintStyle: TextStyle(fontWeight: FontWeight.w600),
                              labelStyle: TextStyle(color: Colors.black)),
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: from ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            Timestamp myTimeStamp = Timestamp.fromDate(date);
                            setState(() {
                              education['XII']['start'] = myTimeStamp;
                            });
                            return date;
                          },
                          validator: (value) {
                            if (value == null)
                              return 'Date \ncannot be empty';
                            else
                              return null;
                          },
                          // decoration: x("From")
                        ),
                      ),
                      Container(
                        width: width * 0.35,
                        child: DateTimeField(
                          initialValue: to ?? null,
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: to ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            Timestamp myTimeStamp = Timestamp.fromDate(date);
                            setState(() {
                              education['XII']['end'] = myTimeStamp;
                            });
                            return date;
                          },
                          decoration: InputDecoration(
                              hintText: "To:",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 10.0),
                              hintStyle: TextStyle(fontWeight: FontWeight.w600),
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value == null)
                              return 'Date \ncannot be empty';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                            decoration: InputDecoration(
                                hintText: 'Certificate',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w400),
                                labelStyle: TextStyle(color: Colors.black))),
                      ),
                      InkWell(
                        onTap: () async {
                          filePicker(context);
                        },
                        child: Container(
                          color: Colors.grey,
                          width: width * 0.25,
                          child: TextField(
                              enabled: false,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: 'Browse',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      borderSide:
                                          BorderSide(color: Color(0xff4285f4))),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 10.0),
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  labelStyle: TextStyle(color: Colors.black))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
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
                              side: BorderSide(color: basicColor, width: 1.2),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: basicColor),
                            ),
                            onPressed: () {
                              print(Theme.of(context).scaffoldBackgroundColor);
                            }),
                        RaisedButton(
                            color: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.only(left: 22, right: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: basicColor, width: 1.2),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: basicColor),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate())
                                print(education);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
