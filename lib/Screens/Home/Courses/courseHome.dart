import 'package:apli/Screens/Home/Courses/courses.dart';
import 'package:apli/Screens/Home/Courses/coursesLive.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

double height, width;
Orientation orientation;

class _CourseMainState extends State<CourseMain> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context, _scaffoldKey),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: basicColor,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.moreVerticalOutline,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        _scaffoldKey.currentState.openEndDrawer())),
          ],
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
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                          } else {
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
                                                          placeholder:
                                                              (context, url) =>
                                                                  Loading(),
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
            } else
              return Loading();
          }),
    );
  }
}
