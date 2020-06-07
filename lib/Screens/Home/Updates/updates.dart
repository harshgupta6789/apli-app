import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

double width, height;

class _UpdatesState extends State<Updates> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List filters = [], chosenTypes = [];
  Map<String, bool> userFilters = {
    'message_from_tpo': false,
    'added_to_placement': false,
    'cand_status_change': false,
    'cand_status_change_from_campus': false,
    'message_from_company': false,
    'apli_job': false
  };

  List<List<String>> myNotifications = [];
  int currentTime = Timestamp.now().microsecondsSinceEpoch;
  Timestamp userCreatedTime;

  Future<List<String>> userInit(String email) async {
    String course;
    List<String> tempFilters = [];
    await SharedPreferences.getInstance().then((prefs) async {
      await Firestore.instance
          .collection('users')
          .document(prefs.getString('email'))
          .get()
          .then((s) async {
        if (s.data['timestamp'] != null)
          tempFilters
              .add(s.data['timestamp'].microsecondsSinceEpoch.toString());
        else
          tempFilters.add(Timestamp.fromDate(DateTime.utc(2018))
              .microsecondsSinceEpoch
              .toString());
        await Firestore.instance
            .collection('candidates')
            .document(prefs.getString('email'))
            .get()
            .then((snapshot1) async {
          await Firestore.instance
              .collection('batches')
              .document(snapshot1.data['batch_id'])
              .get()
              .then((snapshot2) {
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
    int timeInMicroSecondsSimceEpoch =
        time.microsecondsSinceEpoch - 19800000000;
    Duration dt = DateTime.now().difference(
        DateTime.fromMicrosecondsSinceEpoch(timeInMicroSecondsSimceEpoch));
    if (dt.isNegative) return 'negative';
    if (dt.inDays > 30)
      return (dt.inDays ~/ 30).toStringAsFixed(0) + ' mo';
    else if (dt.inDays > 0)
      return (dt.inDays.toString() == '1')
          ? '1 day'
          : dt.inDays.toString() + ' days';
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
    Firestore.instance
        .collection('users')
        .document(email)
        .get()
        .then((snapshot) {
      setState(() {
        userCreatedTime = snapshot.data['timestamp'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
//        backgroundColor: Theme.of(context).backgroundColor,
//        key: _scaffoldKey,
//        drawer: customDrawer(context, _scaffoldKey),
//        appBar: PreferredSize(
//          child: AppBar(
//            backgroundColor: basicColor,
//            automaticallyImplyLeading: false,
//            leading: Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.menuOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: () => _scaffoldKey.currentState.openDrawer())),
//            title: Padding(
//              padding: const EdgeInsets.only(bottom: 10.0),
//              child: Text(
//                updates,
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 24,
//                    fontWeight: FontWeight.bold),
//              ),
//            ),
//          ),
//          preferredSize: Size.fromHeight(50),
//        ),
        body: FutureBuilder(
      future: userInit(email),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.length == 0)
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              key: _scaffoldKey,
              drawer: customDrawer(context, _scaffoldKey),
              appBar: PreferredSize(
                child: AppBar(
                  backgroundColor: basicColor,
                  automaticallyImplyLeading: false,
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
              body: Center(
                child: Text('No New Updates'),
              ),
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
                    myNotifications = [];
                    snapshot1.data.documents.forEach((f) {
                      bool isMyNotification = false;
                      String title;
                      String message, status;
                      String notiType = f.data['type'];

                      String messageToShow(
                          String status, String name, String role) {
                        if (status == 'HIRED' || status == 'OFFERED') {
                          return 'Congratulations! you have been hired by $name for the role of $role. Check your mail for more details';
                        } else if (status == 'INTERVIEW') {
                          return 'Congratulations! $name has called you for an offline interview for the role of $role. Check your mail for more details.';
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
                          message = messageToShow(status, f.data['name'] ?? '',
                              f.data['job'] ?? '');
                          break;
                        case 'cand_status_change_from_campus':
                          title = f.data['campus_id'];
                          status = f.data['status'];
                          message = messageToShow(status, f.data['name'] ?? '',
                              f.data['job'] ?? '');
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
                      if (tempTime != null) if (int.parse(filters[0]) <=
                          tempTime.microsecondsSinceEpoch) {
                        if (receivers != null) {
                          if (receivers.contains('all'))
                            isMyNotification = true;
                          else {
                            for (int i = 0; i < receivers.length; i++) {
                              if (filters.contains(receivers[i])) {
                                isMyNotification = true;
                                break;
                              }
                            }
                          }
                          if (isMyNotification) {
                            if (difference(tempTime) != 'negative') {
                              myNotifications.add([
                                title,
                                message,
                                tempTime == null ? null : difference(tempTime),
                                ((f.data['status'] == 'OFFERED' || f.data['status'] == 'HIRED') ? 'offered' : (f.data['status'] == 'INTERVIEW' ? 'interview' : (f.data['type'] == 'message_from_tpo' ? 'college' : 'none'))),
                                f.documentID,
                              ]);
                            }
                          }
                        }
                      }
                    });
                    if (myNotifications.length == 0)
                      return Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        key: _scaffoldKey,
                        drawer: customDrawer(context, _scaffoldKey),
                        appBar: PreferredSize(
                          child: AppBar(
                            backgroundColor: basicColor,
                            automaticallyImplyLeading: false,
                            leading: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: IconButton(
                                    icon: Icon(
                                      EvaIcons.menuOutline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _scaffoldKey.currentState
                                        .openDrawer())),
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
                        body: Center(
                          child: Text(
                            'No New Updates',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    else {
                      return AllNotifications(
                        myNotifications: myNotifications,
                      );
                    }
                  } else
                    return Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        key: _scaffoldKey,
                        drawer: customDrawer(context, _scaffoldKey),
                        appBar: PreferredSize(
                          child: AppBar(
                            backgroundColor: basicColor,
                            automaticallyImplyLeading: false,
                            leading: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: IconButton(
                                    icon: Icon(
                                      EvaIcons.menuOutline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _scaffoldKey.currentState
                                        .openDrawer())),
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
                        body: Loading());
                });
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            drawer: customDrawer(context, _scaffoldKey),
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: basicColor,
                automaticallyImplyLeading: false,
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
            body: Center(
              child: Text('Error, please try again later'),
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              key: _scaffoldKey,
              drawer: customDrawer(context, _scaffoldKey),
              appBar: PreferredSize(
                child: AppBar(
                  backgroundColor: basicColor,
                  automaticallyImplyLeading: false,
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
              body: Loading());
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
  double width, height, scale;
  List<List<String>> myNotifications;
  List<List<String>> items;
  int count = 25;
  int result;

  Map<String, bool> userFilters = {
    'college': false,
    'offered': false,
    'interview': false,
    'none': false
  };

  @override
  Widget build(BuildContext context) {
    result = 0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width < 360)
      scale = 0.7;
    else
      scale = 1;
    myNotifications = widget.myNotifications;
    int length =
        (myNotifications.length < count) ? myNotifications.length : count;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    for(int i = 0; i < myNotifications.length; i++) {
      if((!(userFilters.values.toList().contains(true)) ||
          (userFilters[myNotifications[i][3]] ?? false)))
        result = result + 1;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      drawer: customDrawer(context, _scaffoldKey),
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: basicColor,
          automaticallyImplyLeading: false,
          leading: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                  icon: Icon(
                    EvaIcons.menuOutline,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer())),
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
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10),
              child: IconButton(
                  icon: Icon(
                    EvaIcons.funnelOutline,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) {
                        List<bool> temp = userFilters.values.toList();
                        return StatefulBuilder(builder: (context, setstate) {
                          return SimpleDialog(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.all(Radius.circular(6.0))),
                            backgroundColor: Theme.of(context).backgroundColor,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            title: Text(
                              'Filter Updates',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            children: <Widget>[
                              Container(
                                width: width,
                                padding: EdgeInsets.fromLTRB(
                                    20 * scale, 20, 20 * scale, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CheckboxListTile(
                                      activeColor: basicColor,
                                      dense: true,
                                      value: temp[0],
                                      onChanged: (value) {
                                        setstate(() {
                                          temp[0] = value;
                                        });
                                      },
                                      title: Text('Message from College'),
                                    ),
                                    CheckboxListTile(
                                      activeColor: basicColor,
                                      dense: true,
                                      value: temp[1],
                                      onChanged: (value) {
                                        setstate(() {
                                          temp[1] = value;
                                        });
                                      },
                                      title: Text('Offered Jobs'),
                                    ),
                                    CheckboxListTile(
                                      activeColor: basicColor,
                                      dense: true,
                                      value: temp[2],
                                      onChanged: (value) {
                                        setstate(() {
                                          temp[2] = value;
                                        });
                                      },
                                      title: Text('Job Interview'),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'CLEAR',
                                      style: TextStyle(),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      userFilters.forEach((key, value) {
                                        userFilters[key] = false;
                                      });
                                      setState(() {});
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'APPLY',
                                      style: TextStyle(color: basicColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        userFilters['college'] = temp[0];
                                        userFilters['offered'] = temp[1];
                                        userFilters['interview'] = temp[2];
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          );
                        });
                      },
                    );
                  }),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if(index != length){print(index);print(myNotifications[index][3]);}
                  return index != length
                      ? (!(userFilters.values.toList().contains(true)) ||
                              (userFilters[myNotifications[index][3]] ?? false))
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                child: Card(
                                  color: Theme.of(context).backgroundColor,
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListTile(
                                                  dense: true,
                                                  //isThreeLine: true,
                                                  title: Text(
                                                    myNotifications[index][0] ??
                                                        "No Message Specified",
                                                    //maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500),
                                                    //overflow: TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                    myNotifications[index][1] ??
                                                        "No Message Specified",
                                                    //maxLines: 2,
                                                    //overflow: TextOverflow.ellipsis,
                                                  ),
                                                  trailing: Text(myNotifications[index]
                                                          [2] ??
                                                      'No Time Exception'),
                                                ),
//                                                (myNotifications[index][3] == 'cand_status_change_from_campus' || myNotifications[index][3] == 'cand_status_change' || myNotifications[index][3] == 'message_from_company') ?
                                                false ?
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.0, left: 12.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border:
                                                        Border.all(color: basicColor),
                                                        borderRadius:
                                                        BorderRadius.circular(8),
                                                      ),
                                                      child: MaterialButton(
                                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Text(
                                                            "View Application",
                                                            style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: basicColor,
                                                                fontWeight:
                                                                FontWeight.w600),
                                                          ),
                                                          onPressed: () => null),
                                                    )) : SizedBox()

                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            )
                          : Container()
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
            ),
            result == 0 ? Container(width: width, height: height * 0.75, child: Center(child: Text('No Results')),) : SizedBox()
          ],
        ),
      ),
    );
  }
}
