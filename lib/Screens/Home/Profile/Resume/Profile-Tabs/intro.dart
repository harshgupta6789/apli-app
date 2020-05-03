import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicIntro extends StatefulWidget {
  @override
  _BasicIntroState createState() => _BasicIntroState();
}

class _BasicIntroState extends State<BasicIntro> {
  double width, height;
  File _image;
  bool loading = false, check = false;
  NetworkImage img;
  String dropdownValue;
  String userEmail;
  List<String> gendersList = ['male', 'female', 'other'];
  String profile = '',
      fname = '',
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
  Map<String, dynamic> address;
  Timestamp dob;
  var decoration = InputDecoration(
      border:
          OutlineInputBorder(borderSide: BorderSide(color: Color(0xff4285f4))),
      contentPadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      hintStyle: TextStyle(fontWeight: FontWeight.w600),
      labelStyle: TextStyle(color: Colors.black));

  getPrefs() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        if (mounted)
          setState(() {
            userEmail = prefs.getString('email');
          });
        else
          userEmail = prefs.getString('email');
        await Firestore.instance.collection('candidates').document(userEmail).get().then((snapshot) {
          profile = snapshot.data['First_name'];
          fname = snapshot.data['First_name'];
          mname = snapshot.data['Middle_name'];
          lname = snapshot.data['Last_name'];
          email = snapshot.data['email'];
          mno = snapshot.data['ph_no'];
          dob = snapshot.data['dob'];
          gender = snapshot.data['gender'];
          address = snapshot.data['Address'] ?? {};
          bldg = address['address'];
          country = address['country'];
          state = address['state'];
          postal = address['postal_code'];
          city = address['city'];
          check = true;
//          if(mounted)
            setState(() {

            });
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
    //getPrefs().then((value) {});
    (() async {
      await getPrefs();
      setState(() {});
    })();
    print(profile);
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
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
                    'Basic Info',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
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
                        children: <Widget>[
                          CircleAvatar(
                              minRadius: 55,
                              maxRadius: 60,
                              backgroundImage: _image != null
                                  ? FileImage(_image)
                                  : profile == null
                                  ? NetworkImage(profile)
                                  : null),
                          MaterialButton(
                            onPressed: getImage,
                            child: Text("Change Profile Photo",
                                style: TextStyle(color: basicColor)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: fname ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => fname = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: mname ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => mname = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: lname ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => lname = text);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: email ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => email = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: mno ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => mno = text);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DateTimeField(
                              format: format,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate:
                                    currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var temp = dob != null
                                    ? format
                                    .format(DateTime
                                    .fromMicrosecondsSinceEpoch(
                                    dob
                                        .microsecondsSinceEpoch))
                                    .toString() ??
                                    "DOB"
                                    : "DOB";
                                return date;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: decoration.copyWith(
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff4285f4))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff4285f4))),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey[300],
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                              child: DropdownButton<String>(
                                value: 'Male',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                                icon: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10.0),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Other']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  print(gender);
                                  setState(() {
                                    gender = value;
                                  });
                                  print(gender);
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
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: Text(
                              'Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            contentPadding: EdgeInsets.only(left: 0),
                          ),
                          TextFormField(
                            initialValue: bldg ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => bldg = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: country ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => country = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: state ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => state = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: postal ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => postal = text);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: city ?? '',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: false,
                            decoration: decoration,
                            onChanged: (text) {
                              setState(() => city = text);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side:
                              BorderSide(color: basicColor, width: 1.5),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: basicColor),
                            ),
                            onPressed: () async {
//                            setState(() {
//                              loading = true;
//                            });
//                            await Firestore.instance
//                                .collection('candidates')
//                                .document(email)
//                                .setData({'skills': skills},
//                                merge: true).then((f) {
//                              showToast('Data Updated Successfully', context);
//                              Navigator.pop(context);
//                            });
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          );
  }
}
