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
List<List<bool>> savedJobsShown = [[], [], []];
var tempGlobalJobs;
Map companies = {}, locations = {};
Map type = {};
Map bookmarked = {'Saved': false};

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
  dynamic jobs;
  bool didFilter = false;
  List filterMenu = ['Type', 'Bookmarked'];
  List sortMenu = ['Company', 'Location'];

  void addFilters(List jobList) {
    if (jobList != null) {
      for (int i = 0; i < jobList.length; i++) {
        if (!companies.containsKey(jobList[i]['organisation'])) {
          companies[jobList[i]['organisation']] = false;
        }
        if (!locations.containsKey(jobList[i]['location'])) {
          locations[jobList[i]['location']] = false;
        }
        if (!type.containsKey(jobList[i]['job_type'])) {
          type[jobList[i]['job_type']] = false;
        }
      }
    }
  }

  void filterStuff(Map comp, Map temptype, Map loc, Map book) {
    setState(() {
      didFilter = true;
      submittedFilter = [];
      allFilter = [];
      incompleteFilter = [];
    });

    if (temptype != null) {
      temptype.forEach((key, value) {
        type[key] = value;
      });
      type.forEach((key, value) {
        for (var map in submittedJob) {
          if (map['job_type'] == key) {
            if (type[map['job_type']] == true) submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['job_type'] == key.toString()) if (type[map['job_type']] ==
              true) incompleteFilter.add(map);
        }
        for (var map in allJob) {
          if (map['job_type'] == key.toString()) if (type[map['job_type']] ==
              true) allFilter.add(map);
        }
      });
      setState(() {});
    } else if (comp != null) {
      comp.forEach((key, value) {
        companies[key] = value;
      });
      companies.forEach((key, value) {
        for (var map in submittedJob) {
          if (map['organisation'] == key) {
            if (companies[map['organisation']] == true)
              submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['organisation'] == key) if (companies[map['organisation']] ==
              true) incompleteFilter.add(map);
        }
        for (var map in allJob) {
          if (map['organisation'] == key) if (companies[map['organisation']] ==
              true) allFilter.add(map);
        }
      });
      setState(() {});
    } else if (loc != null) {
      loc.forEach((key, value) {
        locations[key] = value;
      });
      locations.forEach((key, value) {
        for (var map in submittedJob) {
          if (map['location'] == key) {
            if (locations[map['location']] == true) submittedFilter.add(map);
          }
        }
        for (var map in incompleteJob) {
          if (map['location'] == key) if (locations[map['location']] == true)
            incompleteFilter.add(map);
        }
        for (var map in allJob) {
          if (map['location'] == key) if (locations[map['location']] == true)
            allFilter.add(map);
        }
      });
      setState(() {});
    } else if (book != null) {
      book.forEach((key, value) {
        bookmarked[key] = value;
      });
      bookmarked.forEach((key, value) {
        for (int i = 0; i < savedJobs[0].length; i++) {
          if (true) {
            submittedFilter.add(submittedJob[i]);
          }
        }
        for (int i = 0; i < savedJobs[1].length; i++) {
          if (savedJobs[1][i] == value) {
            allFilter.add(allJob[i]);
          }
        }
        for (int i = 0; i < savedJobs[2].length; i++) {
          if (true) {
            incompleteFilter.add(incompleteJob[i]);
          }
        }
      });
      setState(() {});
    } else if (comp == null &&
        loc == null &&
        temptype == null &&
        book == null) {
      savedJobsShown = [[], [], []];
      for (int i = 0; i < savedJobs[0].length; i++) {
        savedJobsShown[0].add(true);
      }
      for (int i = 0; i < savedJobs[1].length; i++) {
        savedJobsShown[1].add(true);
      }
      for (int i = 0; i < savedJobs[2].length; i++) {
        savedJobsShown[2].add(true);
      }
      setState(() {
        didFilter = false;
        submittedJob = jobs['submitted_jobs'] ?? [];
        allJob = jobs['all_jobs'] ?? [];
        incompleteJob = jobs['pending_jobs'] ?? [];
        submittedFilter = [];
        allFilter = [];
        incompleteFilter = [];
        locations.forEach((key, value) {
          locations[key] = false;
        });
        companies.forEach((key, value) {
          companies[key] = false;
        });
        bookmarked.forEach((key, value) {
          bookmarked[key] = false;
        });
        type.forEach((key, value) {
          type[key] = false;
        });
        for (int i = 0; i < submittedJob.length; i++) {
          submittedFilter.add(submittedJob[i]);
        }
        for (int i = 0; i < allJob.length; i++) {
          allFilter.add(allJob[i]);
        }
        for (int i = 0; i < incompleteJob.length; i++) {
          incompleteFilter.add(incompleteJob[i]);
        }
      });
    }
    for (int i = 0; i < submittedJob.length; i++) {
      bool istrue = false;
      for (int j = 0; j < submittedFilter.length; j++) {
        if (submittedJob[i]['job_id'] == submittedFilter[j]['job_id']) {
          istrue = true;
          break;
        }
      }
      if (istrue == false)
        savedJobsShown[0][i] = false;
      else
        savedJobsShown[0][i] = true;
    }
    for (int i = 0; i < incompleteJob.length; i++) {
      bool istrue = false;
      for (int j = 0; j < incompleteFilter.length; j++) {
        if (incompleteJob[i]['job_id'] == incompleteFilter[j]['job_id']) {
          istrue = true;
          break;
        }
      }
      if (istrue == false)
        savedJobsShown[2][i] = false;
      else
        savedJobsShown[2][i] = true;
    }
    for (int i = 0; i < allJob.length; i++) {
      bool istrue = false;
      for (int j = 0; j < allFilter.length; j++) {
        if (allJob[i]['job_id'] == allFilter[j]['job_id']) {
          istrue = true;
          break;
        }
      }
      if (istrue == false)
        savedJobsShown[1][i] = false;
      else
        savedJobsShown[1][i] = true;
    }
    setState(() {});
  }

  getInfo() async {
    dynamic result = await apiService.getJobs();
    print(result['pending_jobs'][0]);
    tempGlobalJobs = result;
    if (mounted)
      setState(() {
        didFilter = false;
        submittedFilter = [];
        companies = {};
        locations = {};
        type = {};
        bookmarked = {'Saved': false};
        allFilter = [];
        incompleteFilter = [];
        jobs = result;
        if (jobs != null && jobs != 'frozen') {
          savedJobs = [[], [], []];
          savedJobsShown = [[], [], []];
          for (int i = 0; i < (jobs['submitted_jobs'] ?? []).length; i++) {
            savedJobs[0].add(jobs['submitted_jobs'][i]['is_saved'] ?? false);
            savedJobsShown[0].add(true);
          }
          for (int i = 0; i < (jobs['all_jobs'] ?? []).length; i++) {
            savedJobs[1].add(jobs['all_jobs'][i]['is_saved'] ?? false);
            savedJobsShown[1].add(true);
          }
          for (int i = 0; i < (jobs['pending_jobs'] ?? []).length; i++) {
            savedJobs[2].add(jobs['pending_jobs'][i]['is_saved'] ?? false);
            savedJobsShown[2].add(true);
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
                (jobs == null)
                    ? SizedBox()
                    : jobs['profile_status'] < 384
                        ? SizedBox()
                        : Visibility(
                            visible: !loading,
                            child: Padding(
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
                                        builder:
                                            (context) => StatefulBuilder(
                                                    builder:
                                                        (context2, setState) {
                                                  return Scaffold(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    body: AlertDialog(
                                                      title: new Text(
                                                        'Filter By',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: Container(
                                                        height: 300,
                                                        width: 300,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              dense: true,
                                                              title: Text(
                                                                '${filterMenu[index]}',
                                                              ),
                                                              trailing: IconButton(
                                                                  icon: Icon(
                                                                      EvaIcons
                                                                          .arrowIosForward),
                                                                  onPressed:
                                                                      null),
                                                              onTap: () async {
                                                                //Navigator.pop(context);
                                                                dynamic x =
                                                                    await showDialog(
                                                                        barrierDismissible:
                                                                            true,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return MyDialogContent(
                                                                            typeFilter:
                                                                                '${filterMenu[index]}',
                                                                            companies:
                                                                                companies,
                                                                            locations:
                                                                                locations,
                                                                            type:
                                                                                type,
                                                                            bookmark:
                                                                                bookmarked,
                                                                          );
                                                                        });

                                                                if (x != null) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop([
                                                                    x,
                                                                    '${filterMenu[index]}'
                                                                  ]);
                                                                }
                                                              },
                                                              subtitle: Divider(
                                                                  thickness: 2),
                                                            );
                                                          },
                                                          itemCount:
                                                              filterMenu.length,
                                                        ),
                                                      ),
                                                      actions: [
                                                        Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 20.0,
                                                                    right: 20.0,
                                                                    top: 30.0,
                                                                    bottom:
                                                                        20.0),
                                                                child:
                                                                    RaisedButton(
                                                                        color:
                                                                            basicColor,
                                                                        elevation:
                                                                            0,
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                30,
                                                                            right:
                                                                                30),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                          side: BorderSide(
                                                                              color: basicColor,
                                                                              width: 1.2),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          savedJobsShown =
                                                                              [
                                                                            [],
                                                                            [],
                                                                            []
                                                                          ];
                                                                          for (int i = 0;
                                                                              i < savedJobs[0].length;
                                                                              i++) {
                                                                            savedJobsShown[0].add(true);
                                                                          }
                                                                          for (int i = 0;
                                                                              i < savedJobs[1].length;
                                                                              i++) {
                                                                            savedJobsShown[1].add(true);
                                                                          }
                                                                          for (int i = 0;
                                                                              i < savedJobs[2].length;
                                                                              i++) {
                                                                            savedJobsShown[2].add(true);
                                                                          }
                                                                          locations.forEach((key,
                                                                              value) {
                                                                            locations[key] =
                                                                                false;
                                                                          });
                                                                          companies.forEach((key,
                                                                              value) {
                                                                            companies[key] =
                                                                                false;
                                                                          });
                                                                          bookmarked.forEach((key,
                                                                              value) {
                                                                            bookmarked[key] =
                                                                                false;
                                                                          });
                                                                          type.forEach((key,
                                                                              value) {
                                                                            type[key] =
                                                                                false;
                                                                          });
                                                                          didFilter =
                                                                              false;
                                                                          submittedJob =
                                                                              jobs['submitted_jobs'] ?? [];
                                                                          allJob =
                                                                              jobs['all_jobs'] ?? [];
                                                                          incompleteJob =
                                                                              jobs['pending_jobs'] ?? [];
                                                                          submittedFilter =
                                                                              [];
                                                                          allFilter =
                                                                              [];
                                                                          incompleteFilter =
                                                                              [];
                                                                          for (int i = 0;
                                                                              i < submittedJob.length;
                                                                              i++) {
                                                                            submittedFilter.add(submittedJob[i]);
                                                                          }
                                                                          for (int i = 0;
                                                                              i < allJob.length;
                                                                              i++) {
                                                                            allFilter.add(allJob[i]);
                                                                          }
                                                                          for (int i = 0;
                                                                              i < incompleteJob.length;
                                                                              i++) {
                                                                            incompleteFilter.add(incompleteJob[i]);
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                          Navigator.of(context)
                                                                              .pop(null);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Clear Filters',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )))),
                                                      ],
                                                    ),
                                                  );
                                                }));
                                    if (list != null) {
                                      if (list[1] == 'Company') {
                                        filterStuff(list[0], null, null, null);
                                      } else if (list[1] == 'Location') {
                                        filterStuff(null, null, list[0], null);
                                      } else if (list[1] == 'Type') {
                                        filterStuff(null, list[0], null, null);
                                      } else if (list[1] == 'Bookmarked') {
                                        filterStuff(null, null, null, list[0]);
                                      }
                                    } else {
                                      setState(() {});
                                    }
                                  }),
                            ),
                          ),
                (jobs == null)
                    ? SizedBox()
                    : jobs['profile_status'] < 384
                        ? SizedBox()
                        : Visibility(
                            visible: !loading,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.sort,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      dynamic list = await showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder:
                                              (context) => StatefulBuilder(
                                                      builder:
                                                          (context2, setState) {
                                                    return Scaffold(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      body: AlertDialog(
                                                        title: new Text(
                                                          'Sort By',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: Container(
                                                          height: 300,
                                                          width: 300,
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                dense: true,
                                                                title: Text(
                                                                  '${sortMenu[index]}',
                                                                ),
                                                                trailing: IconButton(
                                                                    icon: Icon(
                                                                        EvaIcons
                                                                            .arrowIosForward),
                                                                    onPressed:
                                                                        null),
                                                                onTap:
                                                                    () async {
                                                                  //Navigator.pop(context);
                                                                  dynamic x =
                                                                      await showDialog(
                                                                          barrierDismissible:
                                                                              true,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return MyDialogContent(
                                                                              typeFilter: '${sortMenu[index]}',
                                                                              companies: companies,
                                                                              locations: locations,
                                                                              type: type,
                                                                              bookmark: bookmarked,
                                                                            );
                                                                          });

                                                                  if (x !=
                                                                      null) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop([
                                                                      x,
                                                                      '${sortMenu[index]}'
                                                                    ]);
                                                                  }
                                                                },
                                                                subtitle: Divider(
                                                                    thickness:
                                                                        2),
                                                              );
                                                            },
                                                            itemCount:
                                                                sortMenu.length,
                                                          ),
                                                        ),
                                                        actions: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          20.0,
                                                                      right:
                                                                          20.0,
                                                                      top: 30.0,
                                                                      bottom:
                                                                          20.0),
                                                                  child: RaisedButton(
                                                                      color: basicColor,
                                                                      elevation: 0,
                                                                      padding: EdgeInsets.only(left: 30, right: 30),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        side: BorderSide(
                                                                            color:
                                                                                basicColor,
                                                                            width:
                                                                                1.2),
                                                                      ),
                                                                      onPressed: () {
                                                                        savedJobsShown =
                                                                            [
                                                                          [],
                                                                          [],
                                                                          []
                                                                        ];
                                                                        for (int i =
                                                                                0;
                                                                            i < savedJobs[0].length;
                                                                            i++) {
                                                                          savedJobsShown[0]
                                                                              .add(true);
                                                                        }
                                                                        for (int i =
                                                                                0;
                                                                            i < savedJobs[1].length;
                                                                            i++) {
                                                                          savedJobsShown[1]
                                                                              .add(true);
                                                                        }
                                                                        for (int i =
                                                                                0;
                                                                            i < savedJobs[2].length;
                                                                            i++) {
                                                                          savedJobsShown[2]
                                                                              .add(true);
                                                                        }
                                                                        locations.forEach((key,
                                                                            value) {
                                                                          locations[key] =
                                                                              false;
                                                                        });
                                                                        companies.forEach((key,
                                                                            value) {
                                                                          companies[key] =
                                                                              false;
                                                                        });
                                                                        bookmarked.forEach((key,
                                                                            value) {
                                                                          bookmarked[key] =
                                                                              false;
                                                                        });
                                                                        type.forEach((key,
                                                                            value) {
                                                                          type[key] =
                                                                              false;
                                                                        });
                                                                        didFilter =
                                                                            false;
                                                                        submittedJob =
                                                                            jobs['submitted_jobs'] ??
                                                                                [];
                                                                        allJob =
                                                                            jobs['all_jobs'] ??
                                                                                [];
                                                                        incompleteJob =
                                                                            jobs['pending_jobs'] ??
                                                                                [];
                                                                        submittedFilter =
                                                                            [];
                                                                        allFilter =
                                                                            [];
                                                                        incompleteFilter =
                                                                            [];
                                                                        for (int i =
                                                                                0;
                                                                            i < submittedJob.length;
                                                                            i++) {
                                                                          submittedFilter
                                                                              .add(submittedJob[i]);
                                                                        }
                                                                        for (int i =
                                                                                0;
                                                                            i < allJob.length;
                                                                            i++) {
                                                                          allFilter
                                                                              .add(allJob[i]);
                                                                        }
                                                                        for (int i =
                                                                                0;
                                                                            i < incompleteJob.length;
                                                                            i++) {
                                                                          incompleteFilter
                                                                              .add(incompleteJob[i]);
                                                                        }
                                                                        setState(
                                                                            () {});
                                                                        Navigator.of(context)
                                                                            .pop(null);
                                                                      },
                                                                      child: Text(
                                                                        'Clear Filters',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )))),
                                                        ],
                                                      ),
                                                    );
                                                  }));
                                      if (list != null) {
                                        if (list[1] == 'Company') {
                                          filterStuff(
                                              list[0], null, null, null);
                                        } else if (list[1] == 'Location') {
                                          filterStuff(
                                              null, null, list[0], null);
                                        } else if (list[1] == 'Type') {
                                          filterStuff(
                                              null, list[0], null, null);
                                        } else if (list[1] == 'Bookmarked') {
                                          filterStuff(
                                              null, null, null, list[0]);
                                        }
                                      } else {
                                        setState(() {});
                                      }
                                    })))
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
  final Map companies;
  final Map locations;
  final Map type;
  final Map bookmark;

  MyDialogContent(
      {Key key,
      this.typeFilter,
      this.companies,
      this.locations,
      this.type,
      this.bookmark})
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
  Map bookmarkChecked = {};
  void init() {
    for (var temp in widget.companies.keys.toList()) {
      compChecked[temp] = widget.companies[temp];
    }
    for (var temp in widget.bookmark.keys.toList()) {
      bookmarkChecked[temp] = widget.bookmark[temp];
    }
    for (var temp in widget.type.keys.toList()) {
      typeChecked[temp] = widget.type[temp];
    }
    for (var temp in widget.locations.keys.toList()) {
      locationChecked[temp] = widget.locations[temp];
    }
  }

  Widget filterDialog(String filter, BuildContext buildContext) {
    switch (filter) {
      case 'Company':
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (buildContext, index) {
            return CheckboxListTile(
              checkColor: basicColor,
              title: Text(
                '${widget.companies.keys.toList()[index].toString().toUpperCase()}',
              ),
              value: compChecked['${widget.companies.keys.toList()[index]}'],
              onChanged: (bool value) {
                setState(() {
                  compChecked['${widget.companies.keys.toList()[index]}'] =
                      value;
                });
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
                '${widget.type.keys.toList()[index].toString().toUpperCase()}',
              ),
              value: typeChecked['${widget.type.keys.toList()[index]}'],
              onChanged: (bool value) {
                setState(() {
                  typeChecked['${widget.type.keys.toList()[index]}'] = value;
                });
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
                '${(widget.locations.keys.toList()[index]).toString().toUpperCase()}',
              ),
              value:
                  locationChecked['${widget.locations.keys.toList()[index]}'],
              onChanged: (bool value) {
                setState(() {
                  locationChecked['${widget.locations.keys.toList()[index]}'] =
                      value;
                });
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
                '${widget.bookmark.keys.toList()[index].toString().toUpperCase()}',
              ),
              value: bookmarkChecked['${widget.bookmark.keys.toList()[index]}'],
              onChanged: (bool value) {
                setState(() {
                  bookmarkChecked['${widget.bookmark.keys.toList()[index]}'] =
                      value;
                });
              },
            );
          },
          itemCount: widget.bookmark.length,
        );
        break;
      default:
        return Container();
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
                        Navigator.pop(context, compChecked);
                      } else if (widget.typeFilter == 'Location') {
                        Navigator.pop(context, locationChecked);
                      } else if (widget.typeFilter == 'Type') {
                        Navigator.pop(context, typeChecked);
                      } else if (widget.typeFilter == 'Bookmarked') {
                        Navigator.pop(context, bookmarkChecked);
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
