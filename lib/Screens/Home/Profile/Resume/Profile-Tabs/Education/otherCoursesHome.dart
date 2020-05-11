import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Education/otherCourses.dart';
import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Experience/newExperience.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherCoursesHome extends StatefulWidget {
  final Map education;
  final String courseEdu;
  final List allFiles;

  const OtherCoursesHome(
      {Key key, this.education, this.courseEdu, this.allFiles})
      : super(key: key);
  @override
  _OtherCoursesHomeState createState() => _OtherCoursesHomeState();
}

class _OtherCoursesHomeState extends State<OtherCoursesHome> {
  double width, height;
  bool loading = false;
  Map temp = {};
  List otherCourses = [];
  List nameOfOtherCourses = [];

  void init() {
    setState(() {
      temp = widget.education;
      temp.remove("X");
      temp.remove("XII");
      temp.remove(widget.courseEdu);
      print(temp.keys.toList());
      nameOfOtherCourses = temp.keys.toList();
      temp.forEach((k, v) {
        otherCourses.add(v);
      });
      print(otherCourses);
    });
  }

  final _APIService = APIService(type: 7);

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          padding: EdgeInsets.fromLTRB(width * 0.05, 30, width * 0.05, 0),
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
                                      otherCourses : otherCourses,
                                      nameofOtherCourses: nameOfOtherCourses,
                                      index: otherCourses.length,
                                      allFiles: widget.allFiles,
                                    )));
                      },
                      child: ListTile(
                        leading: Text(
                          'Add New Other Course',
                          style: TextStyle(
                              color: basicColor, fontWeight: FontWeight.w600),
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
                        String from = otherCourses[index]['start'] == null
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
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.all(8),
                                  child: ListTile(
                                    title: Text(
                                      otherCourses[index]['institute'] ??
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
                                        Text('specialization: ' +
                                            (otherCourses[index]
                                                    ['specialization'] ??
                                                '')),
                                        Text('board: ' +
                                            (otherCourses[index]['board'] ??
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
                                    contentPadding: EdgeInsets.only(left: 8),
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
                                                  builder: (context) => Other(
                                                        courseEdu:
                                                            widget.courseEdu,
                                                        oth: widget.education,
                                                      )));
                                        } else if (result == 1) {
                                          // setState(() {
                                          //   loading = true;
                                          // });
                                          // Map<String, dynamic> map = {};
                                          // map['experience'] =
                                          //     List.from(otherCourses);
                                          // map['index'] = index;
                                          // // TODO call API
                                          // dynamic result =
                                          //     await _APIService.sendProfileData(
                                          //         map);
                                          // if (result == 1) {
                                          //   showToast(
                                          //       'Data Updated Successfully',
                                          //       context);
                                          // } else {
                                          //   showToast(
                                          //       'Unexpected error occured',
                                          //       context);
                                          // }
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OtherCoursesHome()));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<int>>[
                                        const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          ),
                                        ),
                                        const PopupMenuItem<int>(
                                          value: 1,
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
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
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
