import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:apli/Shared/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
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
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  String userEmail;
  String institute = '',
      stream = '',
      board = '',
      cgpa = '',
      unit = '',
      i10 = '',
      b10 = '',
      cg10 = '',
      u10 = '';

  void fetchInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        setState(() {
          userEmail = prefs.getString('email');
        });
      }
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
    fetchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
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
        body: FutureBuilder(
            future: Firestore.instance
                .collection('candidates')
                .document(userEmail)
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "10th Standard",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              trailing: IconButton(
                                  icon: Icon(EvaIcons.editOutline),
                                  onPressed: null),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 18.0),
                              child: Text(
                                "Institute Name :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, left: 18.0, right: 18.0),
                                child: TextFormField(
                                  initialValue: i10,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (text) {
                                    setState(() => i10 = text);
                                  },
                                  validator: (value) {
                                    // if (!validateEmail(value)) {
                                    //   return 'please enter valid email';
                                    // }
                                    // return null;
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, left: 18.0),
                              child: Text(
                                "Board :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, left: 18.0, right: 18.0),
                                child: TextFormField(
                                  obscureText: false,
                                  initialValue: b10,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (text) {
                                    setState(() => b10 = text);
                                  },
                                  validator: (value) {
                                    // if (!validateEmail(value)) {
                                    //   return 'please enter valid email';
                                    // }
                                    // return null;
                                  },
                                )),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 18.0),
                                  child: Text(
                                    "CGPA :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 15.0, left: width * 0.3),
                                  child: Text(
                                    "Unit :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 18.0),
                                    child: Container(
                                      width: width * 0.41,
                                      child: TextFormField(
                                        initialValue: cg10,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => cg10 = text);
                                        },
                                        validator: (value) {
                                          // if (!validateEmail(value)) {
                                          //   return 'please enter valid email';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 10.0),
                                    child: Container(
                                      width: width * 0.41,
                                      child: TextFormField(
                                        initialValue: u10,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => u10 = text);
                                        },
                                        validator: (value) {
                                          // if (!validateEmail(value)) {
                                          //   return 'please enter valid email';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 18.0),
                                  child: Text(
                                    "From",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 2.0),
                                    child: Icon(Icons.calendar_today)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 15.0, left: width * 0.28),
                                  child: Text(
                                    "To :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 18.0),
                                    child: Container(
                                      width: width * 0.41,
                                      child: DateTimeField(
                                          format: format,
                                          onShowPicker:
                                              (context, currentValue) async {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1900),
                                                initialDate: currentValue ??
                                                    DateTime.now(),
                                                lastDate: DateTime(2100));

                                            return date;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "From",
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                          )),
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 12.0),
                                    child: Container(
                                      width: width * 0.41,
                                      child: DateTimeField(
                                          format: format,
                                          onShowPicker:
                                              (context, currentValue) async {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1900),
                                                initialDate: currentValue ??
                                                    DateTime.now(),
                                                lastDate: DateTime(2100));

                                            return date;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "From",
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                          )),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 15.0,
                                      left: 18.0,
                                    ),
                                    child: Text(
                                      "Certificate",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0, right: 10.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          filePicker(context);
                                        },
                                        child: Text("Browse"),
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: basicColor),
                                        borderRadius: BorderRadius.circular(10),
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
                                        borderRadius: BorderRadius.circular(10),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text("Error"));
              } else {
                return Loading();
              }
              return Loading();
            }));
  }
}
