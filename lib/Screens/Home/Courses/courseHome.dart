import 'package:apli/Screens/Home/Courses/courses.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context),
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
        preferredSize: Size.fromHeight(55),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('edu_courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Courses(
                                      documentId: snapshot
                                          .data.documents[index].documentID,
                                      email: 'user',
                                    )));
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:  Image.asset("Assets/Images/course.png" ,),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 130.0,
                            left: 50.0,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Trending",
                                      style: TextStyle(color: Colors.yellow)),
                                  Text("Startup 101",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Text("By Harvard",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 18,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            } else
              return Loading();
          }),
    );
  }
}
