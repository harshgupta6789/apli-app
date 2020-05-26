import 'package:apli/Screens/Home/Jobs/jobTabs.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:apli/Shared/loading.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

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
  final _APIService = APIService();
  bool loading = true;
  dynamic jobs;
  double angle = 0;

  getInfo() async {
    dynamic result = await _APIService.getJobs();
    if(mounted) setState(() {
      jobs = result;
      loading = false;
        angle = 0;
        _controller.reset();
      });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
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
        key: _scaffoldKey,
        floatingActionButton: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: FloatingActionButton(
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
                    : jobs == 0 ? Center(child: Text('Error occurred, try again later'),) : TabBarView(
                        children: [
                              JobsTabs(
                                alreadyAccepted: jobs['cand_accepted_job'],
                            jobs: jobs['submitted_jobs'],
                            profileStatus: jobs['profile_status'],
                            tabNo: 0,),
                          JobsTabs(
                            alreadyAccepted: jobs['cand_accepted_job'],
                            jobs: jobs['all_jobs'],
                            profileStatus: jobs['profile_status'],
                            tabNo: 1,
                          ),
                          JobsTabs(
                            alreadyAccepted: jobs['cand_accepted_job'],
                            jobs: jobs['pending_jobs'],
                            profileStatus: jobs['profile_status'],
                            tabNo: 2,
                          )
                        ],
                        controller: _tabController,
                      ));
  }
}
