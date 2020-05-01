import 'package:apli/Screens/Home/Courses/courseVideo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Courses extends StatefulWidget {
  final String documentId;
  final String email;

  const Courses({Key key, @required this.documentId, @required this.email})
      : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

double height, width;
Orientation orientation;

class _CoursesState extends State<Courses> with SingleTickerProviderStateMixin {
  TabController _tabController;
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Html(
                    data: snapshot.data['overview'] ??
                        "Error While Fetching The Data",
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
              separatorBuilder: (BuildContext context, int index) => Divider(
                    thickness: 1.2,
                  ),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
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
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
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
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        endDrawer: customDrawer(context, _scaffoldKey),
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
                      EvaIcons.moreVerticalOutline,
                      color: Colors.white,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
              )
            ],
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
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        left: orientation == Orientation.portrait ? 20 : 100,
                        right: orientation == Orientation.portrait ? 20 : 100),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  "Assets/Images/course.png",
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Positioned(
                            top: height * 0.15,
                            left: width * 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Trending",
                                      style: TextStyle(color: Colors.yellow)),
                                  Text("Startup 101",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Text("By Harvard",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 18,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: orientation == Orientation.portrait ? 30 : 100,
                        top: 20.0),
                    child: Text("What's Inside:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: new TabBar(
                        controller: _tabController,
                        indicatorColor: basicColor,
                        unselectedLabelColor: Colors.grey,
                        labelColor: basicColor,
                        tabs: _listTabs),
                  ),
                  new Container(
                    height: 500.0,
                    child: new TabBarView(
                      controller: _tabController,
                      children: _listTabs.map((Tab tab) {
                        return _getWidget(tab);
                      }).toList(),
                    ),
                  )
                ]),
          ),
        ));
  }
}
