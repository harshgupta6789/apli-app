import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
      await Firestore.instance
          .collection('candidates')
          .document(prefs.getString('email'))
          .get()
          .then((s) async {
        print(s.data['Address']);
        setState(() {
          fname = s.data['First_name'] ?? "";
          lname = s.data['Last_name'] ?? "";
          mname = s.data['Middle_name'] ?? "";
          email = s.data['email'] ?? "";
          mno = s.data['ph_no'].toString() ?? "";
          print(mname);
          //img = NetworkImage(s.data['profile_picture'].toString())??"";
        });
        if (s.data['Address'] != null) {
          setState(() {
            bldg = s.data['Address']['address'] ?? "";
            city = s.data['Address']['city'] ?? "";
            country = s.data['Address']['country'] ?? "";
            state = s.data['Address']['state'] ?? "";
            postal = s.data['Address']['postal_code'].toString() ?? "";
          });
        }
      });
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

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
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                  minRadius: 55, maxRadius: 60, backgroundImage: img ?? null),
              MaterialButton(
                onPressed: getImage,
                child: Text("Change Profile Photo",
                    style: TextStyle(color: basicColor)),
              ),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: fname ?? "",
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => fname = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: mname ?? "Middle Name",
                        hintText: 'Middle Name',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => mname = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: lname ?? "Last Name",
                        hintText: 'Last Name',
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: email ?? "Email",
                        hintText: 'Email',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => email = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: mno ?? "Mobile",
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      labelText: "DOB",
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff4285f4))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff4285f4))),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: DropDownField(
                      value: gender,
                      labelText: 'Gender',
                      items: gendersList,
                      setter: (dynamic newValue) {
                        setState(() {
                          gender = newValue;
                        });
                      })),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: bldg ?? "Street",
                        hintText: 'Street',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => bldg = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: country ?? "Country",
                        hintText: 'Country',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => country = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: state ?? "State",
                        hintText: 'State',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => state = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: postal ?? "Postal Code",
                        hintText: 'Postal Code',
                        labelStyle: TextStyle(color: Colors.black)),
                    onChanged: (text) {
                      setState(() => postal = text);
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4285f4))),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        labelText: city ?? "City",
                        hintText: 'City',
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
      )),
    );
  }
}
