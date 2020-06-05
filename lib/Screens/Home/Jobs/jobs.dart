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

List<List<bool>> savedJobs = [[], [], []];
var tempGlobalJobs;

class _JobsState extends State<Jobs>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;
  AnimationController _controller;
  int _currentTab = 1;
  List submittedJob = [], allJob = [], incompleteJob = [];
  List submittedFilter = [], allFilter = [], incompleteFilter = [];
  final apiService = APIService();
  bool loading = true;
  List companies = [], locations = [];
  List type = ['Internship', 'Job'];
  dynamic jobs;
  bool didFilter = false;
  List filterMenu = ['Company', 'Type', 'Location', 'Bookmarked'];

  void addFilters(List jobList) {
    if (jobList != null) {
      //print("gg00");
      for (int i = 0; i < jobList.length; i++) {
        //print(jobList[i]['location']);
        if (!companies.contains(jobList[i]['organisation'])) {
          companies.add(jobList[i]['organisation']);
        } else if (!locations.contains(jobList[i]['location'])) {
          print(jobList[i]['location']);
          locations.add(jobList[i]['location']);
        } else {}
      }
    }
  }

  void filterStuff(List comp, List type, List loc) {
    setState(() {
      didFilter = true;
      submittedFilter = [];
      allFilter = [];
      incompleteFilter = [];
    });

    if (comp == null && loc == null) {
      for (int i = 0; i < type.length; i++) {
        for (var map in submittedJob) {
          if (map['job_type'] == type[i]) {
            submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['job_type'] == type[i]) {
            incompleteFilter.add(map);
          }
        }
        for (var map in allJob) {
          if (map['job_type'] == type[i]) {
            allFilter.add(map);
          }
        }
        setState(() {});
      }
    } else if (type == null && loc == null) {
      for (int i = 0; i < comp.length; i++) {
        for (var map in submittedJob) {
          if (map['organisation'] == comp[i]) {
            submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['organisation'] == comp[i]) {
            incompleteFilter.add(map);
          }
        }
        for (var map in allJob) {
          if (map['organisation'] == comp[i]) {
            allFilter.add(map);
          }
        }
        setState(() {});
        // print(allFilter);
        // // print(incompleteFilter);
      }
      setState(() {});
    } else if (type == null && comp == null) {
      for (int i = 0; i < loc.length; i++) {
        print(allFilter.toString() + "all");
        print(submittedFilter.toString() + "submitted");
        print(incompleteFilter.toString() + "inc");
        for (var map in submittedJob) {
          if (map['location'] == loc[i]) {
            submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['location'] == loc[i]) {
            incompleteFilter.add(map);
            print("hi");
          }
        }
        for (var map in allJob) {
          if (map['location'] == loc[i]) {
            allFilter.add(map);
            print("hi");
          }
        }
        print(allFilter.isEmpty);
        print(submittedFilter.isEmpty);
        print(incompleteFilter.isEmpty);
        setState(() {});
      }
    } else if (comp == null && loc == null && type == null) {
      print("f");
      setState(() {
        didFilter = false;
        submittedFilter = submittedJob;
        allFilter = allJob;
        incompleteFilter = incompleteJob;
      });
    }
    // if (jobList != null) {
    //   for (int i = 0; i < jobList.length; i++) {
    //     if (!companies.contains(jobList[i]['organisation'])) {
    //       companies.add(jobList[i]['organisation']);
    //     } else if (!locations.contains(jobList[i]['location'])) {
    //       locations.add(jobList[i]['location']);
    //     } else {}
    //   }
    // }
  }

  getInfo() async {
    dynamic result = await apiService.getJobs();
    //print(result['pending_jobs']);
    tempGlobalJobs = result;
    if (mounted)
      setState(() {
        submittedFilter = [];
        companies = [];
        locations = [];
        allFilter = [];
        incompleteFilter = [];
        jobs = result;
        if (jobs != null && jobs != 'frozen') {
          savedJobs = [[], [], []];
          for (int i = 0; i < (jobs['submitted_jobs'] ?? []).length; i++) {
            savedJobs[0].add(jobs['submitted_jobs'][i]['is_saved'] ?? false);
          }
          for (int i = 0; i < (jobs['all_jobs'] ?? []).length; i++) {
            savedJobs[1].add(jobs['all_jobs'][i]['is_saved'] ?? false);
          }
          for (int i = 0; i < (jobs['pending_jobs'] ?? []).length; i++) {
            savedJobs[2].add(jobs['pending_jobs'][i]['is_saved'] ?? false);
          }
          submittedJob = jobs['submitted_jobs'] ?? [];
          allJob = jobs['all_jobs'] ?? [];
          incompleteJob = jobs['pending_jobs'] ?? [];
          addFilters(submittedJob);
          addFilters(allJob);
          addFilters(incompleteJob);
        }
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
        drawer: customDrawer(context, _scaffoldKey),
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
                      onPressed: () async {
                        dynamic list = await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context2, setState) {
                                  return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: AlertDialog(
                                      title: new Text(
                                        'Filter By',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              dense: true,
                                              title: Text(
                                                '${filterMenu[index]}',
                                              ),
                                              trailing: IconButton(
                                                  icon: Icon(
                                                      EvaIcons.arrowIosForward),
                                                  onPressed: null),
                                              onTap: () async {
                                                //Navigator.pop(context);
                                                dynamic x = await showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return MyDialogContent(
                                                        typeFilter:
                                                            '${filterMenu[index]}',
                                                        companies: companies,
                                                        locations: locations,
                                                        type: type,
                                                      );
                                                    });

                                                if (x != null) {
                                                  Navigator.of(context).pop([
                                                    x,
                                                    '${filterMenu[index]}'
                                                  ]);
                                                }
                                              },
                                              subtitle: Divider(thickness: 2),
                                            );
                                          },
                                          itemCount: filterMenu.length,
                                        ),
                                      ),
                                      actions: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    top: 30.0,
                                                    bottom: 20.0),
                                                child: RaisedButton(
                                                    color: basicColor,
                                                    elevation: 0,
                                                    padding: EdgeInsets.only(
                                                        left: 30, right: 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      side: BorderSide(
                                                          color: basicColor,
                                                          width: 1.2),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        didFilter = false;
                                                        allFilter = [];
                                                        submittedFilter = [];
                                                        incompleteFilter = [];
                                                      });
                                                      Navigator.of(context)
                                                          .pop(null);
                                                    },
                                                    child: Text(
                                                      'Clear Filters',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )))),
                                      ],
                                    ),
                                  );
                                }));
                        if (list != null) {
                          print(list);
                          if (list[1] == 'Company') {
                            filterStuff(list[0], null, null);
                          } else if (list[1] == 'Location') {
                            filterStuff(null, null, list[0]);
                          } else if (list[1] == 'Type') {
                            filterStuff(null, list[0], null);
                          }
                        } else {
                          setState(() {});
                        }
                      }),
                ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.searchOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: null),
//              ),
              ],
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
                  jobsAvailable,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              bottom: (jobs == null)
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
          preferredSize: (jobs == null)
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
                            : TabBarView(
                                children: [
                                  JobsTabs(
                                    alreadyAccepted: jobs['cand_accepted_job'],
                                    jobs: didFilter
                                        ? submittedFilter
                                        : submittedFilter.isEmpty
                                            ? submittedJob
                                            : submittedFilter,
                                    profileStatus: jobs['profile_status'],
                                    tabNo: 0,
                                  ),
                                  JobsTabs(
                                    alreadyAccepted: jobs['cand_accepted_job'],
                                    jobs: didFilter
                                        ? allFilter
                                        : allFilter.isEmpty
                                            ? allJob
                                            : allFilter,
                                    profileStatus: jobs['profile_status'],
                                    tabNo: 1,
                                  ),
                                  JobsTabs(
                                    alreadyAccepted: jobs['cand_accepted_job'],
                                    jobs: didFilter
                                        ? incompleteFilter
                                        : incompleteFilter.isEmpty
                                            ? incompleteJob
                                            : incompleteFilter,
                                    profileStatus: jobs['profile_status'],
                                    tabNo: 2,
                                  )
                                ],
                                controller: _tabController,
                              ));
  }
}

class MyDialogContent extends StatefulWidget {
  final String typeFilter;
  final List companies;
  final List locations;
  final List type;

  MyDialogContent(
      {Key key, this.typeFilter, this.companies, this.locations, this.type})
      : super(key: key);
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  TextEditingController editingController = TextEditingController();
  String val;
  var items = List<dynamic>();

  Map compChecked = {};
  Map typeChecked = {};
  Map locationChecked = {};
  void init() {
    for (var temp in widget.companies) {
      compChecked[temp] = false;
    }
    for (var temp in widget.type) {
      typeChecked[temp] = false;
    }
    for (var temp in widget.locations) {
      locationChecked[temp] = false;
    }
  }

  Widget filterDialog(String filter, BuildContext buildContext) {
    switch (filter) {
      case 'Company':
        print(compChecked);
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            return CheckboxListTile(
              checkColor: basicColor,
              title: Text(
                '${widget.companies[index]}',
              ),
              value: compChecked['${widget.companies[index]}'],
              onChanged: (bool value) {
                setState(() {
                  compChecked['${widget.companies[index]}'] = value;
                });
                //print(compChecked);
              },
            );
          },
          itemCount: widget.companies.length,
        );
        break;

      case 'Type':
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            return CheckboxListTile(
              checkColor: basicColor,
              title: Text(
                '${widget.type[index]}',
              ),
              value: typeChecked['${widget.type[index]}'],
              onChanged: (bool value) {
                setState(() {
                  typeChecked['${widget.type[index]}'] = value;
                });
                //print(compChecked);
              },
            );
          },
          itemCount: widget.type.length,
        );
        break;
      case 'Location':
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            return CheckboxListTile(
              checkColor: basicColor,
              title: Text(
                '${widget.locations[index]}',
              ),
              value: locationChecked['${widget.locations[index]}'],
              onChanged: (bool value) {
                setState(() {
                  locationChecked['${widget.locations[index]}'] = value;
                });
                //print(compChecked);
              },
            );
          },
          itemCount: widget.locations.length,
        );
        break;
      case 'Bookmarked':
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              checkColor: basicColor,
              title: Text(
                '${widget.companies[index]}',
              ),
              value: compChecked['${widget.companies[index]}'],
              onChanged: (bool value) {
                setState(() {
                  compChecked['${widget.companies[index]}'] = value;
                });
                //print(compChecked);
              },
            );
          },
          itemCount: widget.companies.length,
        );
        break;
      default:
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              dense: true,
              title: Text(
                '${widget.companies[index]}',
              ),
              trailing: IconButton(
                  icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
              onTap: () {
                Navigator.pop(context);
              },
              subtitle: Divider(thickness: 2),
            );
          },
          itemCount: widget.companies.length,
        );
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 30.0, bottom: 20.0),
                child: RaisedButton(
                    color: basicColor,
                    elevation: 0,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: basicColor, width: 1.2),
                    ),
                    onPressed: () {
                      if (widget.typeFilter == 'Company') {
                        List filtered = [];
                        compChecked.forEach((key, value) {
                          if (value == true) {
                            filtered.add(key);
                          }
                        });
                        Navigator.pop(context, filtered);
                      } else if (widget.typeFilter == 'Location') {
                        List filtered = [];
                        locationChecked.forEach((key, value) {
                          if (value == true) {
                            filtered.add(key);
                          }
                        });
                        Navigator.pop(context, filtered);
                      } else if (widget.typeFilter == 'Type') {
                        List filtered = [];
                        typeChecked.forEach((key, value) {
                          if (value == true) {
                            filtered.add(key.toString().toLowerCase());
                          }
                          print(filtered);
                        });
                        Navigator.pop(context, filtered);
                      }
                    },
                    child: Text(
                      'FILTER',
                      style: TextStyle(color: Colors.white),
                    )))),
      ],
      content: Container(
          height: 300,
          width: 300,
          child: filterDialog(widget.typeFilter, context)),
    );
  }
}
