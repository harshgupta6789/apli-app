import 'package:apli/Screens/Home/Courses/courseLive.dart';
import 'package:apli/Screens/Home/Courses/courseVideo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Courses extends StatefulWidget {
  final String documentId;
  final String email;
  final String imageUrl;

  const Courses(
      {Key key, @required this.documentId, @required this.email, this.imageUrl})
      : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

double height, width;
Orientation orientation;

class _CoursesState extends State<Courses> with SingleTickerProviderStateMixin {
  //  THIS IS THE MENU FOR RECORDED COURSES , HAVING THREE TABS , HERE WE USE STREAMBUILDER TO SHOW THE CONTENT LIKE DESCRIPTION , IMAGE BANNER ETC TO THE USER //
  // THE VIDEOS ARE AGAIN TAKEN FROM FIREBASE AND ARRANGED BY TIMESTAMP THEN //

  TabController _tabController;
  int estimateTs =
      DateTime(2020, 5, 17, 16, 0, 0).millisecondsSinceEpoch; // set needed date

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: _listTabs.length);
    super.initState();
  }

  Widget _overView() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('edu_courses')
            .document(widget.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Html(
                    data: snapshot.data['overview'] ??
                        "Error While Fetching The Data",
                    onLinkTap: (url) {
                      launch(url);
                    },
                  ),
                  // Padding(
                  //     padding: EdgeInsets.only(top: 20.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: basicColor,
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       child: MaterialButton(
                  //           padding: EdgeInsets.only(left: 30, right: 30),
                  //           child: Text(
                  //             'ENROLL',
                  //             style: TextStyle(
                  //                 fontSize: 14.0,
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //           onPressed: () => null),
                  //     )),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  Widget _content() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('edu_courses')
          .document(widget.documentId)
          .collection("videos")
          .orderBy("timestamp")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
              physics: ScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                    thickness: 1.2,
                  ),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data.documents[index].data['type'] == 'Live')
                  // return Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     TikTikTimer(
                  //       initialDate: DateTime.now(),
                  //       running: true,
                  //       height: 150,
                  //       width: 150,
                  //       backgroundColor: Colors.indigo,
                  //       timerTextStyle:
                  //           TextStyle(color: Colors.white, fontSize: 20),
                  //       borderRadius: 100,
                  //       isRaised: true,
                  //       tracetime: (time) {
                  //         // print(time.getCurrentSecond);
                  //       },
                  //     ),
                  //     CountdownTimer(
                  //       endTime:
                  //           Timestamp.fromDate(DateTime(2020, 5, 17, 16, 0))
                  //               .seconds,
                  //       defaultDays: "==",
                  //       defaultHours: "--",
                  //       defaultMin: "**",
                  //       defaultSec: "++",
                  //       daysSymbol: "days",
                  //       hoursSymbol: "h ",
                  //       minSymbol: "m ",
                  //       secSymbol: "s",
                  //       daysTextStyle:
                  //           TextStyle(fontSize: 20, color: Colors.red),
                  //       hoursTextStyle:
                  //           TextStyle(fontSize: 30, color: Colors.orange),
                  //       minTextStyle:
                  //           TextStyle(fontSize: 40, color: Colors.lightBlue),
                  //       secTextStyle:
                  //           TextStyle(fontSize: 50, color: Colors.pink),
                  //       daysSymbolTextStyle:
                  //           TextStyle(fontSize: 25, color: Colors.green),
                  //       hoursSymbolTextStyle:
                  //           TextStyle(fontSize: 35, color: Colors.amberAccent),
                  //       minSymbolTextStyle:
                  //           TextStyle(fontSize: 45, color: Colors.black),
                  //       secSymbolTextStyle:
                  //           TextStyle(fontSize: 55, color: Colors.deepOrange),
                  //     )
                  //   ],
                  // );
                  return StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot2) {
                        var dateString;
                        int now = DateTime.now().millisecondsSinceEpoch;
                        int estimateTs = DateTime(2020, 5, 17, 16, 0, 0)
                            .millisecondsSinceEpoch;
                        Duration remaining =
                            Duration(milliseconds: estimateTs - now);
                        if (remaining.inDays > 0) {
                          if (remaining.inDays == 1) {
                            dateString = remaining.inDays.toString() + ' day';
                          } else
                            dateString = remaining.inDays.toString() + ' days';
                        } else {
                          if (remaining.inHours > 0) {
                            if (remaining.inHours == 1)
                              dateString =
                                  remaining.inHours.toString() + ' hour';
                            else
                              dateString =
                                  remaining.inHours.toString() + ' hours';
                          } else if (remaining.inMinutes >
                              0) if (remaining.inMinutes == 1)
                            dateString =
                                remaining.inMinutes.toString() + ' min';
                          else
                            dateString =
                                remaining.inMinutes.toString() + ' mins';
                          else if (remaining.inSeconds == 1)
                            dateString =
                                remaining.inSeconds.toString() + ' sec';
                          else
                            dateString =
                                remaining.inSeconds.toString() + ' sec';
                        }
                        if (remaining.isNegative) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: RaisedButton(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    padding:
                                        EdgeInsets.only(left: 22, right: 22),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: basicColor, width: 1.2),
                                    ),
                                    child: Text(
                                      'Start',
                                      style: TextStyle(color: basicColor),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CourseLive(
                                                    link: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['link'],
                                                  )));
                                    }),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.greenAccent.withOpacity(0.3),
                              alignment: Alignment.center,
                              child: Text(dateString + ' remaining ' ?? ""),
                            ),
                            RaisedButton(
                              onPressed: null,
                              disabledColor: Colors.grey,
                              color: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.only(left: 22, right: 22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side:
                                    BorderSide(color: Colors.grey, width: 1.2),
                              ),
                              child: Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      });
                else
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Padding(
                      //   padding: EdgeInsets.only(left: 20.0, top: 10),
                      //   child: Text(
                      //     "Introduction",
                      //     style: TextStyle(
                      //         fontSize: 18.0, fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => VideoApp(
                                      videoUrl: snapshot
                                          .data.documents[index].data['link'],
                                      title: snapshot
                                          .data.documents[index].data['title'],
                                      isCourse: true,
                                    )));
                          },
                          title: Text(
                            snapshot.data.documents[index].data['title'] ??
                                "Play Me",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Video | 2m",
                            style: TextStyle(fontSize: 12.5),
                          ),
                        ),
                      )
                    ],
                  );
              });
        } else {
          return Loading();
        }
      },
    );
  }

  Widget _certificate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            completion,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Image.asset("Assets/Images/job.png")),
          ),
        ],
      ),
    );
  }

  final List<Tab> _listTabs = [
    Tab(
      text: overview,
    ),
    Tab(
      text: content,
    ),
    Tab(
      text: certificate,
    )
  ];

  Widget _getWidget(Tab tab) {
    switch (tab.text) {
      case overview:
        return _overView();
      case content:
        return _content();
      case certificate:
        return _certificate();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        drawer: customDrawer(context, _scaffoldKey),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              //  Padding(
              // padding: EdgeInsets.only(bottom:10.0),
              // child:IconButton(
              //     icon: Icon(
              //       EvaIcons.funnelOutline,
              //       color: Colors.white,
              //     ),
              //     onPressed: null)),
              //  Padding(
              // padding: EdgeInsets.only(bottom:10.0),
              // child:IconButton(
              //     icon: Icon(
              //       EvaIcons.searchOutline,
              //       color: Colors.white,
              //     ),
              //     onPressed: null)),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                    icon: Icon(
                      EvaIcons.menuOutline,
                      color: Colors.white,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openDrawer()),
              )
            ],
            leading: Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context)),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                courses,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.02,
                        left: orientation == Orientation.portrait
                            ? width * 0.05
                            : 100,
                        right: orientation == Orientation.portrait
                            ? width * 0.05
                            : 100),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: widget.imageUrl == null
                                    ? Image.asset(
                                        "Assets/Images/course.png",
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: widget.imageUrl,
                                        placeholder: (context, url) =>
                                            Loading(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: orientation == Orientation.portrait ? 30 : 100,
                        top: 20.0,
                        bottom: 20),
                    child: Text("What's Inside:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ),
                  Container(
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: basicColor,
                        unselectedLabelColor: Colors.grey,
                        labelColor: basicColor,
                        tabs: _listTabs),
                  ),
                  SizedBox(
                    height: height * 0.83,
                    child: TabBarView(
                      controller: _tabController,
                      children: _listTabs.map((Tab tab) {
                        return _getWidget(tab);
                      }).toList(),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
