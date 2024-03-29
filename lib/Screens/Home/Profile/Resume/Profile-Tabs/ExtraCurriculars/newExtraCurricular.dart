import 'dart:io';

import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/ExtraCurriculars/extraCurricular.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class NewExtraCurricular extends StatefulWidget {
  List extraCurriculars;
  int index;
  bool old;
  String email;
  NewExtraCurricular({this.extraCurriculars, this.index, this.old, this.email});
  @override
  _NewExtraCurricularState createState() => _NewExtraCurricularState();
}

class _NewExtraCurricularState extends State<NewExtraCurricular> {
  double width, height, scale;
  List extraCurriculars;
  String email, certificate, role, organisation, fileName;
  List info;
  Timestamp start, end;
  int index;
  File file;
  bool loading = false;
  final format = DateFormat("MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  final apiService = APIService(profileType: 4);
  StorageUploadTask uploadTask;

  Future<void> _uploadFile(File file, String filename) async {
    await SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("documents/${value.getString('email')}/$filename");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      await downloadUrl.ref.getDownloadURL().then((url) {
        if (url != null) {
          setState(() {
            certificate = url;
          });
        } else if (url == null) {}
      });
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
    if (value.length < 80 || value.length > 110)
      return false;
    else
      return true;
  }

  @override
  void initState() {
    extraCurriculars = widget.extraCurriculars;
    index = widget.index;
    if (widget.old == false) {
      extraCurriculars.add({});
    }
    certificate = extraCurriculars[index]['certificate'];
    role = extraCurriculars[index]['role'] ?? '';
    organisation = extraCurriculars[index]['organisation'] ?? '';
    info = extraCurriculars[index]['info'] ?? ['', ''];
    start = extraCurriculars[index]['start'] ?? Timestamp.now();
    end = extraCurriculars[index]['end'] ?? Timestamp.now();
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width < 360)
      scale = 0.7;
    else
      scale = 1;
    return loading || email == null
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: basicColor,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    extra,
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
                        left: width * 0.08 * scale,
                        top: 20,
                        right: width * 0.08 * scale),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30),
                        SizedBox(height: 15.0),
                        TextFormField(
                          initialValue: role,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Role"),
                          onChanged: (text) {
                            setState(() => role = text);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'role cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          initialValue: organisation,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Organisation/Committee"),
                          onChanged: (text) {
                            setState(() => organisation = text);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'organisation/committee name cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DateTimeField(
                            validator: (value) {
                              if (value == null)
                                return 'cannot be empty';
                              else
                                return null;
                            },
                            format: format,
                            initialValue: start == null
                                ? null
                                : DateTime.fromMicrosecondsSinceEpoch(
                                    start.microsecondsSinceEpoch),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
//                              var temp = start != null
//                                  ? format
//                                          .format(DateTime
//                                              .fromMicrosecondsSinceEpoch(
//                                                  start.microsecondsSinceEpoch))
//                                          .toString() ??
//                                      "DOB"
//                                  : "DOB";
                              return date;
                            },
                            onChanged: (date) {
                              setState(() {
                                start = (date == null)
                                    ? null
                                    : Timestamp.fromMicrosecondsSinceEpoch(
                                        date.microsecondsSinceEpoch);
                              });
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: x("From")),
                        SizedBox(
                          height: 15,
                        ),
                        DateTimeField(
                            validator: (value) {
                              if (value == null)
                                return 'cannot be empty';
                              else
                                return null;
                            },
                            format: format,
                            initialValue: end == null
                                ? null
                                : DateTime.fromMicrosecondsSinceEpoch(
                                    end.microsecondsSinceEpoch),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
//                              var temp = end != null
//                                  ? format
//                                          .format(DateTime
//                                              .fromMicrosecondsSinceEpoch(
//                                                  end.microsecondsSinceEpoch))
//                                          .toString() ??
//                                      "DOB"
//                                  : "DOB";
                              return date;
                            },
                            onChanged: (date) {
                              setState(() {
                                end = (date == null)
                                    ? null
                                    : Timestamp.fromMicrosecondsSinceEpoch(
                                        date.microsecondsSinceEpoch);
                              });
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: x("To")),
                        SizedBox(height: 15.0),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(0xff4285f4))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "Certificate : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.3 * scale,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: width * 0.3 * scale,
                                      child: AutoSizeText(
                                        fileName ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (file == null) {
                                      filePicker(context);
                                    } else {
                                      setState(() {
                                        file = null;
                                        fileName = null;
                                        certificate = null;
                                      });
                                    }
                                  },
                                  child:
                                      Text(file == null ? "Browse" : "Remove"),
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
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Only 80 to 110 characters are allowed for each bullet point.",
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Bullet Point 1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                          decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ))),
                          initialValue: info[0],
                          onChanged: (text) {
                            setState(() => info[0] = text);
                          },
                        ),
                        Text(
                          'Character count: ${info[0].length}',
                          style: TextStyle(
                              fontSize: 11,
                              color:
                                  (info[0].length < 80 || info[0].length > 110)
                                      ? Colors.red
                                      : Colors.green),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Bullet Point 2",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                          decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ))),
                          initialValue: info[1],
                          onChanged: (text) {
                            setState(() => info[1] = text);
                          },
                        ),
                        Text(
                          'Character count: ${info[1].length}',
                          style: TextStyle(
                              fontSize: 11,
                              color:
                                  (info[1].length < 80 || info[1].length > 110)
                                      ? Colors.red
                                      : Colors.green),
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
                                    side: BorderSide(
                                        color: basicColor, width: 1.2),
                                  ),
                                  child: Text(
                                    widget.old == false ? 'Cancel' : 'Delete',
                                    style: TextStyle(color: basicColor),
                                  ),
                                  onPressed: () async {
                                    if (widget.old == false)
                                      Navigator.pop(context);
                                    else {
                                      setState(() {
                                        loading = true;
                                      });
                                      Map<String, dynamic> map = {};
                                      map['extra_curricular'] =
                                          List.from(extraCurriculars);
                                      map['index'] = index;

                                      dynamic result =
                                          await apiService.sendProfileData(map);
                                      if (result == 1) {
                                        showToast('Data Updated Successfully',
                                            context);
                                      } else {
                                        showToast('Unexpected error occured',
                                            context);
                                      }
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExtraCurricular()));
                                    }
                                  }),
                              RaisedButton(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  padding: EdgeInsets.only(left: 22, right: 22),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: basicColor, width: 1.2),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: basicColor),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) if (validateBulletPoint(
                                        info[
                                            0])) if (validateBulletPoint(
                                        info[1])) {
                                      setState(() {
                                        loading = true;
                                      });
                                      if (file == null) {
                                        extraCurriculars[index]['role'] = role;
                                        extraCurriculars[index]
                                            ['organisation'] = organisation;
                                        extraCurriculars[index]['start'] =
                                            start;
                                        extraCurriculars[index]['end'] = end;
                                        extraCurriculars[index]['certificate'] =
                                            certificate;
                                        extraCurriculars[index]['info'] = info;
                                        Map<String, dynamic> map = {};
                                        map['extra_curricular'] =
                                            List.from(extraCurriculars);
                                        map['index'] = -1;
                                        dynamic result = await apiService
                                            .sendProfileData(map);
                                        if (result == 1) {
                                          showToast('Data Updated Successfully',
                                              context);
                                        } else {
                                          showToast('Unexpected error occured',
                                              context);
                                        }
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ExtraCurricular()));
                                      } else {
                                        showToast(
                                            'Uploading certificate will take some time',
                                            context);
                                        _uploadFile(file, fileName)
                                            .then((f) async {
                                          extraCurriculars[index]['role'] =
                                              role;
                                          extraCurriculars[index]
                                              ['organisation'] = organisation;
                                          extraCurriculars[index]['start'] =
                                              start;
                                          extraCurriculars[index]['end'] = end;
                                          extraCurriculars[index]
                                              ['certificate'] = certificate;
                                          extraCurriculars[index]['info'] =
                                              info;
                                          Map<String, dynamic> map = {};
                                          map['extra_curricular'] =
                                              List.from(extraCurriculars);
                                          map['index'] = -1;
                                          dynamic result = await apiService
                                              .sendProfileData(map);
                                          if (result == 1) {
                                            showToast(
                                                'Data Updated Successfully',
                                                context);
                                          } else {
                                            showToast(
                                                'Unexpected error occured',
                                                context);
                                          }
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExtraCurricular()));
                                        });
                                      }
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
