import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double height, width;

class Tenth extends StatefulWidget {
  @override
  _TenthState createState() => _TenthState();
}

class _TenthState extends State<Tenth> with SingleTickerProviderStateMixin {
  double height, width;
  File file;
  bool error = false, loading = false;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String email, fileName;
  String institute = '', board = '', cgpa = '', unit = '';
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
          print(s.data['education']['X']);
          if (s.data['education']['X'] != null) {
            setState(() {
              institute = s.data['education']['X']['institute'];
              board = s.data['education']['X']['board'];

              cgpa = s.data['education']['X']['cgpa'];
              unit = s.data['education']['X']['unit'];
              if (s.data['education']['X']['start'] != null) {
                from = DateTime.fromMicrosecondsSinceEpoch(
                    s.data['education']['X']['start'].microsecondsSinceEpoch);
              }
              if (s.data['education']['X']['end'] != null) {
                to = DateTime.fromMicrosecondsSinceEpoch(
                    s.data['education']['X']['end'].microsecondsSinceEpoch);
              }

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
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return email == null
        ? Loading()
        : loading
            ? Loading()
            : Scaffold(
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: basicColor,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        ten,
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
                            initialValue: institute ?? null,
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
                                    setState(() => cgpa = text);
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    icon: Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.1),
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
                                  decoration: InputDecoration(
                                      hintText: "To:",
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
                                        initialDate: to ?? DateTime.now(),
                                        lastDate: DateTime(2100));

                                    return date;
                                  },
                                  // decoration: x("From")
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Certificate",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  filePicker(context);
                                },
                                child: Text("Browse"),
                                color: Colors.grey,
                              ),
                            ],
                          ),
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
                                      onPressed: () {}),
                                ),
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
