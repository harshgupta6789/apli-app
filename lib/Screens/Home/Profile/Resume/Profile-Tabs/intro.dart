import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicIntro extends StatefulWidget {
  @override
  _BasicIntroState createState() => _BasicIntroState();
}

class _BasicIntroState extends State<BasicIntro> {
  File _image;
  NetworkImage img;
  String dropdownValue;
  String userEmail;
  List<String> gendersList = ['male', 'female', 'other'];
  String fname = '',
      mname = '',
      lname = '',
      email = '',
      mno = '',
      gender = '',
      bldg = '',
      country = '',
      state = '',
      postal = '',
      city = '';

  void fetchInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        setState(() {
          userEmail = prefs.getString('email');
        });
      }
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: basicColor,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              intro,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
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
              return SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                          minRadius: 55, maxRadius: 60, backgroundImage: null),
                      MaterialButton(
                        onPressed: getImage,
                        child: Text("Change Profile Photo",
                            style: TextStyle(color: basicColor)),
                      ),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['First_name'] != null
                                    ? snapshot.data['First_name'] ?? ""
                                    : "First Name",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => fname = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Middle_name'] != null
                                    ? snapshot.data['Middle_name'] ?? ""
                                    : "Middle Name",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => mname = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Last_name'] != null
                                    ? snapshot.data['Last_name'] ?? ""
                                    : "Last Name",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => lname = text);
                            },
                          )),
                      Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['email'] != null
                                    ? snapshot.data['email'] ?? ""
                                    : "Email",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => email = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['ph_no'] != null
                                    ? snapshot.data['ph_no'].toString() ?? ""
                                    : "Mobile",
                                hintText: 'Mobile',
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => mno = text);
                            },
                          )),
                      Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: DateTimeField(
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));

                              return date;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 10.0),
                              labelText: snapshot.data['dob'] != null
                                  ? format
                                          .format(DateTime
                                              .fromMicrosecondsSinceEpoch(
                                                  snapshot.data['dob']
                                                      .microsecondsSinceEpoch))
                                          .toString() ??
                                      "DOB"
                                  : "DOB",
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff4285f4))),
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),

                              // dropdown below..
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Gender : "),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 42,
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['Male', 'Female', 'Other']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ))),
                      Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Address'] != null
                                    ? snapshot.data['Address']['address'] ??
                                        "Address"
                                    : "Street",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => bldg = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Address'] != null
                                    ? snapshot.data['Address']['country'] ??
                                        "Country"
                                    : "Country",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => country = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Address'] != null
                                    ? snapshot.data['Address']['state'] ??
                                        "State"
                                    : "State",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => state = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Address'] != null
                                    ? snapshot.data['Address']['postal_code']
                                            .toString() ??
                                        "Postal Code"
                                    : "Postal Code",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => postal = text);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff4285f4))),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 10.0),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                labelText: snapshot.data['Address'] != null
                                    ? snapshot.data['Address']['city'] ?? "City"
                                    : "City",
                                labelStyle: TextStyle(color: Colors.black)),
                            onChanged: (text) {
                              setState(() => city = text);
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
              ));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text("Error"));
          } else {
            return Loading();
          }
          return Loading();
        },
      ),
    );
  }
}
