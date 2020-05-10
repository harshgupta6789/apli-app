import 'dart:io';
import 'package:apli/Services/APIService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

class NewProject extends StatefulWidget {
  List projects;
  int index;
  bool old;
  String email;
  NewProject({this.projects, this.index, this.old, this.email});
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  double width, height, scale;
  List projects;
  String email, certificate, Name, University_Company, fileName;
  List information;
  Timestamp from, to;
  int index;
  File file;
  bool loading = false;
  final format = DateFormat("MM-yyyy");
  final _formKey = GlobalKey<FormState>();
  StorageUploadTask uploadTask;
  final _APIService = APIService(type: 5);

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
    if (value.length < 80 || value.length > 110)
      return false;
    else
      return true;
  }

  @override
  void initState() {
    projects = widget.projects;
    index = widget.index;
    if (widget.old == false) {
      projects.add({});
    }
    certificate = projects[index]['certificate'];
    Name = projects[index]['Name'] ?? '';
    University_Company = projects[index]['University_Company'] ?? '';
    information = projects[index]['information'] ?? ['', '', ''];
    from = projects[index]['from'] ?? Timestamp.now();
    to = projects[index]['to'] ?? Timestamp.now();
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
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: basicColor,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Projects',
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
                          initialValue: Name,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Project Title"),
                          onChanged: (text) {
                            setState(() => Name = text);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'project title cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          initialValue: University_Company,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          obscureText: false,
                          decoration: x("Company/University"),
                          onChanged: (text) {
                            setState(() => University_Company = text);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'company/university name cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: width * 0.4,
                              child: DateTimeField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'cannot be empty';
                                    }
                                    return null;
                                  },
                                  format: format,
                                  initialValue: from == null
                                      ? null
                                      : DateTime.fromMicrosecondsSinceEpoch(
                                          from.microsecondsSinceEpoch),
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    var temp = from != null
                                        ? format
                                                .format(DateTime
                                                    .fromMicrosecondsSinceEpoch(
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
                                          : Timestamp
                                              .fromMicrosecondsSinceEpoch(
                                                  date.microsecondsSinceEpoch);
                                    });
                                  },
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  decoration: x("From")),
                            ),
                            Container(
                              width: width * 0.4,
                              child: DateTimeField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'cannot be empty';
                                    }
                                    return null;
                                  },
                                  format: format,
                                  initialValue: to == null
                                      ? null
                                      : DateTime.fromMicrosecondsSinceEpoch(
                                          to.microsecondsSinceEpoch),
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    var temp = to != null
                                        ? format
                                                .format(DateTime
                                                    .fromMicrosecondsSinceEpoch(
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
                                          : Timestamp
                                              .fromMicrosecondsSinceEpoch(
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
                                      width: width * 0.15 * scale,
                                      child: AutoSizeText(
                                        fileName ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Visibility(
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
                                        padding: EdgeInsets.all(0),
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
                          initialValue: information[0],
                          onChanged: (text) {
                            setState(() => information[0] = text);
                          },
                        ),
                        Text(
                          'Character count: ${information[0].length}',
                          style: TextStyle(
                              fontSize: 11,
                              color: (information[0].length < 80 ||
                                      information[0].length > 110)
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
                          initialValue: information[1],
                          onChanged: (text) {
                            setState(() => information[1] = text);
                          },
                        ),
                        Text(
                          'Character count: ${information[1].length}',
                          style: TextStyle(
                              fontSize: 11,
                              color: (information[1].length < 80 ||
                                      information[1].length > 110)
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
                                    side: BorderSide(
                                        color: basicColor, width: 1.2),
                                  ),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: basicColor),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) if (validateBulletPoint(
                                        information[
                                            0])) if (validateBulletPoint(
                                        information[1])) {
                                      setState(() {
                                        loading = true;
                                      });
                                      Map<String, dynamic> map = {};
                                      projects[index] = {
                                        'Name': Name,
                                        'University_Company':
                                            University_Company,
                                        'from': from,
                                        'to': to,
                                        'certificate': certificate,
                                        'bullet_point1': information[0],
                                        'bullet_point2': information[1]
                                      };
                                      map['projects'] = projects;
                                      print(map);
                                      if (file == null) {
                                        // TODO call API
                                        dynamic result =
                                            await _APIService.sendProfileData(
                                                map);
                                        if (result == -1) {
                                          showToast('Failed', context);
                                        } else if (result == 0) {
                                          showToast('Failed', context);
                                        } else if (result == -2) {
                                          showToast(
                                              'Could not connect to server',
                                              context);
                                        } else if (result == 1) {
                                          showToast('Data Updated Successfully',
                                              context);
                                          Navigator.pop(context);
                                        } else {
                                          showToast('Unexpected error occured',
                                              context);
                                        }
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        _uploadFile(file, fileName).then((f) {
                                          // TODO call API
                                          showToast('Data updated successfully',
                                              context);
                                          Navigator.pop(context);
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
