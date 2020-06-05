import 'package:apli/Screens/Home/Profile/Video-Intro/videoIntro.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'Psychometry/psychometry.dart';
import 'Resume/resume.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
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
                profile,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            bottom: ColoredTabBar(
                Theme.of(context).backgroundColor,
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: basicColor),
                  ),
                  tabs: [
                    Tab(
                      text: videoIntro,
                    ),
                    Tab(
                      text: resume,
                    ),
                    Tab(text: psychTest)
                  ],
                  controller: _tabController,
                )),
          ),
          preferredSize: Size.fromHeight(100),
        ),
        body: TabBarView(children: [
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Padding(
//                padding: const EdgeInsets.only(bottom: 50.0),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Image.asset(
//                      "Assets/Images/profile.png",
//                      height: 300,
//                      width: 300,
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: RichText(
//                        textAlign: TextAlign.center,
//                        text: TextSpan(
//                            text: " You can start applying for\n",
//                            style: TextStyle(color: Colors.black, fontSize: 18),
//                            children: [
//                              TextSpan(
//                                  text: "Jobs",
//                                  style: TextStyle(color: basicColor),
//                                  recognizer: TapGestureRecognizer()
//                                    ..onTap = () {
//                                      Navigator.of(context).pushAndRemoveUntil(
//                                          MaterialPageRoute(
//                                              builder: (context) => Wrapper(
//                                                    currentTab: 1,
//                                                  )),
//                                          (Route<dynamic> route) => false);
//                                      setState(() {});
//                                    }),
//                              TextSpan(text: " after filling in the details.")
//                            ]),
//                      ),
//                    )
//                  ],
//                ),
//              ),
//            ),
//          )),
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Padding(
//                  padding: const EdgeInsets.only(bottom: 50.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Image.asset(
//                        "Assets/Images/profile.png",
//                        height: 300,
//                        width: 300,
//                      ),
//                      Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(
//                            "Your video intro will appear here.",
//                            style: TextStyle(fontSize: 18),
//                          ))
//                    ],
//                  )),
//            ),
//          )),
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Padding(
//                  padding: const EdgeInsets.only(bottom: 50.0),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Image.asset("Assets/Images/profile.png",
//                          height: 300, width: 300),
//                      Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(
//                            "Your test will be shown here.",
//                            style: TextStyle(fontSize: 18),
//                          ))
//                    ],
//                  )),
//            ),
//          )),
          VideoIntro(),
          Resume(),
          Psychometry(),
        ], controller: _tabController));
  }
}
