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
  @override
  _DiplomaState createState() => _DiplomaState();
}

class _DiplomaState extends State<Diploma> {
  double height, width;
  File file;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String fileName;
  String unit = '/100';
  String institute, stream, board, cgpa, email;
  DateTime from, to;
  StorageUploadTask uploadTask;

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

  void getInfo() async {
    try {
      await SharedPreferences.getInstance().then((prefs) async {
        await Firestore.instance
            .collection('candidates')
            .document(prefs.getString('email'))
            .get()
            .then((s) {
          print(s.data['education']['XII']);
          if (s.data['education']['XII'] != null) {
            setState(() {
              institute = s.data['education']['XII']['institute'];
              board = s.data['education']['XII']['board'];
              stream = s.data['education']['XII']['stream'];
              cgpa = s.data['education']['XII']['cgpa'];
              unit = s.data['education']['XII']['unit'];
              from = DateTime.fromMicrosecondsSinceEpoch(
                  s.data['education']['XII']['start'].microsecondsSinceEpoch);
              to = DateTime.fromMicrosecondsSinceEpoch(
                  s.data['education']['XII']['end'].microsecondsSinceEpoch);
              email = s.data['email'];

              print(institute);
            });
          }
        });
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
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
        _uploadFile(file, fileName);
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
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return email == null
        ? Loading()
        : loading
            ? Loading()
            : Scaffold(
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
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: x("Institute Name"),
                            onChanged: (text) {
                              setState(() => institute = text);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: stream ?? null,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: x("Stream"),
                            onChanged: (text) {
                              setState(() => stream = text);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: board ?? null,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: x("Board"),
                            onChanged: (text) {
                              setState(() => board = text);
                            },
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
                                    setState(() => institute = text);
                                  },
                                ),
                              ),
                              Container(
                                width: width * 0.35,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    //color: Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.05, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      "Unit",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                    icon: Expanded(
                                      child: Icon(Icons.keyboard_arrow_down),
                                    ),
                                    underline: SizedBox(),
                                    items: <String>['/10', '/100', '/4']
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
//                                      setState(() {
//                                        skills[index1][
//                                        skillName]
//                                        [index2][
//                                        miniSkill] = value;
//                                      });
                                    },
                                  ),
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
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10.0),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate: from ?? DateTime.now(),
                                        lastDate: DateTime(2100));

                                    return date;
                                  },
                                  // decoration: x("From")
                                ),
                              ),
                              Container(
                                width: width * 0.35,
                                child: DateTimeField(
                                    initialValue: to ?? null,
                                    format: format,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              to ?? DateTime.now(),
                                          lastDate: DateTime(2100));

                                      return date;
                                    },
                                    decoration:InputDecoration(
                                      hintText: "To:",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10.0),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      labelStyle:
                                          TextStyle(color: Colors.black)),),
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
                                            borderSide: BorderSide(
                                                color: Color(0xff4285f4))),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 2.0,
                                                horizontal: 10.0),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400),
                                        labelStyle:
                                            TextStyle(color: Colors.black))),
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
                                                topRight: Radius.circular(5),
                                                bottomRight:
                                                    Radius.circular(5)),
                                            borderSide: BorderSide(
                                                color: Color(0xff4285f4))),
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 2.0,
                                                horizontal: 10.0),
                                        hintStyle: TextStyle(fontSize: 13),
                                        labelStyle:
                                            TextStyle(color: Colors.black))),
                              ),
                            ],
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
                                    onPressed: () {
                                      print(Theme.of(context)
                                          .scaffoldBackgroundColor);
                                    }),
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
                                      'Save',
                                      style: TextStyle(color: basicColor),
                                    ),
                                    onPressed: () {}),
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