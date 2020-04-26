import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  List filters = [];
  List<List<String>> myNotifications = [];
  int currentTime = Timestamp.now().microsecondsSinceEpoch;
  Timestamp userCreatedTime;

  Future<List<String>> userInit(String email) async {
    String batchID;
    String course;
    String email;
    List<String> tempFilters = [];
    await SharedPreferences.getInstance().then((prefs) async {
      await Firestore.instance.collection('users').document(prefs.getString('email')).get().then((s) async {
        tempFilters.add(s.data['timestamp'].microsecondsSinceEpoch.toString());
        await Firestore.instance
            .collection('candidates')
            .document(prefs.getString('email'))
            .get()
            .then((snapshot1) async {
          await Firestore.instance
              .collection('batches')
              .document(snapshot1.data['batch_id'])
              .get()
              .then((snapshot2){
            course = snapshot2.data['course'];
            tempFilters.add(prefs.getString('email'));
            tempFilters.add(course);
          });
        });
      });
    });
    return tempFilters;
  }

  String difference(Timestamp time) {
    int timeInMicroSecondsSimceEpoch = time.microsecondsSinceEpoch;
    Duration dt = DateTime.now().difference(
        DateTime.fromMicrosecondsSinceEpoch(timeInMicroSecondsSimceEpoch));
    if (dt.isNegative) return 'negative';
    if (dt.inDays > 30)
      return (dt.inDays ~/ 30).toStringAsFixed(0) + ' mo';
    else if (dt.inDays > 0)
      return dt.inDays.toString() + ' days';
    else if (dt.inHours > 0)
      return dt.inHours.toString() + ' hrs';
    else if (dt.inMinutes > 0)
      return dt.inMinutes.toString() + ' min';
    else
      return 'Just now';
  }

  String email;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString('email');
      });
    });
    Firestore.instance.collection('users').document(email).get().then((snapshot) {
      setState(() {
        userCreatedTime = snapshot.data['timestamp'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
//    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: customDrawer(context , _scaffoldKey),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              // IconButton(
              //     icon: Icon(
              //       EvaIcons.funnelOutline,
              //       color: Colors.white,
              //     ),
              //     onPressed: null),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.moreVerticalOutline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    }),
              ),
            ],
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                updates,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
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
                print(filters);
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection("notifications")
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData) {
                        snapshot1.data.documents.forEach((f) {
                          bool isMyNotification = false;
                          String title;
                          String message, status;
                          String notiType = f.data['type'];

                          String messageToShow(
                              String status, String name, String role) {
                            if (status == 'HIRED' || status == 'OFFERED') {
                              return 'Congratulations! $name has called you for an offline interview for the role of $role. Check your mail for more details.';
                            } else if (status == 'INTERVIEW') {
                              return 'Congratulations! you have been hired by $name for the role of $role. Check your mail for more details';
                            } else if (status == 'REJECTED') {
                              return 'Sorry! but your application for $role has been discarded by $name. Better luck next time.';
                            } else {
                              return '';
                            }
                          }

                          switch (notiType) {
                            case 'message_from_tpo':
                              title = f.data['tpo_name'];
                              message = f.data['message'];
                              break;
                            case 'added_to_placement':
                              title = f.data['campus'];
                              message = f.data['placement'];
                              break;
                            case 'cand_status_change':
                              title = f.data['name'];
                              status = f.data['status'];
                              message = messageToShow(status,
                                  f.data['name'] ?? '', f.data['job'] ?? '');
                              break;
                            case 'cand_status_change_from_campus':
                              title = f.data['campus_id'];
                              status = f.data['status'];
                              message = messageToShow(status,
                                  f.data['name'] ?? '', f.data['job'] ?? '');
                              break;
                            case 'message_from_company':
                              title = f.data['name'];
                              message = f.data['message'];
                              break;
                            case 'apli_job':
                              title = f.data['name'];
                              message = f.data['message'];
                              break;
                            default:
                              message = null;
                          }

                          Timestamp tempTime = f.data['time'];
                          List receivers = f.data['receivers'];
                          if(tempTime != null)
                            if(int.parse(filters[0]) <= tempTime.microsecondsSinceEpoch) {
                              if (receivers != null) {
                                for (int i = 0; i < receivers.length; i++) {
                                  if (filters.contains(receivers[i])) {
                                    isMyNotification = true;
                                    break;
                                  }
                                }
                                if (isMyNotification) {
                                  if (difference(tempTime) != 'negative') {
                                    myNotifications.add([
                                      title,
                                      message,
                                      tempTime == null
                                          ? null
                                          : difference(tempTime),
                                      notiType,
                                      f.documentID,
                                    ]);
                                  }
                                }
                              }
                            }
                        });
                        if (myNotifications.length == 0)
                          return Center(
                            child: Text(
                              'No New Updates',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                        else
                          return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: AllNotifications(
                                myNotifications: myNotifications,
                              ));
                      } else
                        return Loading();
                    });
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
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

class AllNotifications extends StatefulWidget {
  List<List<String>> myNotifications = [];

  AllNotifications({this.myNotifications});

  @override
  _AllNotificationsState createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  double width, height;
  List<List<String>> myNotifications;
  List<List<String>> items;
  int count = 8;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    myNotifications = widget.myNotifications;
    int length =
        (myNotifications.length < count) ? myNotifications.length : count;
    return Container(
      child: ListView.builder(
        itemCount: length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index != length
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    child: Card(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.grey)),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.01, top: 5.0),
                                child: ListTile(
                                  title: AutoSizeText(
                                    myNotifications[index][0] ??
                                        "No Messsage Specified",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: AutoSizeText(
                                    myNotifications[index][1] ??
                                        "No Messsage Specified",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(myNotifications[index][2] ??
                                      'No Time Exception'),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                )
              : length == myNotifications.length
                  ? Container()
                  : FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Load More',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.refresh,
                            size: 15,
                          )
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          count = count + 10;
                        });
                      },
                    );
        },
      ),
    );
  }
}
