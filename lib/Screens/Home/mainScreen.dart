import 'package:apli/Screens/Home/courses/courseHome.dart';
import 'package:apli/Screens/Home/Jobs/jobs.dart';
import 'package:apli/Screens/Home/Profile/profile.dart';
import 'package:apli/Screens/Home/Updates/updates.dart';
import 'package:apli/Shared/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'MockJobs/mockJobs.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentTab = 2;
  TabController _tabController;
  AnimationController _animationController;
  Animation<Offset> _animation;

  @override
  void initState() {
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

  final List<Widget> _listTabs = [CourseMain(), MockJobs(), Jobs(), Updates(), Profile()];

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
                style: TextStyle(color: basicColor),
              )),
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
                mockJobs,
                style: TextStyle(color: basicColor),
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
                style: TextStyle(color: basicColor),
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
              style: TextStyle(color: basicColor),
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
                style: TextStyle(color: basicColor),
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: TabBarView(
          children: _listTabs,
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
