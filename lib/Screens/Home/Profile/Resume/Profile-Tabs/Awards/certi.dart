import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Awards extends StatefulWidget {
  @override
  _AwardsState createState() => _AwardsState();
}

class _AwardsState extends State<Awards> {
  double width, height;
  String userEmail;
  File file;
  String desc;
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
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

  InputDecoration x(String t) {
    return InputDecoration(
        hintText: t,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4285f4))),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        hintStyle: TextStyle(fontWeight: FontWeight.w600),
        labelStyle: TextStyle(color: Colors.black));
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
                awards,
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
            return SingleChildScrollView(
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
                        initialValue: desc ?? null,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Description"),
                        onChanged: (text) {
                          setState(() => desc = text);
                        },
                      ),
                      SizedBox(height: 15.0),
                      DateTimeField(
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));

                            return date;
                          },
                          decoration: x("Date")),
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
            );
          },
        ));
  }
}
