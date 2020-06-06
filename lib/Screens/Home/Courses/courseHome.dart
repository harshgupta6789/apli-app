import 'package:apli/Screens/Home/Courses/courses.dart';
import 'package:apli/Screens/Home/Courses/coursesLive.dart';
import 'package:apli/Screens/Home/Courses/multiLive.dart';
import 'package:apli/Services/themeProvider.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

double height, width;
Orientation orientation;

class _CourseMainState extends State<CourseMain> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List temp = [];
  // Map allFilter = {'Course': [], 'Webinar': []};
  List allFilter = ['Courses', 'Webinar'];
  Map coursesChecked = {};
  Map webinarChecked = {};

  void filterStuff(Map course , Map webinar){
    for(var eachCourse in temp){
      if(eachCourse['tag']=='Course'){
        
      }else{
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
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
                    await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return MyDialogContent(
                            courses: coursesChecked,
                            webinars: webinarChecked,
                            allFilters: allFilter,
                          );
                        });
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
                  onPressed: () => _scaffoldKey.currentState.openDrawer())),
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
          stream: Firestore.instance.collection('edu_courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              temp = snapshot.data.documents;

              temp.forEach((element) {
                if (element['tag'] != null) {
                  if (element['tag'] == 'Course') {
                    coursesChecked[element['type']] = false;
                  } else if (element['tag'] == 'Webinar') {
                    webinarChecked[element['type']] = false;
                  }
                }
              });
              print(webinarChecked); // allFilter['Course'] = course;
              // allFilter['Webinar'] = webinar;
              //coursesChecked = allFilter['Course'];
              //webinarChecked = allFilter['Webinar'];
              print(allFilter);
              return Padding(
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
                                itemCount: snapshot.data.documents.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  if (snapshot.data.documents[index]['live'] ==
                                      null)
                                    return Container();
                                  else
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          if (snapshot.data.documents[index]
                                                      ['live'] !=
                                                  null &&
                                              snapshot.data.documents[index]
                                                      ['live'] !=
                                                  true &&
                                              snapshot.data.documents[index]
                                                      ['multiSpeakers'] !=
                                                  true) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Courses(
                                                        documentId: snapshot
                                                            .data
                                                            .documents[index]
                                                            .documentID,
                                                        email: 'user',
                                                        imageUrl: snapshot.data
                                                                    .documents[
                                                                index]['image'] ??
                                                            null)));
                                          } else if (snapshot
                                                      .data.documents[index]
                                                  ['multiSpeakers'] ==
                                              true) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiLive(
                                                          documentID: snapshot
                                                              .data
                                                              .documents[index]
                                                              .documentID,
                                                        )));
                                          } else if (snapshot
                                                          .data.documents[index]
                                                      ['live'] ==
                                                  true &&
                                              snapshot.data.documents[index]
                                                      ['multiSpeakers'] !=
                                                  true) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CoursesLive(
                                                          documentId: snapshot
                                                              .data
                                                              .documents[index]
                                                              .documentID,
                                                          email: 'user',
                                                          didEnd: snapshot.data
                                                                      .documents[
                                                                  index]['ended'] ??
                                                              false,
                                                          imageUrl: snapshot
                                                                      .data
                                                                      .documents[
                                                                  index]['image'] ??
                                                              null,
                                                          title: snapshot.data
                                                                      .documents[
                                                                  index]['title'] ??
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
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: snapshot.data
                                                                  .documents[
                                                              index]['image'] ==
                                                          null
                                                      ? Image.asset(
                                                          "Assets/Images/course.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['image'],
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
    for (var temp in widget.courses.keys.toList()) {
      courseChecked[temp] = widget.courses[temp];
    }
    for (var temp in widget.webinars.keys.toList()) {
      webinarChecked[temp] = widget.webinars[temp];
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
                            title: Text('${widget.courses.keys.toList()[index]}'),
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
                           title: Text('${widget.webinars.keys.toList()[index]}'),
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
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 30.0, bottom: 20.0),
                child: RaisedButton(
                    color: basicColor,
                    elevation: 0,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: basicColor, width: 1.2),
                    ),
                    onPressed: () {
                      print(webinarChecked);
                      Navigator.of(context).pop([courseChecked , webinarChecked]);
                    },
                    child: Text(
                      'Filter',
                      style: TextStyle(color: Colors.white),
                    )))),
      ],
    );
  }
}
