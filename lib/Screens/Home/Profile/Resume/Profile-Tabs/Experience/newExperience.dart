import 'dart:io';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewExperience extends StatefulWidget {

  List experiences;
  int index;
  bool old;
  String email;
  NewExperience({this.experiences, this.index, this.old, this.email});
  @override
  _NewExperienceState createState() => _NewExperienceState();
}

class _NewExperienceState extends State<NewExperience> {
  double width, height, scale;
  List experiences;
  String email;
  int index;
  File file;
  bool loading = false;
  final format = DateFormat("MM-yyyy");
  final _formKey = GlobalKey<FormState>();

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(type: FileType.custom);
      setState(() {

      });
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e,
              body: Text("Error Has Occured"))
          .show();
    }
  }

  getInfo() async {
    await SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString('email');
      });
    });
  }

  @override
  void initState() {
    getInfo();
    if(widget.old == true) {
      experiences = widget.experiences;
      index = widget.index;
    }
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
    if(width < 360)
      scale = 0.7;
    else scale = 1;
    return loading ? Loading() : Scaffold(
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
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    left: width * 0.1 * scale, top: 20, right: width * 0.1 * scale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            enabled: false,
                            initialValue: 'Experience Type',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Last Name"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0 * scale, 0, 0 * scale, 0),
                              child: DropdownButton<String>(
                                hint: Text("Experience Type"),
                                value: experiences[index]['Type'] == null ? 'Male' : (experiences[index]['Type'].substring(0, 1)).toUpperCase() + experiences[index]['Type'].substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 0.0 * scale),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Internship Internship', 'Internship']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    experiences[index]['Type'] = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: experiences[index]['company'] ?? '',
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: x("Company"),
                      onChanged: (text) {
                        setState(() => experiences[index]['company'] = text);
                      },
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.35 * scale,
                          child: DateTimeField(
                              format: format,
                              initialValue: experiences[index]['from'] == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                  experiences[index]['from'].microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var temp = experiences[index]['from'] != null
                                    ? format
                                    .format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        experiences[index]['from'].microsecondsSinceEpoch))
                                    .toString() ??
                                    "DOB"
                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  experiences[index]['from'] = date == null
                                      ? null
                                      : Timestamp.fromMicrosecondsSinceEpoch(
                                      date.microsecondsSinceEpoch);
                                });
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: x("From")),
                        ),
                        Container(
                          width: width * 0.35 * scale,
                          child: DateTimeField(
                              format: format,
                              initialValue: experiences[index]['to'] == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                  experiences[index]['to'].microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var temp = experiences[index]['to'] != null
                                    ? format
                                    .format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        experiences[index]['to'].microsecondsSinceEpoch))
                                    .toString() ??
                                    "DOB"
                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  experiences[index]['to'] = date == null
                                      ? null
                                      : Timestamp.fromMicrosecondsSinceEpoch(
                                      date.microsecondsSinceEpoch);
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
                    TextFormField(
                      initialValue: experiences[index]['designation'] ?? '',
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: x("Designation"),
                      onChanged: (text) {
                        setState(() => experiences[index]['designation'] = text);
                      },
                    ),
                    SizedBox(height: 15),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            enabled: false,
                            initialValue: 'Industry Type',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Last Name"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10 * scale, 0, 5 * scale, 0),
                              child: DropdownButton<String>(
                                hint: Text("Industry Type"),
                                value: experiences[index]['industry'] == null ? 'Male' : experiences[index]['industry'].substring(0, 1).toUpperCase() + experiences[index]['industry'].substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 10.0 * scale),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Other', 'Employment']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    experiences[index]['industry'] = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            enabled: false,
                            initialValue: 'Domain',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Last Name"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10 * scale, 0, 5 * scale, 0),
                              child: DropdownButton<String>(
                                hint: Text("Domain"),
                                value: experiences[index]['domain'] == null ? 'Male' : experiences[index]['domain'].substring(0, 1).toUpperCase() + experiences[index]['domain'].substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 10.0 * scale),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Other', 'Software Development']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    experiences[index]['domain'] = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        SizedBox(
                          width: width * 0.2 * scale,
                          child: Stack(
                            children: <Widget>[
                              Align(alignment: Alignment.bottomLeft,child: AutoSizeText(file == null ? '' : file.path.split('/').last, overflow: TextOverflow.clip,
                                maxLines: 1,)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Visibility(
                                  visible: file != null || experiences[index]['certificate'] != null,
                                  child: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                        experiences[index]['certificate'] = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      decoration: InputDecoration(
                          hintText: 'eg: 1st Prize in Skating',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ))),
                      initialValue: experiences[index]['information'] == null ? '' :  (experiences[index]['information'][0] ?? ''),
                      onChanged: (text) {
                        setState(() => experiences[index]['information'][0] = text);
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
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      decoration: InputDecoration(
                          hintText: 'eg: 1st Prize in Skating',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ))),
                      initialValue: experiences[index]['information'] == null ? '' :  (experiences[index]['information'][1] ?? ''),
                      onChanged: (text) {
                        setState(() => experiences[index]['information'][1] = text);
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
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      decoration: InputDecoration(
                          hintText: 'eg: 1st Prize in Skating',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ))),
                      initialValue: experiences[index]['information'] == null ? '' :  (experiences[index]['information'][2] ?? ''),
                      obscureText: false,
                      onChanged: (text) {
                        setState(() => experiences[index]['information'][2] = text);
                      },
                    ),
                    SizedBox(height: 30.0),
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
                                side:
                                BorderSide(color: basicColor, width: 1.2),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: basicColor),
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                experiences.removeAt(index);
                                await SharedPreferences.getInstance()
                                    .then((prefs) async {
                                  await Firestore.instance
                                      .collection('candidates')
                                      .document(
                                      prefs.getString('email'))
                                      .setData({
                                    'experience': experiences
                                  }).then((f) {
                                    Navigator.pop(context);
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                });
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
                                'Save',
                                style: TextStyle(color: basicColor),
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                await SharedPreferences.getInstance()
                                    .then((prefs) async {
                                  await Firestore.instance
                                      .collection('candidates')
                                      .document(
                                      prefs.getString('email'))
                                      .setData({
                                    'experience': experiences
                                  }).then((f) {
                                    Navigator.pop(context);
                                  });
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
