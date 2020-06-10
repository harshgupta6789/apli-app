import 'package:apli/Screens/Home/Courses/courses.dart';
import 'package:apli/Screens/Home/Courses/coursesLive.dart';
import 'package:apli/Screens/Home/Courses/multiLive.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

double height, width;
bool didfilter = false;
Orientation orientation;
Map globalCoursesChecked;
Map globalWebinarChecked;

class _CourseMainState extends State<CourseMain> {
  // COURSE SCREEN AGAIN USES STREAMBUILDER TO FETCH COURSES FROM FIREBASE COLLECTION NAMED edu_courses //
  // THE TEMP AND OTHER VARIABLES ARE USED FOR FILTERING THE COURSES //
  // COURSES ARE FILTERED BY TAGS ( COURSE AND WEBINAR ) AND BY TYPES LIKE MARKETING , TECH ETC //
  String college;
  bool loading = false;

  getInfo() async {
    await SharedPreferences.getInstance().then((value) async {
      if (!value.containsKey('college')) {
        await Firestore.instance
            .collection('candidates')
            .document(value.getString('email'))
            .get()
            .then((candidates) async {
          await Firestore.instance
              .collection('batches')
              .where('batch_id', isEqualTo: candidates.data['batch_id'])
              .getDocuments()
              .then((batches) {
            setState(() {
              college = batches.documents.first.data['college'];
            });
            value.setString('college', batches.documents.first.data['college']);
          });
        });
      } else
        setState(() {
          college = value.getString('college');
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getInfo();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List temp = [];
  List filtered = [];

  // Map allFilter = {'Course': [], 'Webinar': []};
  List allFilter = ['Courses', 'Webinar'];
  Map coursesChecked = {};
  Map webinarChecked = {};

  void filterStuff(Map course, Map webinar) {
    // IN THIS WE PASS TWO ARGS CALLED COURSE AND WBINAR , WHICH HAVE KEYS AS THE TYPE NAME AND VALUE EITHER TRUE OR FALSE //
    // DEPENDING UPON THE TRUE FALSE VALUE AND THE TYPE AND TAG OF EACH COURSE THE FILTERING LOGIC BELOW IS CONSTRUCTED //
    // THIS METHOD IS CALLED ONCE USER DISMISSES THE FILTER DIALOG AS YOU CAN SEE BELOW //

    filtered = [];
    globalCoursesChecked = {};
    globalWebinarChecked = {};
    for (var eachCourse in temp) {
      if (eachCourse['tag'] == 'Course') {
        List allTypes = eachCourse['type'];
        course.forEach((key, value) {
          globalCoursesChecked[key] = value;
          if (value == true) {
            if (allTypes.contains(key)) {
              if (!filtered.contains(eachCourse)) {
                filtered.add(eachCourse);
              }
            }
          }
        });
      } else {
        List allTypes = eachCourse['type'];
        webinar.forEach((key, value) {
          globalWebinarChecked[key] = value;
          if (value == true) {
            if (allTypes.contains(key)) {
              if (!filtered.contains(eachCourse)) {
                filtered.add(eachCourse);
              }
            }
          }
        });
      }
    }
    setState(() {
      didfilter = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(college);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    return college == null
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            drawer: customDrawer(context, _scaffoldKey),
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: basicColor,
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IconButton(
                        icon: Icon(
                          EvaIcons.funnelOutline,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          dynamic x = await showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return MyDialogContent(
                                  courses: coursesChecked,
                                  webinars: webinarChecked,
                                  allFilters: allFilter,
                                );
                              });
                          if (x != null) {
                            if (x == -1) {
                              setState(() {
                                didfilter = false;
                                globalWebinarChecked = null;
                                globalCoursesChecked = null;
                              });
                            } else
                              filterStuff(x[0], x[1]);
                          }

                          // if (list != null) {
                          //   if (list[1] == 'Company') {
                          //     filterStuff(list[0], null, null, null);
                          //   } else if (list[1] == 'Location') {
                          //     filterStuff(null, null, list[0], null);
                          //   } else if (list[1] == 'Type') {
                          //     filterStuff(null, list[0], null, null);
                          //   } else if (list[1] == 'Bookmarked') {
                          //     filterStuff(null, null, null, list[0]);
                          //   }
                          // } else {
                          //   setState(() {});
                          // }
                        }),
                  ),
                ],
                leading: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IconButton(
                        icon: Icon(
                          EvaIcons.menuOutline,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState.openDrawer())),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(courses,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              preferredSize: Size.fromHeight(50),
            ),
            body: StreamBuilder(
                stream:
                    Firestore.instance.collection('edu_courses').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List x = snapshot.data.documents;
                    temp = [];
                    x.forEach((element) {
                      if (element['colleges'] == null)
                        temp.add(element);
                      else {
                        if (element['colleges'].contains(college))
                          temp.add(element);
                      }
                    });
                    coursesChecked = {};
                    webinarChecked = {};

                    temp.forEach((element) {
                      if (element['tag'] != null) {
                        if (element['tag'] == 'Course') {
                          List types = element['type'];
                          types.forEach((element) {
                            coursesChecked[element] = false;
                          });
                        } else if (element['tag'] == 'Webinar') {
                          List types = element['type'];
                          types.forEach((element) {
                            webinarChecked[element] = false;
                          });
                        }
                      }
                    });
                    print(webinarChecked); // allFilter['Course'] = course;
                    // allFilter['Webinar'] = webinar;
                    //coursesChecked = allFilter['Course'];
                    //webinarChecked = allFilter['Webinar'];
                    print(allFilter);
                    return CoursesAbc(
                      courses: didfilter ? filtered : temp,
                    );
                  } else if (snapshot.data == null) {
                    return Loading();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No Courses Available Right Now!'),
                    );
                  }
                  return Loading();
                }),
          );
  }
}

class MyDialogContent extends StatefulWidget {
  final Map courses;
  final Map webinars;
  final List allFilters;

  MyDialogContent({
    Key key,
    this.courses,
    this.webinars,
    this.allFilters,
  }) : super(key: key);

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  TextEditingController editingController = TextEditingController();
  String val;
  var items = List<dynamic>();

  Map courseChecked = {};
  Map webinarChecked = {};

  void init() {
    if (globalCoursesChecked == null)
      for (var temp in widget.courses.keys.toList()) {
        courseChecked[temp] = widget.courses[temp];
      }
    else
      for (var temp in globalCoursesChecked.keys.toList()) {
        courseChecked[temp] = globalCoursesChecked[temp];
      }
    if (globalWebinarChecked == null)
      for (var temp in widget.webinars.keys.toList()) {
        webinarChecked[temp] = widget.webinars[temp];
      }
    else
      for (var temp in globalWebinarChecked.keys.toList()) {
        webinarChecked[temp] = globalWebinarChecked[temp];
      }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        'Filter By',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: 300,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context2, index) {
            return ExpansionTile(
              initiallyExpanded: false,
              children: [
                index == 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                              title: Text(
                                  '${widget.courses.keys.toList()[index]}'),
                              value: courseChecked[
                                  '${widget.courses.keys.toList()[index]}'],
                              onChanged: (bool value) {
                                setState(() {
                                  courseChecked[
                                          '${widget.courses.keys.toList()[index]}'] =
                                      value;
                                });
                              });
                        },
                        itemCount: widget.courses.keys.toList().length,
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                              title: Text(
                                  '${widget.webinars.keys.toList()[index]}'),
                              value: webinarChecked[
                                  '${widget.webinars.keys.toList()[index]}'],
                              onChanged: (bool value) {
                                setState(() {
                                  webinarChecked[
                                          '${widget.webinars.keys.toList()[index]}'] =
                                      value;
                                });
                              });
                        },
                        itemCount: widget.webinars.keys.toList().length,
                      )
              ],
              title: Text(
                '${widget.allFilters[index]}',
              ),
              trailing: IconButton(
                  icon: Icon(EvaIcons.arrowDownOutline), onPressed: null),
              //subtitle: Divider(thickness: 2),
            );
          },
          itemCount: widget.allFilters.length,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                'CLEAR',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline4.color,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(-1);
              },
            ),
            FlatButton(
              child: Text(
                'APPLY',
                style: TextStyle(color: basicColor),
              ),
              onPressed: () {
                Navigator.of(context).pop([courseChecked, webinarChecked]);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CoursesAbc extends StatefulWidget {
  List courses;

  CoursesAbc({this.courses});

  @override
  _CoursesAbcState createState() => _CoursesAbcState();
}

class _CoursesAbcState extends State<CoursesAbc> {
  @override
  Widget build(BuildContext context) {
    return (widget.courses ?? []).length == 0
        ? Center(
            child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("Assets/Images/job.png"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "New Courses and Live Webinars will be coming soon",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline4.color,
                            fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            itemCount: widget.courses.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (widget.courses[index]['live'] == null)
                                return Container();
                              else
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 20),
                                  child: InkWell(
                                    onTap: () {
                                      // COURSES CAN BE OF THREE TYPES MAJORLY : PRE-RECORDED , LIVE WITH MULTI SPEAKERS , LIVE WITH SINGLE SPEAKER //
                                      // USING FIREBASE FIELDS WE DECIDE WHICH THE COURSE IS AND WHERE TO NAVIGATE THE USER TO //

                                      if (widget.courses[index]
                                                  ['live'] !=
                                              null &&
                                          widget.courses[index]['live'] !=
                                              true &&
                                          widget.courses[index]
                                                  ['multiSpeakers'] !=
                                              true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Courses(
                                                    documentId: widget
                                                        .courses[index]
                                                        .documentID,
                                                    email: 'user',
                                                    imageUrl:
                                                        widget.courses[index]
                                                                ['image'] ??
                                                            null)));
                                      } else if (widget.courses[index]
                                              ['multiSpeakers'] ==
                                          true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MultiLive(
                                                      documentID: widget
                                                          .courses[index]
                                                          .documentID,
                                                    )));
                                      } else if (widget.courses[index]
                                                  ['live'] ==
                                              true &&
                                          widget.courses[index]
                                                  ['multiSpeakers'] !=
                                              true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CoursesLive(
                                                      documentId: widget
                                                          .courses[index]
                                                          .documentID,
                                                      email: 'user',
                                                      didEnd:
                                                          widget.courses[index]
                                                                  ['ended'] ??
                                                              false,
                                                      imageUrl:
                                                          widget.courses[index]
                                                                  ['image'] ??
                                                              null,
                                                      title:
                                                          widget.courses[index]
                                                                  ['title'] ??
                                                              'No Title',
                                                    )));
                                      }
                                    },
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          SizedBox(
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: widget.courses[index]
                                                          ['image'] ==
                                                      null
                                                  ? Image.asset(
                                                      "Assets/Images/course.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          widget.courses[index]
                                                              ['image'],
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),

                                              // : CachedNetworkImage(
                                              //     imageUrl:
                                              //         "http://via.placeholder.com/350x150",
                                              //     placeholder: (context,
                                              //             url) =>
                                              //         CircularProgressIndicator(),
                                              //     errorWidget: (context,
                                              //             url, error) =>
                                              //         Icon(Icons.error),
                                              //   ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
