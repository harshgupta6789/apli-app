import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/functions.dart';
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
  String email, type, certificate, company, designation, domain, industry, fileName;
  List information;
  Timestamp from, to;
  int index;
  File file;
  bool loading = false;
  final format = DateFormat("MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  StorageUploadTask uploadTask;

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("documents/$filename");
    uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    await downloadUrl.ref.getDownloadURL().then((url) {
      if (url != null) {
        setState(() {
          certificate = url;
        });
      } else if (url == null) {}
    });
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );
      if (file != null) {
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
      } else {}
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
  
  validateBulletPoint(String value) {
    if(value.length < 80 || value.length > 110)
      return false;
    else return true;
  }

  @override
  void initState() {
    experiences = widget.experiences;
    index = widget.index;
    if(widget.old == false) {
      experiences.add({});
    }
    type = experiences[index]['Type'] ?? 'Internship';
    certificate = experiences[index]['certificate'];
    company = experiences[index]['company'] ?? '';
    designation = experiences[index]['designation'] ?? '';
    domain = experiences[index]['domain'] ?? 'Software';
    industry = experiences[index]['industry'] ?? 'Financial';
    information = experiences[index]['information'] ?? ['', '', ''];
    from = experiences[index]['from'] ?? null;
    to = experiences[index]['to'] ?? null;
    getInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if(width < 360)
      scale = 0.7;
    else scale = 1;
    return loading || email == null ? Loading() : Scaffold(
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
                    left: width * 0.08 * scale, top: 20, right: width * 0.08 * scale),
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
                            initialValue: '',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Experience Type"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10 * scale, 0, 5 * scale, 0),
                              child: DropdownButton<String>(
                                hint: Text("Experience Type"),
                                value: (type.substring(0, 1)).toUpperCase() + type.substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 10.0 * scale),
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
                                    type = value;
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
                      initialValue: company,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: x("Company"),
                      onChanged: (text) {
                        setState(() => company = text);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'companycannot be empty';
                        }
                        return null;
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
                              initialValue: from == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                  from.microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var temp = from != null
                                    ? format
                                    .format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        from.microsecondsSinceEpoch))
                                    .toString() ??
                                    "DOB"
                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  from = (date == null)
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
                              initialValue: to == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                  to.microsecondsSinceEpoch),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                var temp = to != null
                                    ? format
                                    .format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        to.microsecondsSinceEpoch))
                                    .toString() ??
                                    "DOB"
                                    : "DOB";
                                return date;
                              },
                              onChanged: (date) {
                                setState(() {
                                  to = (date == null)
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
                      initialValue: designation,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: x("Designation"),
                      onChanged: (text) {
                        setState(() => designation = text);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'designation name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            enabled: false,
                            initialValue: '',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Industry Type"),
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
                                value: industry.substring(0, 1).toUpperCase() + industry.substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 10.0 * scale),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Other', 'Financial']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    industry = value;
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
                            initialValue: '',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: x("Domain"),
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
                                value: domain.substring(0, 1).toUpperCase() + domain.substring(1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 10.0 * scale),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ),
                                underline: SizedBox(),
                                items: <String>['Male', 'Female', 'Other', 'Software']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    domain = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xff4285f4)
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              "Certificate : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.2 * scale,
                            child: Stack(
                              children: <Widget>[
                                Align(alignment: Alignment.bottomLeft,child: AutoSizeText(fileName ?? '', overflow: TextOverflow.ellipsis,
                                  maxLines: 1,)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Visibility(
                                    visible: file != null,
                                    child: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          file = null;
                                          fileName = null;
                                          certificate = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: MaterialButton(
                              onPressed: () {
                                filePicker(context);
                              },
                              child: Text("Browse"),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
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
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
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
                      initialValue: information[0],
                      onChanged: (text) {
                        setState(() => experiences[index]['information'][0] = text);
                      },
                    ),
                    Text('Character count: ${information[0].length}', style: TextStyle(fontSize: 11,color: (information[0].length < 80 || information[0].length > 110) ? Colors.red : Colors.green),),
                    SizedBox(height: 15),
                    Text(
                      "Bullet Point 2",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
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
                      initialValue: information[1],
                      onChanged: (text) {
                        setState(() => information[1] = text);
                      },
                    ),
                    Text('Character count: ${information[1].length}', style: TextStyle(fontSize: 11,color: (information[1].length < 80 || information[1].length > 110) ? Colors.red : Colors.green),),
                    SizedBox(height: 15),
                    Text(
                      "Bullet Point 3",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
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
                      initialValue: information[2],
                      obscureText: false,
                      onChanged: (text) {
                        setState(() => information[2] = text);
                      },
                    ),
                    Text('Character count: ${information[2].length}', style: TextStyle(fontSize: 11,color: (information[2].length < 80 || information[2].length > 110) ? Colors.red : Colors.green),),
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
                                Navigator.pop(context);
//                                experiences.removeAt(index);
//                                await SharedPreferences.getInstance()
//                                    .then((prefs) async {
//                                  await Firestore.instance
//                                      .collection('candidates')
//                                      .document(
//                                      prefs.getString('email'))
//                                      .setData({
//                                    'experience': experiences
//                                  }, merge: true).then((f) {
//                                    Navigator.pop(context);
//                                  });
//                                });
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
                                if(_formKey.currentState.validate())
                                  if(validateBulletPoint(information[0]))
                                    if(validateBulletPoint(information[1]))
                                      if(validateBulletPoint(information[2]))
                                        Navigator.pop(context);
//                                  setState(() {
//                                    loading = true;
//                                  });
//                                  experiences[index]['Type'] = type;
//                                  experiences[index]['company'] = company;
//                                  experiences[index]['designation'] = designation;
//                                  experiences[index]['domain'] = domain;
//                                  experiences[index]['from'] = from;
//                                  experiences[index]['industry'] = industry;
//                                  experiences[index]['information'] = information;
//                                  experiences[index]['to'] = to;
//                                  if(file == null) {
//                                    // TODO call API
//                                    Navigator.pop(context);
//                                  } else {
//                                    _uploadFile(file, fileName).then((t) {
//                                      experiences[index]['certificate'] = certificate;
//                                      // TODO call API
//                                      Navigator.pop(context);
//                                    });
//                                  }
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
