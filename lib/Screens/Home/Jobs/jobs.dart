import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../HomeLoginWrapper.dart';
import 'jobTabs.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;
  AnimationController _controller;
  int _currentTab = 1;
  final apiService = APIService();
  bool loading = true;
  dynamic jobs;

  getInfo() async {
    dynamic result = await apiService.getJobs();
    print(result);
    if (mounted)
      setState(() {
        jobs = result;
        loading = false;
        _controller.reset();
      });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    getInfo();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _currentTab);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        floatingActionButton: jobs == null
            ? null
            : jobs['profile_status'] < 384
                ? null
                : RotationTransition(
                    turns: Tween(begin: 0.0, end: 3.0).animate(_controller),
                    child: FloatingActionButton(
                      heroTag: 'jobs',
                      backgroundColor: basicColor,
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        if (!loading) {
                          _controller.forward();
                          getInfo();
                          setState(() {
                            loading = true;
                          });
                        }
                      },
                    ),
                  ),
        endDrawer: customDrawer(context, _scaffoldKey),
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
              bottom: (jobs == null || jobs.length == null)
                  ? null
                  : jobs['profile_status'] < 384
                      ? null
                      : ColoredTabBar(
                          Theme.of(context).backgroundColor,
                          TabBar(
                            indicator: UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 3.0, color: basicColor),
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
          preferredSize: (jobs == null || jobs.length == null)
              ? Size.fromHeight(55)
              : jobs['profile_status'] < 384
                  ? Size.fromHeight(55)
                  : Size.fromHeight(100),
        ),
//      body: TabBarView(
//        children: [
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("Assets/Images/job.png"),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RichText(
//                      textAlign: TextAlign.center,
//                      text: TextSpan(
//                          text:
//                              "We know you are interested in jobs,\nbut first build your ",
//                          style: TextStyle(color: Colors.black, fontSize: 18),
//                          children: [
//                            TextSpan(
//                              text: "Profile",
//                              style: TextStyle(color: basicColor),
//                              recognizer: TapGestureRecognizer()
//                                ..onTap = () {
//                                  Navigator.of(context).pushAndRemoveUntil(
//                                      MaterialPageRoute(
//                                          builder: (context) => Wrapper(
//                                                currentTab: 3,
//                                              )),
//                                      (Route<dynamic> route) => false);
//                                },
//                            ),
//                          ]),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )),
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("Assets/Images/job.png"),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RichText(
//                      textAlign: TextAlign.center,
//                      text: TextSpan(
//                          text:
//                              "We know you are interested in jobs,\nbut first build your ",
//                          style: TextStyle(color: Colors.black, fontSize: 18),
//                          children: [
//                            TextSpan(
//                              text: "Profile",
//                              style: TextStyle(color: basicColor),
//                              recognizer: TapGestureRecognizer()
//                                ..onTap = () {
//                                  Navigator.of(context).pushAndRemoveUntil(
//                                      MaterialPageRoute(
//                                          builder: (context) => Wrapper(
//                                                currentTab: 3,
//                                              )),
//                                      (Route<dynamic> route) => false);
//                                },
//                            ),
//                          ]),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )),
//          Center(
//              child: ScrollConfiguration(
//            behavior: MyBehavior(),
//            child: SingleChildScrollView(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset("Assets/Images/job.png"),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RichText(
//                      textAlign: TextAlign.center,
//                      text: TextSpan(
//                          text:
//                              "We know you are interested in jobs,\nbut first build your ",
//                          style: TextStyle(color: Colors.black, fontSize: 18),
//                          children: [
//                            TextSpan(
//                              text: "Profile",
//                              style: TextStyle(color: basicColor),
//                              recognizer: TapGestureRecognizer()
//                                ..onTap = () {
//                                  Navigator.of(context).pushAndRemoveUntil(
//                                      MaterialPageRoute(
//                                          builder: (context) => Wrapper(
//                                                currentTab: 3,
//                                              )),
//                                      (Route<dynamic> route) => false);
//                                },
//                            ),
//                          ]),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )),
//        ],
//        controller: _tabController,
//      ),
        body: loading
            ? Loading()
            : jobs == null
                ? Center(
                    child: Text('Error occurred, try again later'),
                  )
                : jobs == 'frozen'
                    ? Center(
                        child: Text(
                            "Your account is set on 'freeze' by your college"),
                      )
                    : jobs == 0
                        ? Center(
                            child: Text('Error occurred, try again later'),
                          )
                        : jobs['profile_status'] < 384
                            ? Center(
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
                                                  "We know you are interested in jobs,\nbut first build your ",
                                              style: TextStyle(fontSize: 18),
                                              children: [
                                                TextSpan(
                                                  text: "Profile",
                                                  style: TextStyle(
                                                      color: basicColor),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Wrapper(
                                                                                currentTab: 4,
                                                                              )),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                        },
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                            : jobs.length == 0
                                ? Center(
                                    child: Text('No jobs to show right now'),
                                  )
                                : TabBarView(
                                    children: [
                                      JobsTabs(
                                        alreadyAccepted:
                                            jobs['cand_accepted_job'],
                                        jobs: jobs['submitted_jobs'],
                                        profileStatus: jobs['profile_status'],
                                        tabNo: 0,
                                      ),
                                      JobsTabs(
                                        alreadyAccepted:
                                            jobs['cand_accepted_job'],
                                        jobs: jobs['all_jobs'],
                                        profileStatus: jobs['profile_status'],
                                        tabNo: 1,
                                      ),
                                      JobsTabs(
                                        alreadyAccepted:
                                            jobs['cand_accepted_job'],
                                        jobs: jobs['pending_jobs'],
                                        profileStatus: jobs['profile_status'],
                                        tabNo: 2,
                                      )
                                    ],
                                    controller: _tabController,
                                  ));
  }
}
