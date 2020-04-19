
import 'package:apli/Models/user.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {

  List filters = [];
  List<List<String>> myNotifications = [];
  int currentTime = Timestamp.now().microsecondsSinceEpoch;

  Future<List<String>> userInit(String email) async {
    String batchID;
    String course;
    List<String> tempFilters = [email];

    await Firestore.instance
        .collection('candidates')
        .document(email)
        .get()
        .then((snapshot) => batchID = snapshot.data['batch_id']);

    if(batchID != null) {
      await Firestore.instance
          .collection('batches')
          .document(batchID)
          .get()
          .then((snapshot) => course = snapshot.data['course']);
      tempFilters.add(course);
    }

    return tempFilters;
  }

  String difference(Timestamp time) {
    int timeInMicroSecondsSimceEpoch = time.microsecondsSinceEpoch;
    Duration dt = DateTime.now().difference(
        DateTime.fromMicrosecondsSinceEpoch(timeInMicroSecondsSimceEpoch));
    if (dt.inDays > 0)
      return dt.inDays.toString() + ' days ago';
    else if (dt.inHours > 0)
      return dt.inHours.toString() + ' hrs ago';
    else if (dt.inMinutes > 0)
      return dt.inMinutes.toString() + ' min ago';
    else
      return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<User>(context);
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: customDrawer(context, user),
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
        body: FutureBuilder(
          future: userInit(user.email),
          builder: (BuildContext context,
              AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0)
                return Center(
                  child: Text('No New Updates'),
                );
              else {
                filters = snapshot.data;
                return StreamBuilder(
                  stream: Firestore.instance.collection("notifications").orderBy('time', descending: true).snapshots(),
                  builder: (context, snapshot1){
                    if(snapshot1.hasData){
                      snapshot1.data.documents.forEach((f) {
                        bool isMyNotification = false;

                        String tempMessage = f.data['message'];
                        Timestamp tempTime = f.data['time'];
                        List receivers = f.data['receivers'];
                        if (receivers != null) {
                          for (int i = 0; i < receivers.length; i++) {
                            if (filters.contains(receivers[i])) {
                              isMyNotification = true;
                              break;
                            }
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
                      if(myNotifications.length == 0) return Center(child: Text('No New Updates'),); else return Padding(
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
                                          trailing: Text(myNotifications[index][1] ??
                                              'No Time Exception'),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0, left: 10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: basicColor),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: MaterialButton(
                                                  child: Text(
                                                    "View Application",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: basicColor,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  onPressed: () => null),
                                            )),
                                      ]),
                                ),
                              );
                            },
                          ));
                    } else return Loading();
                  }
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error, please try again later'),
              );
            } else {
              return Loading();
            }
          },
        ));
  }
}
