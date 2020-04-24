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
            IconButton(
                icon: Icon(
                  EvaIcons.moreVerticalOutline,
                  color: Colors.white,
                ),
                onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
          ],
          title: Text(
            courses,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('edu_courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                        thickness: 2,
                      ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text(
                        snapshot.data.documents[index].data['title'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24),
                      ),
                      subtitle: Text("By  " +
                          snapshot.data.documents[index].data['title']
                              .toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Courses(
                                    documentId: snapshot
                                        .data.documents[index].documentID,
                                email: 'user',
                                  )),
                        );
                      },
                      trailing: IconButton(
                          icon: Icon(EvaIcons.arrowIosForward),
                          onPressed: null),
                    );
                  });
            } else
              return Loading();
          }),
      // child: Column(children: <Widget>[
      //   Padding(
      //     padding: EdgeInsets.only(top: 300.0),
      //     child: Center(child: Image.asset("Assets/Images/job.png")),
      //   ),
      // ]),
    );
  }
}
