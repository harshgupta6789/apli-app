import 'package:apli/Screens/Home/Jobs/allJobs.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HomeLoginWrapper.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentTab = 1;
  SharedPreferences prefs;

  void getTab() async {
    prefs = await SharedPreferences.getInstance();
    if(mounted)setState(() {
      _currentTab = prefs.getInt("jobTab") ?? 1;
      _tabController.index = _currentTab;
    });
  }

  @override
  void initState() {
    getTab();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _currentTab);
    super.initState();
  }

  @override
  void dispose() {
    //prefs.setInt("jobTab", 1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context, _scaffoldKey),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.funnelOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: () {}),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.searchOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: null),
//              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                      icon: Icon(
                        EvaIcons.moreVerticalOutline,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer())),
            ],
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                jobsAvailable,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: basicColor),
                  ),
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  tabs: [
                    Tab(
                      text: applied,
                    ),
                    Tab(
                      text: allJobs,
                    ),
                    Tab(
                      text: incomplete,
                    )
                  ],
                  controller: _tabController,
                ))),
        preferredSize: Size.fromHeight(100),
      ),
      body: TabBarView(
        children: [
          Center(
              child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("Assets/Images/job.png"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              "We know you are interested in jobs \nbut first build your ",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                            TextSpan(
                                text: "Profile",
                                style: TextStyle(color: basicColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper(
                                                  currentTab: 3,
                                                )),
                                        (Route<dynamic> route) => false);
                                    setState(() {});
                                  }),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          )),
          AllJobs(),
          Center(
              child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("Assets/Images/job.png"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              "I know you are interested in job \nbut first build your ",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                            TextSpan(
                                text: "Profile",
                                style: TextStyle(color: basicColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Wrapper(
                                                  currentTab: 3,
                                                )),
                                        (Route<dynamic> route) => false);
                                    setState(() {});
                                  }),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
        controller: _tabController,
      ),
    );
  }
}
