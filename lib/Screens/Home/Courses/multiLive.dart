import 'package:flutter/material.dart';

import 'package:apli/Screens/Home/Courses/courses.dart';
import 'package:apli/Screens/Home/Courses/coursesLive.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class MultiLive extends StatefulWidget {
  final String documentID;

  const MultiLive({Key key, this.documentID}) : super(key: key);
  @override
  _MultiLiveState createState() => _MultiLiveState();
}

double height, width;
Orientation orientation;

class _MultiLiveState extends State<MultiLive> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  THIS IS THE MENU FOR LIVE WEBINAR WITH MULTIPLE SPEAKERS IN SHORT A BANNER FOR EACH SPEAKER WHICH WILL TAKE YOU TO DETAILS PAGE //
  // THE VIDEOS ARE AGAIN TAKEN FROM FIREBASE AND ARRANGED BY TIMESTAMP THEN //

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
          stream: Firestore.instance
              .collection('edu_courses')
              .document(widget.documentID)
              .collection("speakers")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
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
                                          // if (snapshot.data.documents[index]
                                          //             ['live'] !=
                                          //         null &&
                                          //     snapshot.data.documents[index]
                                          //             ['live'] !=
                                          //         true) {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) => Courses(
                                          //               documentId: snapshot
                                          //                   .data
                                          //                   .documents[index]
                                          //                   .documentID,
                                          //               email: 'user',
                                          //               imageUrl: snapshot.data
                                          //                           .documents[
                                          //                       index]['image'] ??
                                          //                   null)));
                                          // } else if (snapshot.data.documents[index]
                                          //             ['live'] !=
                                          //         null &&
                                          //     snapshot.data.documents[index]
                                          //             ['live'] ==
                                          //         true && snapshot.data.documents[index]
                                          //             ['multiSpeakers'] !=
                                          //         null && snapshot.data.documents[index]
                                          //             ['multiSpeakers'] ==
                                          //         true ) {

                                          //         }else {
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
                                                        imageUrl: snapshot.data
                                                                    .documents[
                                                                index]['image'] ??
                                                            null,
                                                        title: snapshot.data
                                                                    .documents[
                                                                index]['title'] ??
                                                            'No Title',
                                                      )));
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
