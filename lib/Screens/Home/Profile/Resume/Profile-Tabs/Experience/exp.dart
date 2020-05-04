import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expereince extends StatefulWidget {
  @override
  _ExpereinceState createState() => _ExpereinceState();
}

class _ExpereinceState extends State<Expereince> {
  double width, height;
  String userEmail;
  File file;
  String desc, comp, desg, domain, exptype, bulletp1, bulletp2, bulletp3;
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
                experience,
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
                      Container(
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            //color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: DropdownButton<String>(
                            hint: Text("Experience Type"),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            icon: Padding(
                              padding: EdgeInsets.only(left: width * 0.34),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                            underline: SizedBox(),
                            items: <String>['/10', '/100', '/4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {});
//                                      setState(() {
//                                        skills[index1][
//                                        skilcomp]
//                                        [index2][
//                                        miniSkill] = value;
//                                      });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        initialValue: comp ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Company"),
                        onChanged: (text) {
                          setState(() => comp = text);
                        },
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: width * 0.35,
                            child: DateTimeField(
                                format: format,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));

                                  return date;
                                },
                                decoration: x("From")),
                          ),
                          Container(
                            width: width * 0.35,
                            child: DateTimeField(
                                format: format,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));

                                  return date;
                                },
                                decoration: x("To")),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        initialValue: comp ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Designation"),
                        onChanged: (text) {
                          setState(() => comp = text);
                        },
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            //color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: DropdownButton<String>(
                            hint: Text("Industry Type"),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            icon: Padding(
                              padding: EdgeInsets.only(left: width * 0.39),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                            underline: SizedBox(),
                            items: <String>['/10', '/100', '/4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {});
//                                      setState(() {
//                                        skills[index1][
//                                        skilcomp]
//                                        [index2][
//                                        miniSkill] = value;
//                                      });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            //color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: DropdownButton<String>(
                            hint: Text("Domain"),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            icon: Padding(
                              padding: EdgeInsets.only(left: width * 0.48),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                            underline: SizedBox(),
                            items: <String>['/10', '/100', '/4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {});
//                                      setState(() {
//                                        skills[index1][
//                                        skilcomp]
//                                        [index2][
//                                        miniSkill] = value;
//                                      });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
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
                      SizedBox(height: 15),
                      Text(
                        "Responsibilities",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Only 80 to 110 characters are allowed for each bullet point.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Bullet Point 1",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        maxLength: 110,
                        maxLines: 3,
                        initialValue: comp ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x(""),
                        onChanged: (text) {
                          setState(() => comp = text);
                        },
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Bullet Point 2",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        maxLength: 110,
                        maxLines: 3,
                        initialValue: comp ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x(""),
                        onChanged: (text) {
                          setState(() => comp = text);
                        },
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Bullet Point 3",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        maxLength: 110,
                        maxLines: 3,
                        initialValue: comp ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x(""),
                        onChanged: (text) {
                          setState(() => comp = text);
                        },
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
