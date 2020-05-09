import 'dart:io';

import 'package:apli/Services/APIService.dart';
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
  double width, height, scale;
  File _image;
  bool loading = false, error = false;
  NetworkImage img;
  String dropdownValue, newLanguage;
  List<String> gendersList = ['male', 'female', 'other'];
  String profile = '',
      fname = '',
      mname = '',
      lname = '',
      email,
      mno = '',
      gender = '',
      roll_no = '',
      highest_qualification = '',
      postal = '';
  Map<String, dynamic> address, languages;
  Map<String, dynamic> completeIntro;
  List languagesList = [];
  Timestamp dob;
  Map<String, TextEditingController> temp = {};
  final _APIService = APIService(type: 8);

  getPrefs() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        try {
          await Firestore.instance
              .collection('candidates')
              .document(prefs.getString('email'))
              .get()
              .then((snapshot) {
            setState(() {
              profile = snapshot.data['profile_picture'];
              fname = snapshot.data['First_name'];
              mname = snapshot.data['Middle_name'];
              lname = snapshot.data['Last_name'];
              email = snapshot.data['email'];
              mno = snapshot.data['ph_no'].toString();
              dob = snapshot.data['dob'];
              gender = snapshot.data['gender'];
              roll_no = snapshot.data['roll_no'];
              highest_qualification = snapshot.data['highest_qualification'];
              languages = snapshot.data['languages'] ?? {'' : 'Expert'};
              address = snapshot.data['Address'] ?? {};
              postal = address['postal_code'] ?? '';
              languages.forEach((key, value) {
                languagesList.add([key, value]);
            });
            });
          });
        } catch (e) {
          print(e.toString());
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
    if (width < 360)
      scale = 0.7;
    else
      scale = 1;
    return email == null
        ? Loading()
        : loading
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
                body: error
                    ? Center(
                        child: Text('Error occured, try again later'),
                      )
                    : ScrollConfiguration(
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
                                        : profile != null
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
                                  decoration: x("First Name"),
                                  onChanged: (text) {
                                    setState(() => fname = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'first name cannot be empty';
                                    else
                                      return null;
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
                                    onShowPicker:
                                        (context, currentValue) async {
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
                                            : Timestamp
                                                .fromMicrosecondsSinceEpoch(date
                                                    .microsecondsSinceEpoch);
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null)
                                        return 'DOB cannot be empty';
                                      else
                                        return null;
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
                                        initialValue: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        decoration: x("Gender"),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 5, 0),
                                          child: DropdownButton<String>(
                                            hint: Text("Gender"),
                                            value: gender ?? 'Male',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                            icon: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Icon(
                                                  Icons.keyboard_arrow_down),
                                            ),
                                            underline: SizedBox(),
                                            items: genders.map<DropdownMenuItem<String>>(
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
                                TextFormField(
                                  initialValue: roll_no ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Roll Number"),
                                  onChanged: (text) {
                                    setState(() => roll_no = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'roll number cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  initialValue: highest_qualification ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Highest Qualification"),
                                  onChanged: (text) {
                                    setState(() => highest_qualification = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'highest qualification cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ListTile(
                                  leading: Text(
                                    'Languages',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 0),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: languagesList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if(!temp.containsKey(index.toString()))
                                      temp[index.toString()] =
                                      new TextEditingController(
                                          text: languagesList[index][0]);
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: width *
                                                  0.3 *
                                                  scale,
                                              child:
                                              TextFormField(
                                                controller: temp[
                                                index.toString()],
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize:
                                                    12),
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(10 * scale),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                        borderSide: BorderSide(
                                                          color:
                                                          Colors.grey,
                                                        ))),
                                                onChanged:
                                                    (value) {
                                                  setState(() {
                                                    languagesList[index][0] = value;
                                                  });
                                                },
                                                validator:
                                                    (value) {
                                                  if (value
                                                      .isEmpty)
                                                    return 'cannot be empty';
                                                  else
                                                    return null;
                                                },
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  5),
                                              child: Container(
                                                color: Colors
                                                    .grey[300],
                                                padding: EdgeInsets
                                                    .fromLTRB(
                                                    10 *
                                                        scale,
                                                    0,
                                                    5 * scale,
                                                    0),
                                                child:
                                                DropdownButton<
                                                    String>(
                                                  value: languagesList[index][1] ==
                                                      null
                                                      ? 'Basic'
                                                      : languagesList[index][1]
                                                      .substring(0,
                                                      1)
                                                      .toUpperCase() +
                                                      languagesList[index][1]
                                                          .substring(1),
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500,
                                                      fontSize:
                                                      12),
                                                  icon: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0 *
                                                            scale),
                                                    child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down),
                                                  ),
                                                  underline:
                                                  SizedBox(),
                                                  items: <
                                                      String>[
                                                        'Starter',
                                                    'Basic',
                                                    'Intermediate',
                                                    'Expert'
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>((String
                                                  value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value:
                                                      value,
                                                      child: Text(
                                                          value),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (value) {
                                                    setState(
                                                            () {
                                                              languagesList[index][1] = value;
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets
                                                  .only(
                                                  right: 15 *
                                                      scale),
                                              child: IconButton(
                                                icon: Icon(Icons
                                                    .delete_outline),
                                                onPressed: () {
                                                  if (languagesList
                                                      .length ==
                                                      1) {
                                                  } else {
                                                    languagesList
                                                        .removeAt(
                                                        index);
                                                    for (int i =
                                                        index;
                                                    i < languagesList.length;
                                                    i++) {
                                                      temp[i.toString()]
                                                          .text = languagesList[
                                                      i][0];
                                                    }
                                                    temp.remove(index.toString());
                                                    setState(
                                                            () {});
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: width * 0.3 * scale,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                SimpleDialog(
                                                  title: Text(
                                                    'Add Language',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 15),
                                                  ),
                                                  children: <Widget>[
                                                    Container(
                                                      width: width *
                                                          0.35 *
                                                          scale,
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          20 *
                                                              scale,
                                                          20,
                                                          20 *
                                                              scale,
                                                          20),
                                                      child:
                                                      TextField(
                                                        autofocus:
                                                        true,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize:
                                                            12),
                                                        decoration: InputDecoration(
                                                            hintText: 'eg: French, Japanese',
                                                            contentPadding: EdgeInsets.all(10 * scale),
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: BorderSide(
                                                                  color:
                                                                  Colors.grey,
                                                                ))),
                                                        onChanged:
                                                            (value) {
                                                          setState(
                                                                  () {
                                                                newLanguage =
                                                                    value;
                                                              });
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <
                                                          Widget>[
                                                        FlatButton(
                                                          child: Text(
                                                            'CLOSE',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black),
                                                          ),
                                                          onPressed:
                                                              () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            'ADD',
                                                            style: TextStyle(
                                                                color:
                                                                basicColor),
                                                          ),
                                                          onPressed:
                                                              () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                            if(newLanguage != null)
                                                              setState(() {
                                                                languagesList.add([newLanguage, 'Basic']);
                                                                temp = {};
                                                              });
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                          );
                                        },
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: TextFormField(
                                            decoration:
                                            InputDecoration(
                                                hintText:
                                                'Add new language',
                                                hintStyle:
                                                TextStyle(
                                                    fontSize:
                                                    12),
                                                suffixIcon:
                                                Icon(Icons
                                                    .add),
                                                contentPadding:
                                                EdgeInsets
                                                    .all(10 *
                                                    scale),
                                                border:
                                                OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        5),
                                                    borderSide:
                                                    BorderSide(
                                                      color:
                                                      Colors.grey,
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          5),
                                      child: Container(
                                        color: Colors.grey[300],
                                        padding:
                                        EdgeInsets.fromLTRB(
                                            10 * scale,
                                            0,
                                            5 * scale,
                                            0),
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: DropdownButton<
                                              String>(
                                            value: 'Proficiency',
                                            style: TextStyle(
                                                color:
                                                Colors.black,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                fontSize: 13),
                                            icon: Padding(
                                              padding:
                                              EdgeInsets.only(
                                                  left: 10.0 *
                                                      scale),
                                              child: Icon(Icons
                                                  .keyboard_arrow_down),
                                            ),
                                            underline: SizedBox(),
                                            items: <String>[
                                              'Proficiency',
                                            ].map<
                                                DropdownMenuItem<
                                                    String>>((String
                                            value) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child:
                                                Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 15 * scale),
                                      child: IconButton(
                                        icon: Icon(
                                            Icons.delete_outline),
                                        onPressed: () {},
                                      ),
                                    )
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 0),
                                ),
                                TextFormField(
                                  initialValue: address['address'] ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Street"),
                                  onChanged: (text) {
                                    setState(() => address['address'] = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'street cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: address['country'] ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Country"),
                                  onChanged: (text) {
                                    setState(() => address['country'] = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'country cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: address['state'] ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("State"),
                                  onChanged: (text) {
                                    setState(() => address['state'] = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'state cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: postal ?? '',
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.numberWithOptions(),
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("Postal Code"),
                                  onChanged: (text) {
                                    setState(() => postal = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'postal code cannot be empty';
                                    else
                                      if(!(int.tryParse(value) != null))
                                        return 'invalid postal';
                                      else return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  initialValue: address['city'] ?? '',
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  obscureText: false,
                                  decoration: x("City"),
                                  onChanged: (text) {
                                    setState(() => address['city'] = text);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'city cannot be empty';
                                    else
                                      return null;
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
                                    side: BorderSide(
                                        color: basicColor, width: 1.5),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: basicColor),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      languages = {};
                                      for(int i = 0; i < languagesList.length; i++) {
                                        languages[languagesList[i][0]] = languagesList[i][1];
                                      }
                                      Map<String, dynamic> map = {};
                                      address['postal_code'] = int.parse(postal);
                                      map['Address'] = address;
                                      map['First_name'] = fname;
                                      map['Last_name'] = lname;
                                      map['Middle_name'] = mname;
                                      map['dob'] = dob;
                                      map['gender'] = gender;
                                      map['highest_qualification'] = highest_qualification;
                                      map['languages'] = languages;
                                      map['ph_no'] = mno;
                                      map['roll_no'] = roll_no;
                                      if (_image == null) {
                                        // TODO call API
                                        map['profile_picture'] = profile;
                                        dynamic result = await _APIService.sendProfileData(map);
                                        if(result == -1) {
                                          showToast('Failed', context);
                                        } else if(result == 0) {
                                          showToast('Failed', context);
                                        } else if(result == -2) {
                                          showToast('Could not connect to server', context);
                                        } else if(result == 1) {
                                          showToast('Data Updated Successfully', context);
                                          Navigator.pop(context);
                                        } else {
                                          showToast('Unexpected error occured', context);
                                        }
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        showToast(
                                            'Uploading profile picture\n might take some time',
                                            context, duration: 5);
                                        StorageReference storageReference;
                                        storageReference = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child("resumePictures/$email");
                                        StorageUploadTask uploadTask =
                                            storageReference.putFile(_image);
                                        final StorageTaskSnapshot downloadUrl =
                                            (await uploadTask.onComplete);
                                        await downloadUrl.ref
                                            .getDownloadURL()
                                            .then((url) async {
                                          setState(() {
                                            profile = url;
                                          });
                                          map['profile_picture'] = url;
                                          // TODO call API
                                          dynamic result = await _APIService.sendProfileData(map);
                                          if(result == -1) {
                                            showToast('Failed', context);
                                          } else if(result == 0) {
                                            showToast('Failed', context);
                                          } else if(result == -2) {
                                            showToast('Could not connect to server', context);
                                          } else if(result == 1) {
                                            showToast('Data Updated Successfully', context);
                                            Navigator.pop(context);
                                          } else {
                                            showToast('Unexpected error occured', context);
                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                          showToast('Data Updated Successfully',
                                              context);
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
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
