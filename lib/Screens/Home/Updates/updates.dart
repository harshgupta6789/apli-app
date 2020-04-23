import 'package:apli/Models/user.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

// enum NotificationType { message_from_tpo , apli_job ,cand_applied , added_to_placement , message_from_company , cand_status_change }

class _UpdatesState extends State<Updates> {
  double height, width;

  Widget notificationCard(String type, int index) {
    switch (type) {
      case "message_from_tpo":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: height * 0.1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.grey)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(myNotifications[index].toString()),
                      trailing: Text(
                          myNotifications[index][1] ?? 'No Time Exception'),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: basicColor),
                            borderRadius: BorderRadius.circular(10),
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
          ),
        );
        break;
      case "apli_job":
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: height * 0.2,
            child: Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: width*0.01),
                      child: ListTile(
                        title: AutoSizeText(
                            myNotifications[index][0] ?? "No Messsage Specified" , maxLines: 2, overflow: TextOverflow.ellipsis,),
                            subtitle: AutoSizeText(
                            myNotifications[index][3] ?? "No Messsage Specified" , maxLines: 3, overflow: TextOverflow.ellipsis,),
                        trailing: Text(
                            myNotifications[index][1] ?? 'No Time Exception'),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: height * 0.05, left: width*0.03),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: basicColor),
                            borderRadius: BorderRadius.circular(10),
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
          ),
        );
        break;
      case "message_from_tpo":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 180.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.grey)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(myNotifications[index][1]),
                      trailing: Text(
                          myNotifications[index][1] ?? 'No Time Exception'),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: basicColor),
                            borderRadius: BorderRadius.circular(10),
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
          ),
        );
        break;
      case "message_from_company":
        return Container(
          height: 180.0,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.grey)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(myNotifications[index].toString()),
                    trailing:
                        Text(myNotifications[index][1] ?? 'No Time Exception'),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: basicColor),
                          borderRadius: BorderRadius.circular(10),
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
        break;
      case "cand_status_change":
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: height * 0.2,
            child: Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: width*0.01),
                      child: ListTile(
                        title: AutoSizeText(
                            myNotifications[index][0] ?? "No Messsage Specified" , maxLines: 2, overflow: TextOverflow.ellipsis,),
                            subtitle: AutoSizeText(
                            myNotifications[index][3] ?? "No Messsage Specified" , maxLines: 3, overflow: TextOverflow.ellipsis,),
                        trailing: Text(
                            myNotifications[index][1] ?? 'No Time Exception'),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: height * 0.05, left: width*0.03),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: basicColor),
                            borderRadius: BorderRadius.circular(10),
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
          ),
        );
        break;
      case "cand_applied":
        return Container(
          height: 180.0,
          child: Card(
            elevation: 0.2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(myNotifications[index].toString()),
                    trailing:
                        Text(myNotifications[index][1] ?? 'No Time Exception'),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: basicColor),
                          borderRadius: BorderRadius.circular(10),
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
        break;
      default:
        return Text("");
    }
  }

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

    if (batchID != null) {
      await Firestore.instance
          .collection('batches')
          .document(batchID)
          .get()
          .then((snapshot) => course = snapshot.data['course']);
      tempFilters.add(course);
    }
    print(tempFilters);
    return tempFilters;
  }

  String difference(Timestamp time) {
    int timeInMicroSecondsSimceEpoch = time.microsecondsSinceEpoch;
    Duration dt = DateTime.now().difference(
        DateTime.fromMicrosecondsSinceEpoch(timeInMicroSecondsSimceEpoch));
    if (dt.inDays > 0)
      return dt.inDays.toString() + ' days';
    else if (dt.inHours > 0)
      return dt.inHours.toString() + ' hrs';
    else if (dt.inMinutes > 0)
      return dt.inMinutes.toString() + ' min';
    else
      return 'Just now';
  }

  String email;
  getPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString('email');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: customDrawer(context, email),
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
          future: userInit(email),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.length == 0)
                return Center(
                  child: Text('No New Updates'),
                );
              else {
                filters = snapshot.data;
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection("notifications")
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData) {
                        snapshot1.data.documents.forEach((f) {
                          bool isMyNotification = false;

                          String tempMessage = f.data['message'];
                          String notiType = f.data['type'];
                          String job = f.data['job'];
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
                              if (tempTime != null) {
                                myNotifications.add([
                                  tempMessage,
                                  difference(tempTime),
                                  notiType,
                                  job,
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
                        if (myNotifications.length == 0)
                          return Center(
                            child: Text('No New Updates'),
                          );
                        else
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: myNotifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return notificationCard(
                                      myNotifications[index][2], index);
                                },
                              ));
                      } else
                        return Loading();
                    });
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
