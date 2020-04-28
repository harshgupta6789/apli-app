import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../HomeLoginWrapper.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  refresh() => setState(() {});

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
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
                    new Tab(
                      text: applied,
                    ),
                    new Tab(
                      text: allJobs,
                    ),
                    new Tab(
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
              child: Padding(
            padding: EdgeInsets.only(bottom: 50.0),
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
          )),
          Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("Assets/Images/job.png"),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your jobs will be listed here.",
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ))),
          Center(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("Assets/Images/job.png"),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All caught up!",
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ))),
        ],
        controller: _tabController,
      ),
    );
  }
}
