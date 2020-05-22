import 'package:apli/Screens/Home/Courses/courseLive.dart';
import 'package:apli/Screens/Home/Courses/courseVideo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CoursesLive extends StatefulWidget {
  final String documentId;
  final String email;
  final String imageUrl;
  final String title;
  final bool didEnd;

  const CoursesLive(
      {Key key,
      @required this.documentId,
      @required this.email,
      this.imageUrl,
      this.title,
      this.didEnd})
      : super(key: key);

  @override
  _CoursesLiveState createState() => _CoursesLiveState();
}

double height, width;
Orientation orientation;

class _CoursesLiveState extends State<CoursesLive>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
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
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('edu_courses')
                  .document(widget.documentId)
                  .collection("videos")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return SingleChildScrollView(
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: widget.imageUrl == null
                                            ? Image.asset(
                                                "Assets/Images/course.png",
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: widget.imageUrl,
                                                placeholder: (context, url) =>
                                                    Loading(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: orientation == Orientation.portrait
                                    ? 30
                                    : 100,
                                top: 20.0,
                                bottom: 10),
                            child: Text(widget.title ?? "No Title Specified",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                          ),
                          widget.didEnd
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Align(
                                    child: Container(
                                      height: 50,
                                      color: Colors.redAccent.withOpacity(0.3),
                                      alignment: Alignment.center,
                                      child: Text("Live Webinar Has Ended!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18)),
                                    ),
                                  ),
                                )
                              : StreamBuilder(
                                  stream: Stream.periodic(
                                      Duration(seconds: 1), (i) => i),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot2) {
                                    var dateString;
                                    var dateToStart;
                                    int now =
                                        DateTime.now().millisecondsSinceEpoch;
                                    if (snapshot.data.documents[0]
                                            ['timestamp'] !=
                                        null) {
                                      dateToStart = snapshot
                                          .data
                                          .documents[0]['timestamp']
                                          .millisecondsSinceEpoch;
                                    }

                                    int estimateTs = dateToStart ??
                                        DateTime.now().millisecondsSinceEpoch -
                                            100;
                                    Duration remaining = Duration(
                                        milliseconds: estimateTs - now);
                                    if (remaining.inDays > 0) {
                                      if (remaining.inDays == 1) {
                                        dateString =
                                            remaining.inDays.toString() +
                                                ' day';
                                      } else
                                        dateString =
                                            remaining.inDays.toString() +
                                                ' days';
                                    } else {
                                      if (remaining.inHours > 0) {
                                        if (remaining.inHours == 1)
                                          dateString =
                                              remaining.inHours.toString() +
                                                  ' hour';
                                        else
                                          dateString =
                                              remaining.inHours.toString() +
                                                  ' hours';
                                      } else if (remaining.inMinutes >
                                          0) if (remaining.inMinutes == 1)
                                        dateString =
                                            remaining.inMinutes.toString() +
                                                ' min';
                                      else
                                        dateString =
                                            remaining.inMinutes.toString() +
                                                ' mins';
                                      else if (remaining.inSeconds == 1)
                                        dateString =
                                            remaining.inSeconds.toString() +
                                                ' sec';
                                      else
                                        dateString =
                                            remaining.inSeconds.toString() +
                                                ' sec';
                                    }
                                    if (remaining.isNegative) {
                                      return Column(
                                        children: <Widget>[
                                          Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                              child: RaisedButton(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: basicColor,
                                                        width: 1.2),
                                                  ),
                                                  child: Text(
                                                    'Start',
                                                    style: TextStyle(
                                                        color: basicColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    CourseLive(
                                                                      link: snapshot
                                                                          .data
                                                                          .documents[0]['link'],
                                                                    )));
                                                  }),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                          color: Colors.greenAccent
                                              .withOpacity(0.3),
                                          alignment: Alignment.center,
                                          child: Text(
                                              dateString + ' remaining ' ?? ""),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: RaisedButton(
                                            disabledColor: Colors.grey,
                                            color: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.2),
                                            ),
                                            child: Text(
                                              'Start',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: orientation == Orientation.portrait
                                      ? 30
                                      : 100,
                                  top: 10.0,
                                  bottom: 20,
                                  right: 20.0),
                              child: _overView())
                        ]),
                  );
                return Loading();
              }),
        ));
  }
}
