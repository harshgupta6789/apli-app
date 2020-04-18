import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  Stream notifications;
  FirebaseUser user;
  String batchID;
  String course;
  
  List filters = [];
  List<List<String>> myNotifications = [];
  int currentTime = Timestamp.now().microsecondsSinceEpoch;

  userInit() async {
    user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('candidates').document(user.email)
        .get().then((snapshot) =>
    batchID = snapshot.data['batch_id']
    );

    print(batchID);
    Firestore.instance.collection('batches').document(batchID).
    get().then((snapshot) =>
    course = snapshot.data['course']
    );

    filters.add(user.email);
    filters.add(course);
  }

  @override
  void initState() {
    super.initState();
    userInit();
    notifications = Firestore.instance.collection("notifications").orderBy('time', descending: true).snapshots();
  }

  String difference(Timestamp time) {
    int timeInMicroSecondsSimceEpoch = time.microsecondsSinceEpoch;
    Duration dt = DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(timeInMicroSecondsSimceEpoch));
    if(dt.inDays > 0) return dt.inDays.toString() + ' days ago';
    else if(dt.inHours > 0) return dt.inHours.toString() + ' hrs ago';
    else if(dt.inMinutes > 0) return dt.inMinutes.toString() + ' min ago';
    else return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: customDrawer(context),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    EvaIcons.funnelOutline,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  }),
            ],
            title: Text(
              updates,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: StreamBuilder(
            stream: notifications,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(filters);
                snapshot.data.documents.forEach((f) {
                  bool isMyNotification = false;

                  String tempMessage = f.data['message'];
                  Timestamp tempTime = f.data['time'];

                  List receivers = f.data['receivers'];
                  if (receivers != null) {
                    for (int i = 0; i < filters.length; i++) {
                      if (receivers.contains(filters[i])) {
                        isMyNotification = true;
                      }
                      break;
                    }
                    if (isMyNotification) {
                      if(tempTime != null) {
                        myNotifications.add([
                          tempMessage,
                          difference(tempTime),
                          f.documentID,
                        ]);
                      } else {
                        myNotifications.add([
                          tempMessage,
                          null,
                          f.documentID,
                        ]);
                      }
                    }
                  }
                });
                print(myNotifications);
                if (myNotifications.length == 0) {
                  return Center(
                    child: Text('no new updates yet'),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: myNotifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 180.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(myNotifications[index][0] ??
                                          "No Message Exception"),
                                      trailing: Text(myNotifications[index]
                                              [1] ??
                                          'No Time Exception'),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, left: 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: basicColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: MaterialButton(
                                              child: Text(
                                                "View Application",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: basicColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              onPressed: () => null),
                                        )),
                                  ]),
                            ),
                          );
                        },
                      )

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     RawChip(
                      //       label: Text("New Jobs"),
                      //       selected: false,
                      //       backgroundColor: basicColor,
                      //     ),
                      //     RawChip(label: Text("Messages"), selected: true),
                      //     RawChip(label: Text("Application"), selected: false),
                      //   ],
                      // ),

                      //
                      // Container(
                      //   height: 180.0,
                      //   child: Card(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15.0),
                      //     ),
                      //     child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           ListTile(
                      //             title: Text(
                      //                 "You have an interview at Deloitte, scheduled on 2/04/2020"),
                      //             trailing: Text("1 mo"),
                      //           ),
                      //           Padding(
                      //               padding:
                      //                   EdgeInsets.only(top: 20.0, left: 10.0),
                      //               child: Container(
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(color: basicColor),
                      //                   borderRadius: BorderRadius.circular(10),
                      //                 ),
                      //                 child: MaterialButton(
                      //                     child: Text(
                      //                       "View Application",
                      //                       style: TextStyle(
                      //                           fontSize: 18.0,
                      //                           color: basicColor,
                      //                           fontWeight: FontWeight.w600),
                      //                     ),
                      //                     onPressed: () => null),
                      //               )),
                      //         ]),
                      //   ),
                      // )
                      );
                }
              } else {
                return Loading();
              }
            }));
  }
}
