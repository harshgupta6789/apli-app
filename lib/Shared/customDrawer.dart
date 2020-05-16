import 'package:apli/Screens/HomeLoginWrapper.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

double width, height;

Widget customDrawer(BuildContext context, GlobalKey x) {
  width = MediaQuery.of(context).size.width;
  height = MediaQuery.of(context).size.height;
  double dividerThickness = 2;
  double fontSize = 15;

  Future<List<String>> userInit() async {
    List<String> userData = [];

    await SharedPreferences.getInstance().then((value) async {
      try {
        await Firestore.instance
            .collection('candidates')
            .document(value.getString('email'))
            .get()
            .then((snapshot) {
          String fname = snapshot.data['First_name'];
          String lname = snapshot.data['Last_name'];
          if (lname == null)
            userData.add(fname);
          else
            userData.add(fname + ' ' + lname);
          userData.add((snapshot.data['profile_picture']));
        });
      } catch (e) {
        userData = ['error'];
      }
    });

    return userData;
  }

  Widget sideNav() {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(width * 0.3, height * 0.05, 0, height * 0.03),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                    future: userInit(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data[0] == 'error')
                          return Text('Error occured, try again later');
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 10),
                              child: CircleAvatar(
                                minRadius: 30,
                                maxRadius: 35,
                                backgroundImage: snapshot.data[1] != null
                                    ? snapshot.data[1] == defaultPic
                                        ? AssetImage(
                                            "Assets/Images/defaultProfilePicture.jpeg")
                                        : NetworkImage(snapshot.data[1])
                                    : null,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: width * 0.3,
                                      child: AutoSizeText(
                                        snapshot.data[0] != null
                                            ? snapshot.data[0]
                                            : 'No Name',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error, please try again later'),
                        );
                      } else {
                        return Loading();
                      }
                    }),
              ),
              ListTile(
                dense: true,
                title: Text(
                  "Notification Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSize),
                ),
                trailing: IconButton(
                    icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
                //trailing: NotificationSwitch(),
                onTap: () {
                  AppSettings.openAppSettings();
                },
              ),
              Divider(
                thickness: dividerThickness,
              ),
              ListTile(
                  dense: true,
                  title: Text(
                    "Rate Your Experience",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSize),
                  ),
                  trailing: IconButton(
                      icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
                  onTap: () async {
                    const url =
                        'https://play.google.com/store/apps/details?id=com.apliai.app';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              Divider(
                thickness: dividerThickness,
              ),
              ListTile(
                  dense: true,
                  title: Text(
                    "Refer A Friend",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSize),
                  ),
                  trailing: IconButton(
                      icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
                  onTap: () async {
                    const url =
                        'https://play.google.com/store/apps/details?id=com.apliai.app';
                    Share.share(url);
                  }),
              Divider(
                thickness: dividerThickness,
              ),
              ListTile(
                  dense: true,
                  title: Text(
                    "Report",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSize),
                  ),
                  trailing: IconButton(
                      icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
                  onTap: () async {
                    const url =
                        'mailto:info@apli.ai?subject=Regarding Apli App';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              Divider(
                thickness: dividerThickness,
              ),
              ListTile(
                  dense: true,
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: fontSize),
                  ),
                  trailing: IconButton(
                      icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Wrapper()),
                        (Route<dynamic> route) => false);
                    showToast('Logged Out Successfully', context);
                  }),
              Divider(
                thickness: dividerThickness,
              ),
              ListTile(
                dense: true,
                title: Text(copyright),
              ),
            ],
          ),
        ),
      ),
    );
  }

  return MediaQuery.of(context).orientation == Orientation.portrait
      ? sideNav()
      : ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: sideNav(),
          ),
        );
}

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool isSwitched = true;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  getPrefs() {
    SharedPreferences.getInstance().then((prefs1) {
      setState(() {
        prefs = prefs1;
      });
      if (prefs.containsKey('isNotificationsEnabled')) {
        setState(() {
          isSwitched = prefs.getBool('isNotificationsEnabled');
        });
      }
    });
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
        });
        if (isSwitched == false) {
          _firebaseMessaging.unsubscribeFromTopic("App");
          prefs.setBool("isNotificationsEnabled", false);
        } else {
          _firebaseMessaging.subscribeToTopic("App");
          prefs.setBool("isNotificationsEnabled", true);
        }
      },
      child: Switch(
        activeColor: basicColor,
        activeTrackColor: basicColor,
        inactiveTrackColor: Colors.grey,
        value: isSwitched,
        onChanged: (bool value) {},
      ),
    );
  }
}
