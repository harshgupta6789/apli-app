import 'package:apli/Screens/Home/MockJobs/staticDetails.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MockJobs extends StatefulWidget {
  @override
  _MockJobsState createState() => _MockJobsState();
}

class _MockJobsState extends State<MockJobs>
    with SingleTickerProviderStateMixin {
  final _APIService = APIService();
  bool loading = true;
  dynamic mockJobs;
  double height, width, scale;
  AnimationController _controller;
  getInfo() async {
    dynamic result = await _APIService.getMockJobs();
    if (mounted)
      setState(() {
        mockJobs = result;
        loading = false;
      });
  }

  Widget button(String package, List incomplete) {
    if (incomplete == null || incomplete == []) {
      return null;
    } else if (incomplete.contains(package)) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0),
              child: RaisedButton(
                  color: basicColor,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'Resume',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MockCompanyInstructions(pack: package)));
                  })));
    } else {
      return null;
    }
  }

    Widget tickmark(String package, List submitted) {
    if (submitted == null || submitted == []) {
      return Container(height: 5, width: 5,);
    } else if (submitted.contains(package)) {
     return Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0),
              child: Icon(EvaIcons.checkmarkOutline , color: basicColor,));
    } else {
      return Container(height: 5,width: 5,);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width >= 360) {
      scale = 1.0;
    } else {
      scale = 0.7;
    }
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Visibility(
          visible: !loading,
          child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: FloatingActionButton(
                heroTag: 'avb',
                backgroundColor: basicColor,
                child: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  getInfo();
                },
              )),
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
                mockJob,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(55),
        ),
        body: loading
            ? Loading()
            : mockJobs == null
                ? Center(
                    child: Text('Error occurred, try again later'),
                  )
                : mockJobs == 'frozen'
                    ? Center(
                        child: Text(
                            "Your account is set on 'freeze' by your college"),
                      )
                    : mockJobs == 0
                        ? Center(
                            child: Text('Error occurred, try again later'),
                          )
                        : ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 15, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                "Assets/Images/mock.png",
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 20, 15, 10),
                                            child: AutoSizeText(
                                              "Mock Interviews",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: (mockJobs[
                                                        "interviewPackages"] ??
                                                    [])
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 1),
                                                child: Card(
                                                  elevation: 0.2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black54)),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10 * scale,
                                                          bottom: 13 * scale),
                                                      child: ListTile(
                                                        onTap: () {
                                                          List mockTaken = mockJobs[
                                                                  'mockTaken'] ??
                                                              [];
                                                          List mockSubmitted =
                                                              mockJobs[
                                                                      'mockSubmitted'] ??
                                                                  [];
                                                          if (mockTaken.contains(
                                                              mockJobs[
                                                                      'interviewPackages']
                                                                  [index])) {
                                                          } else if (mockSubmitted
                                                              .contains(mockJobs[
                                                                      'interviewPackages']
                                                                  [index])) {
                                                            showToast(
                                                                "Already Taken!",
                                                                context);
                                                          } else {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        RandomDetails(
                                                                            package:
                                                                                mockJobs['interviewPackages'][index])));
                                                          }
                                                        },
                                                        dense: true,
                                                        title: AutoSizeText(
                                                          mockJobs['interviewPackages']
                                                                  [index] ??
                                                              "Interview 0",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        subtitle: button(
                                                            mockJobs[
                                                                    'interviewPackages']
                                                                [index],
                                                            mockJobs[
                                                                'mockTaken']),
                                                        trailing: tickmark(mockJobs[
                                                                    'interviewPackages']
                                                                [index],
                                                            mockJobs[
                                                                'mockSubmitted']),
                                                      )),
                                                ),
                                              );
                                            }),
                                      ],
                                    ))),
                          ));
  }
}
