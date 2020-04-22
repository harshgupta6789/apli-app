import 'package:apli/Models/user.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    //final user = Provider.of<User>(context);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context, 'user'),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    EvaIcons.funnelOutline,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    EvaIcons.searchOutline,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
            ],
            title: Text(
              jobsAvailable,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
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
        preferredSize: Size.fromHeight(120),
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
