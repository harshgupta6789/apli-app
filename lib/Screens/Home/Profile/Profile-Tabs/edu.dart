import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double height, width;

class Education extends StatefulWidget {
  @override
  _EducationState createState() => _EducationState();
}

class _EducationState extends State<Education>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  File file;
  String institute = '', stream = '', board = '', cgpa = '', unit = '';
  final format = DateFormat("yyyy-MM-dd");

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

  void getInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      await Firestore.instance
          .collection('candidates')
          .document(prefs.getString('email'))
          .get()
          .then((s) async {
            print(s.data['education']['X']);
            if(s.data['education']['X']['institute']!=null){
               setState(() {
                 institute = s.data['education']['X']['institute'];
                 print(institute);
               });
            }
          });
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();
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
                editEdu,
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
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: basicColor),
                  ),
                  tabs: [
                    Tab(
                      text: clg,
                    ),
                    Tab(
                      text: twelve,
                    ),
                    Tab(text: ten)
                  ],
                  controller: _tabController,
                )),
          ),
          preferredSize: Size.fromHeight(100),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "Assets/Images/profile.png",
                    height: 300,
                    width: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: " You can start applying for\n",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                            TextSpan(text: " after filling in the details.")
                          ]),
                    ),
                  )
                ],
              ),
            )),
            StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
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
                                "12th Standard",
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
                                  
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      hintText: "",
                                      labelText:  institute??"",
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (text) {
                                    setState(() => institute = text);
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
                                "Stream :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 15.0, left: 18.0, right: 18.0),
                                child: TextFormField(
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      hintText: 'Work Email Address',
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (text) {
                                    setState(() => institute = text);
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
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff4285f4))),
                                      hintText: 'Work Email Address',
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (text) {
                                    setState(() => institute = text);
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
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            hintText: 'Work Email Address',
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => institute = text);
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
                                        obscureText: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4285f4))),
                                            hintText: 'Work Email Address',
                                            labelStyle:
                                                TextStyle(color: Colors.black)),
                                        onChanged: (text) {
                                          setState(() => institute = text);
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
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 18.0),
                                  child: Text(
                                    "Certificate",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, left: width * 0.28),
                                    child: MaterialButton(
                                      onPressed: () {
                                        filePicker(context);
                                      },
                                      child: Text("Browse"),
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("Assets/Images/profile.png",
                            height: 300, width: 300),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Your test will be shown here.",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ))),
          ],
          controller: _tabController,
        ));
  }
}
