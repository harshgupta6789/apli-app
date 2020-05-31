import 'dart:async';

import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCourses.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherCoursesHome extends StatefulWidget {
  final Map education;
  final String courseEdu, type;
  final List allFiles;

  const OtherCoursesHome(
      {Key key, this.education, this.courseEdu, this.allFiles, this.type})
      : super(key: key);
  @override
  _OtherCoursesHomeState createState() => _OtherCoursesHomeState();
}

class _OtherCoursesHomeState extends State<OtherCoursesHome> {
  double width, height;
  bool loading = false;
  Map temp = {}, x, xii, current;
  List otherCourses = [];
  List nameOfOtherCourses = [], allFiles;
  StorageUploadTask uploadTask;

  Future<List> upload() async {
    List temp = [[], null, null, []];
    for (int i = 0; i < allFiles.length; i++) {
      if (i == 0) {
        for (int j = 0; j < allFiles[0].length; j++) {
          temp[0].add(null);
        }
      } else if (i == 3) {
        for (int j = 0; j < allFiles[3].length; j++) {
          temp[3].add(null);
        }
      }
    }
    try {
      await SharedPreferences.getInstance().then((value) async {
        for (int i = 0; i < allFiles.length; i++) {
          if (i == 0)
            for (int j = 0; j < allFiles[0].length; j++) {
              if (allFiles[0][j] != null) {
                final StorageReference storageReference = FirebaseStorage()
                    .ref()
                    .child(
                        "documents/${value.getString("email")}/sem$j${DateTime.now()}");

                final StorageUploadTask uploadTask =
                    storageReference.putFile(allFiles[0][j]);

                final StreamSubscription<StorageTaskEvent> streamSubscription =
                    uploadTask.events.listen((event) {});
                await uploadTask.onComplete;
                streamSubscription.cancel();

                String imageUrl = await storageReference.getDownloadURL();
                temp[0][j] = imageUrl;
              } else
                temp[0][j] = null;
            }
          else if (i == 1) {
            if (allFiles[1] != null) {
              final StorageReference storageReference = FirebaseStorage()
                  .ref()
                  .child(
                      "documents/${value.getString("email")}/TwelfthOrDiploma${DateTime.now()}");

              final StorageUploadTask uploadTask =
                  storageReference.putFile(allFiles[1]);

              final StreamSubscription<StorageTaskEvent> streamSubscription =
                  uploadTask.events.listen((event) {});
              await uploadTask.onComplete;
              streamSubscription.cancel();

              String imageUrl = await storageReference.getDownloadURL();
              temp[1] = imageUrl;
            } else
              temp[1] = null;
          } else if (i == 2) {
            if (allFiles[2] != null) {
              final StorageReference storageReference = FirebaseStorage()
                  .ref()
                  .child(
                      "documents/${value.getString("email")}/Tenth${DateTime.now()}");

              final StorageUploadTask uploadTask =
                  storageReference.putFile(allFiles[2]);

              final StreamSubscription<StorageTaskEvent> streamSubscription =
                  uploadTask.events.listen((event) {});
              await uploadTask.onComplete;
              streamSubscription.cancel();

              String imageUrl = await storageReference.getDownloadURL();
              temp[2] = imageUrl;
            } else
              temp[2] = null;
          } else if (i == 3)
            for (int j = 0; j < allFiles[3].length; j++) {
              if (allFiles[3][j] != null) {
                final StorageReference storageReference = FirebaseStorage()
                    .ref()
                    .child(
                        "documents/${value.getString("email")}/OtherEducation$j${DateTime.now()}");

                final StorageUploadTask uploadTask =
                    storageReference.putFile(allFiles[3][j]);

                final StreamSubscription<StorageTaskEvent> streamSubscription =
                    uploadTask.events.listen((event) {});
                await uploadTask.onComplete;
                streamSubscription.cancel();

                String imageUrl = await storageReference.getDownloadURL();
                temp[3][j] = imageUrl;
              } else
                temp[3][j] = null;
            }
        }
      });
    } catch (e) {}
    return temp;
  }

  void init() {
    setState(() {
      temp = widget.education;
      allFiles = widget.allFiles;
      x = temp['X'];
      xii = temp[widget.type];
      current = temp[widget.courseEdu];
      temp.remove("X");
      temp.remove(widget.type);
      temp.remove(widget.courseEdu);
      temp.remove('current_education');
      print(temp);
      nameOfOtherCourses = temp.keys.toList() == null ? [] : temp.keys.toList();
      print(nameOfOtherCourses);
      temp.forEach((k, v) {
        otherCourses.add(v);
      });
      temp['X'] = x;
      temp[widget.type] = xii;
      temp[widget.courseEdu] = current;
      temp['current_education'] = widget.courseEdu;
    });
  }

  final apiService = APIService(profileType: 7);

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              _onWillPop();
              return;
            },
            child: Scaffold(
               backgroundColor: Theme.of(context).backgroundColor,
                appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: basicColor,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Other Courses",
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
                body: Container(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.05, 30, width * 0.05, 0),
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: basicColor, width: 1.5),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Other(
                                              old: false,
                                              oth: widget.education,
                                              otherCourses: otherCourses,
                                              nameofOtherCourses:
                                                  nameOfOtherCourses,
                                              index: otherCourses.length,
                                              allFiles: widget.allFiles,
                                              courseEdu: widget.courseEdu,
                                              type: widget.type,
                                            )));
                              },
                              child: ListTile(
                                leading: Text(
                                  'Add New Other Course',
                                  style: TextStyle(
                                      color: basicColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: Icon(
                                  Icons.add,
                                  color: basicColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: otherCourses.length,
                              itemBuilder: (BuildContext context1, int index) {
                                String from =
                                    otherCourses[index]['start'] == null
                                        ? null
                                        : DateTime.fromMicrosecondsSinceEpoch(
                                                    otherCourses[index]['start']
                                                        .microsecondsSinceEpoch)
                                                .month
                                                .toString() +
                                            '-' +
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                    otherCourses[index]['start']
                                                        .microsecondsSinceEpoch)
                                                .year
                                                .toString();
                                String to = otherCourses[index]['end'] == null
                                    ? null
                                    : DateTime.fromMicrosecondsSinceEpoch(
                                                otherCourses[index]['end']
                                                    .microsecondsSinceEpoch)
                                            .month
                                            .toString() +
                                        '-' +
                                        DateTime.fromMicrosecondsSinceEpoch(
                                                otherCourses[index]['end']
                                                    .microsecondsSinceEpoch)
                                            .year
                                            .toString();
                                String duration = (from ?? '') +
                                    ' to ' +
                                    ((from != null && to == null)
                                        ? 'ongoing'
                                        : to ?? '');

                                return Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          padding: EdgeInsets.all(8),
                                          child: ListTile(
                                            title: Text(
                                              otherCourses[index]
                                                      ['institute'] ??
                                                  'Designation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text('Score: ' +
                                                    ((otherCourses[index]
                                                                ['score'] ??
                                                            '') +
                                                        (otherCourses[index][
                                                                'score_unit'] ??
                                                            '%'))),
                                                Text('Board: ' +
                                                    (otherCourses[index]
                                                            ['board'] ??
                                                        '')),
                                                Text('Duration: ' + duration),
                                                // Text('Industry Type: ' +
                                                //     (otherCourses[index]['industry'] ??
                                                //         '')),
                                                // Text('Domain: ' +
                                                //     (otherCourses[index]['domain'] ??
                                                //         '')),
                                              ],
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 8),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: PopupMenuButton<int>(
                                              icon: Icon(Icons.more_vert),
                                              onSelected: (int result) async {
                                                if (result == 0) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Other(
                                                                old: true,
                                                                oth: widget
                                                                    .education,
                                                                otherCourses:
                                                                    otherCourses,
                                                                nameofOtherCourses:
                                                                    nameOfOtherCourses,
                                                                index: index,
                                                                allFiles: widget
                                                                    .allFiles,
                                                                courseEdu: widget
                                                                    .courseEdu,
                                                                type:
                                                                    widget.type,
                                                              )));
                                                } else if (result == 1) {
                                                  setState(() {
                                                    temp.remove(
                                                        nameOfOtherCourses[
                                                            index]);
                                                    print(temp.keys);
                                                    nameOfOtherCourses
                                                        .removeAt(index);
                                                    otherCourses
                                                        .removeAt(index);
                                                    allFiles[3].removeAt(index);
                                                  });
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<int>>[
                                                const PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                const PopupMenuItem<int>(
                                                  value: 1,
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              },
                            ),
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
                                showToast(
                                    "Uploading..Might Take Some time", context);
                                print(temp.keys);
                                for (int i = 0;
                                    i < nameOfOtherCourses.length;
                                    i++) {
                                  String formattedTo, formattedFrom;
                                  formattedFrom = apiDateFormat.format(
                                      temp[nameOfOtherCourses[i]]['start']
                                          .toDate());
                                  formattedFrom =
                                      formattedFrom + " 00:00:00+0000";
                                  formattedTo = apiDateFormat.format(
                                      temp[nameOfOtherCourses[i]]['end']
                                          .toDate());
                                  formattedTo = formattedTo + " 00:00:00+0000";
                                  Map temp1 = temp[nameOfOtherCourses[i]];
                                  temp1['start'] = formattedFrom;
                                  temp[nameOfOtherCourses[i]] = temp1;
                                  Map temp2 = temp[nameOfOtherCourses[i]];
                                  temp1['end'] = formattedTo;
                                  temp[nameOfOtherCourses[i]] = temp2;
                                }

                                List temp2 = await upload();
                                for (int i = 0; i < allFiles.length; i++) {
                                  if (i == 0) {
                                    for (int j = 0;
                                        j < allFiles[0].length;
                                        j++) {
                                      if (allFiles[0][j] != null) {
                                        temp[widget.courseEdu]['sem_records'][j]
                                            ['certificate'] = temp2[0][j];
                                      }
                                    }
                                  } else if (i == 1) {
                                    if (allFiles[i] != null) {
                                      temp['XII']['certificate'] = temp2[i];
                                    }
                                  } else if (i == 2) {
                                    if (allFiles[i] != null) {
                                      temp['X']['certificate'] = temp2[i];
                                    }
                                  } else if (i == 3) {
                                    for (int j = 0;
                                        j < allFiles[3].length;
                                        j++) {
                                      if (allFiles[3][j] != null) {
                                        temp[nameOfOtherCourses[j]]
                                            ['certificate'] = temp2[3][j];
                                      }
                                    }
                                  }
                                }
                                print(temp.keys);
                                dynamic result =
                                    await apiService.sendProfileData(temp);
                                if (result == -1) {
                                  showToast('Failed', context);
                                } else if (result == 0) {
                                  showToast('Failed', context);
                                } else if (result == -2) {
                                  showToast(
                                      'Could not connect to server', context);
                                } else if (result == 1) {
                                  showToast(
                                      'Data Updated Successfully', context);
                                } else {
                                  showToast(
                                      'Unexpected error occured', context);
                                }
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Leaving the form midway will not save your data! You will have to fill the form again from start. Are you sure you want to go back?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
