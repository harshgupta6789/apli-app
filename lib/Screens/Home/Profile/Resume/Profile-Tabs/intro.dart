import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  bool loading = false, check = false, error = false;
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

  getPrefs() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        if (mounted)
          setState(() {
            userEmail = prefs.getString('email');
          });
        else
          userEmail = prefs.getString('email');
        try {
          await Firestore.instance
              .collection('candidates')
              .document(userEmail)
              .get()
              .then((snapshot) {
            setState(() {
              profile = snapshot.data['profile_picture'];
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
            });
          });
        } catch (e) {
          setState(() {
            error = true;
          });
        }
      }
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
  void initState() {
    getPrefs();
    super.initState();
  }

  final format = DateFormat("dd-MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return loading || !check
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
                              : profile != null ? NetworkImage(profile) : null),
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
                        decoration: x("First Name"),
                        onChanged: (text) {
                          setState(() => fname = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: mname ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Middle Name"),
                        onChanged: (text) {
                          setState(() => mname = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: lname ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Last Name"),
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
                      DateTimeField(
                          format: format,
                          initialValue: dob == null
                              ? null
                              : DateTime.fromMicrosecondsSinceEpoch(
                                  dob.microsecondsSinceEpoch),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            var temp = dob != null
                                ? format
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                dob.microsecondsSinceEpoch))
                                        .toString() ??
                                    "DOB"
                                : "DOB";
                            return date;
                          },
                          onChanged: (date) {
                            setState(() {
                              dob = date == null
                                  ? null
                                  : Timestamp.fromMicrosecondsSinceEpoch(
                                      date.microsecondsSinceEpoch);
                            });
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          decoration: x("DOB")),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              enabled: false,
                              initialValue: 'Gender',
                              style: TextStyle(fontWeight: FontWeight.w500),
                              decoration: x("Last Name"),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: DropdownButton<String>(
                                  hint: Text("Gender"),
                                  value: gender ?? 'Male',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
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
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
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
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        contentPadding: EdgeInsets.only(left: 0),
                      ),
                      TextFormField(
                        initialValue: bldg ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Street"),
                        onChanged: (text) {
                          setState(() => bldg = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: country ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Country"),
                        onChanged: (text) {
                          setState(() => country = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: state ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("State"),
                        onChanged: (text) {
                          setState(() => state = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: postal ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("Postal Code"),
                        onChanged: (text) {
                          setState(() => postal = text);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: city ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        obscureText: false,
                        decoration: x("City"),
                        onChanged: (text) {
                          setState(() => city = text);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: basicColor, width: 1.5),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: basicColor),
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await Firestore.instance
                              .collection('candidates')
                              .document(email)
                              .setData({
                            'First_name': fname,
                            'Middle_name': mname,
                            'Last_name': lname,
                            'dob': dob,
                            'gender': gender,
                            'Address': {
                              'address': bldg,
                              'country': country,
                              'state': state,
                              'postal_code': postal,
                              'city': city
                            }
                          }, merge: true).then((f) async {
                            if(_image != null) {
                              StorageReference storageReference;
                              storageReference =
                                  FirebaseStorage.instance.ref().child("resumePictures/$email");
                              StorageUploadTask uploadTask = storageReference.putFile(_image);
                              final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                              await downloadUrl.ref.getDownloadURL().then((url) async {
                                await Firestore.instance.collection('candidates').document(email).setData({'profile_picture' : url}, merge: true);
                              });
                              showToast('Data Updated Successfully', context);
                            }
                            Navigator.pop(context);
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )),
            ));
  }
}
