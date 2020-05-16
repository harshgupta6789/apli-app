import 'dart:io';
import 'package:apli/Screens/Home/Updates/updates.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _currentTab = 2;
          _tabController.animateTo(2);
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _currentTab = 2;
          _tabController.animateTo(2);
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

  final List<Widget> _listTabs = [CourseMain(), Jobs(), Updates(), Profile()];

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
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
                    color: _currentTab == 0 ? basicColor : Colors.grey),
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
                    color: _currentTab == 1 ? basicColor : Colors.grey),
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
              style:
                  TextStyle(color: _currentTab == 2 ? basicColor : Colors.grey),
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
                    color: _currentTab == 3 ? basicColor : Colors.grey),
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
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
