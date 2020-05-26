import 'dart:io';

import 'package:apli/Screens/Home/MockJobs/mockJobs.dart';
import 'package:apli/Screens/Home/Updates/updates.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeLoginWrapper.dart';
import 'Courses/courseHome.dart';
import 'Jobs/jobs.dart';
import 'Profile/profile.dart';

class MainScreen extends StatefulWidget {
  int currentTab;
  MainScreen({this.currentTab});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static int _currentTab;
  static TabController _tabController;
  AnimationController _animationController;
  Animation<Offset> _animation;
  SharedPreferences prefs;

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  void showAlertDialog(String title, String msg, DialogType dialogType,
      BuildContext context, VoidCallback onOkPress) {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      dialogType: dialogType,
      tittle: title ?? "Welcome Back",
      desc: msg ?? "This is Body",
      btnOkIcon: Icons.check_circle,
      btnCancelText: "Cancel",
      btnOkText: "Take Me!",
      btnOkColor: Colors.green.shade900,
      btnOkOnPress: onOkPress,
    ).show();
  }

  void firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) {
      iOSPermission();
    }
    _firebaseMessaging.getToken().then((token) {
      //print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (_currentTab == 2) {
          showAlertDialog(message['notification']['title'],
              message['notification']['body'], DialogType.INFO, context, () {
            if (message['data']['type'] != null) {
              switch (message['data']['type']) {
                case 'AppliedJob':
                  {
                    prefs.setInt("jobTab", 0);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Wrapper(
                                  currentTab: 1,
                                )),
                        (Route<dynamic> route) => false);
                    setState(() {});
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Updates()),
                    // );
                  }
                  break;
                case 'Alert':
                  {}
                  break;
                default:
                  {}
                  break;
              }
            }
          });
          // Toast.show("JOB", context,
          //     backgroundColor: Colors.white30,
          //     duration: 10,
          //     // border: Border.all(
          //     //   color: color ?? basicColor,
          //     // ),
          //     textColor: basicColor,
          //     backgroundRadius: 4,
          //     gravity: Toast.BOTTOM);

        } else {
          showAlertDialog(message['notification']['title'],
              message['notification']['body'], DialogType.INFO, context, () {
            if (message['data']['type'] != null) {
              switch (message['data']['type']) {
                case 'Job':
                  {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Wrapper(
                                  currentTab: 2,
                                )),
                        (Route<dynamic> route) => false);
                    setState(() {});
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Updates()),
                    // );
                  }
                  break;
                case 'Alert':
                  {}
                  break;
                default:
                  {}
                  break;
              }
            }
          });
        }
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _currentTab = 3;
          _tabController.animateTo(3);
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _currentTab = 3;
          _tabController.animateTo(3);
        });
      },
    );
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isNotificationsEnabled") != null) {
      if (prefs.getBool("isNotificationsEnabled") == true) {
        _firebaseMessaging.subscribeToTopic("App");
      }
    } else {
      _firebaseMessaging.subscribeToTopic("App");
      prefs.setBool("isNotificationsEnabled", true);
    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  void checkIfLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("email")) {
      firebaseCloudMessagingListeners();
    }
  }

  @override
  void initState() {
    _currentTab = widget.currentTab ?? 0;
    checkIfLoggedIn();
    _tabController = TabController(vsync: this, length: _listTabs.length);
    _tabController.animateTo(_currentTab);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0))
        .animate(CurvedAnimation(
            curve: Curves.easeOut, parent: _animationController));
    _animationController.reverse();
    super.initState();
  }

  final List<Widget> _listTabs = [
    CourseMain(),
    MockJobs(),
    Jobs(),
    Updates(),
    Profile()
  ];

  Widget _bottomNavigationBar() {
    double fontSize = 13;
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
            _tabController.animateTo(_currentTab);
            _animationController.reverse();
          });
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 25.0,
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(
                EvaIcons.menuOutline,
                color: basicColor,
              ),
              icon: Icon(
                EvaIcons.menuOutline,
                color: Colors.grey,
              ),
              title: Text(
                courses,
                style: TextStyle(
                    color: _currentTab == 0 ? basicColor : Colors.grey,
                    fontSize: fontSize),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                EvaIcons.headphonesOutline,
                color: basicColor,
              ),
              icon: Icon(
                EvaIcons.headphonesOutline,
                color: Colors.grey,
              ),
              title: Text(
                mockJob,
                style: TextStyle(
                    color: _currentTab == 1 ? basicColor : Colors.grey,
                    fontSize: fontSize),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                EvaIcons.briefcaseOutline,
                color: basicColor,
              ),
              icon: Icon(
                EvaIcons.briefcaseOutline,
                color: Colors.grey,
              ),
              title: Text(
                jobs,
                style: TextStyle(
                    color: _currentTab == 2 ? basicColor : Colors.grey,
                    fontSize: fontSize),
              )),
          BottomNavigationBarItem(
            activeIcon: Icon(
              EvaIcons.bellOutline,
              color: basicColor,
            ),
            icon: Icon(
              EvaIcons.bellOutline,
              color: Colors.grey,
            ),
            title: Text(
              updates,
              style: TextStyle(
                  color: _currentTab == 3 ? basicColor : Colors.grey,
                  fontSize: fontSize),
            ),
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(
                EvaIcons.personOutline,
                color: basicColor,
              ),
              icon: Icon(
                EvaIcons.personOutline,
                color: Colors.grey,
              ),
              title: Text(
                profile,
                style: TextStyle(
                    color: _currentTab == 4 ? basicColor : Colors.grey,
                    fontSize: fontSize),
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]),
          padding: const EdgeInsets.only(bottom: 5),
          child: _bottomNavigationBar(),
        ),
        body: DoubleBackToCloseApp(
          child: TabBarView(
            children: _listTabs,
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
          ),
          snackBar: const SnackBar(
            content: Text('Press again to exit the app'),
          ),
        ));
  }
}
