import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../HomeLoginWrapper.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.funnelOutline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Wrapper(
                                    currentTab: 3,
                                  )),
                          (Route<dynamic> route) => false);
                      setState(() {});
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.searchOutline,
                      color: Colors.white,
                    ),
                    onPressed: null),
              ),
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
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 5.0, color: basicColor),
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
        preferredSize: Size.fromHeight(105),
      ),
      body: TabBarView(
        children: [
          Center(child: Image.asset("Assets/Images/job.png")),
          Center(child: Image.asset("Assets/Images/job.png")),
          Center(child: Image.asset("Assets/Images/job.png")),
        ],
        controller: _tabController,
      ),
    );
  }
}
