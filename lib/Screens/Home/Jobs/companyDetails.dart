import 'package:apli/Screens/Home/Jobs/jobQuestions.dart';
import 'package:apli/Screens/Home/Profile/Video-Intro/videoIntro.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../HomeLoginWrapper.dart';

class CompanyProfile extends StatefulWidget {
  final Map company;
  final int status;
  final bool isApplied;

  const CompanyProfile(
      {Key key, this.company, this.status, @required this.isApplied})
      : super(key: key);

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final _APIService = APIService();
  bool loading = false, applied = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Wrapper(
                            currentTab: 2,
                          )),
                  (Route<dynamic> route) => false);
            },
            child: Scaffold(
              appBar: PreferredSize(
                child: AppBar(
                    backgroundColor: basicColor,
                    automaticallyImplyLeading: false,
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
                        "Apply",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                preferredSize: Size.fromHeight(50),
              ),
              body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 18.0, left: 10.0, right: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        onTap: () {},
                                        title: AutoSizeText(
                                          widget.company['role'] ??
                                              "Role not declared",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: basicColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                widget.company['location'] ??
                                                    "Location not declared",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              AutoSizeText(
                                                'Deadline: ' +
                                                    dateToReadableTimeConverter(
                                                        DateTime.parse(widget
                                                                    .company[
                                                                'deadline'] ??
                                                            '2020-05-26 00:00:00')),
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      widget.company['ctc'] != null
                                          ? ListTile(
                                              dense: true,
                                              title: RichText(
                                                text: TextSpan(
                                                  text: 'Jobs CTC : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: widget.company[
                                                                'ctc'] ??
                                                            "Not Specified",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['notice_period'] != null
                                          ? ListTile(
                                              dense: true,
                                              title: RichText(
                                                text: TextSpan(
                                                  text: 'Notice Period : ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: widget.company[
                                                                'notice_period'] ??
                                                            "Not Specified",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['description'] != null
                                          ? ListTile(
                                              title: AutoSizeText(
                                                "Role Description : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.company[
                                                              'description'] ??
                                                          "Not Specified",
                                                      maxLines: 999999,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['key_resp'] != null
                                          ? ListTile(
                                              title: AutoSizeText(
                                                "Key Responsibilities : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.company[
                                                              'key_resp'] ??
                                                          "Not Specified",
                                                      maxLines: 999999,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['soft_skills'] != null
                                          ? ListTile(
                                              title: AutoSizeText(
                                                "Soft Skills : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                            .company[
                                                                'soft_skills']
                                                            .length ??
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.company[
                                                                    'soft_skills']
                                                                [index] ??
                                                            "None",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['tech_skills'] != null
                                          ? ListTile(
                                              title: AutoSizeText(
                                                "Technical Skills  : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                            .company[
                                                                'tech_skills']
                                                            .length ??
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.company[
                                                                    'tech_skills']
                                                                [index] ??
                                                            "None",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            )
                                          : SizedBox(),
                                      widget.company['requirements'] != null
                                          ? ListTile(
                                              title: AutoSizeText(
                                                "Requirements : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: (widget.company[
                                                                    'requirements'] ??
                                                                [])
                                                            .length ??
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.company[
                                                                    'requirements']
                                                                [index] ??
                                                            "No specific requirements",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            )
                                          : SizedBox(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 10.0),
                                          child: RaisedButton(
                                              color:
                                                  (widget.isApplied == true ||
                                                          applied == true)
                                                      ? Colors.grey
                                                      : basicColor,
                                              elevation: 0,
                                              padding: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: (widget.isApplied ==
                                                                true ||
                                                            applied == true)
                                                        ? Colors.grey
                                                        : basicColor,
                                                    width: 1.2),
                                              ),
                                              child: Text(
                                                'APPLY NOW',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                if (applied == false) if (widget
                                                        .isApplied ==
                                                    false)
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        new AlertDialog(
                                                      title: new Text(
                                                        'Are you sure you want to apply for this job?',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                            bool videoIntro =
                                                                    true,
                                                                resume = true;
                                                            if (widget.company[
                                                                    'requirements']
                                                                .contains(
                                                                    'Video Introduction')) {
                                                              String temp =
                                                                  decimalToBinary(
                                                                          widget
                                                                              .status)
                                                                      .toString();
                                                              while (
                                                                  temp.length !=
                                                                      9) {
                                                                temp =
                                                                    '0' + temp;
                                                              }
                                                              if (temp.substring(
                                                                      7, 8) !=
                                                                  "1") if (tempProfileStatus != true)
                                                                videoIntro =
                                                                    false;
                                                              if (tempProfileStatus ==
                                                                  false) {
                                                                videoIntro =
                                                                    false;
                                                              }
                                                            }
                                                            if (widget.company[
                                                                    'requirements']
                                                                .contains('Resume')) if (widget
                                                                    .status <
                                                                384)
                                                              resume = false;
                                                            if (!videoIntro)
                                                              showToast(
                                                                  'Complete your video intro first !!!',
                                                                  context);
                                                            else if (!resume)
                                                              showToast(
                                                                  'Complete your resume first !!!',
                                                                  context);
                                                            else {
                                                              setState(() {
                                                                loading = true;
                                                              });
                                                              dynamic result =
                                                                  await _APIService
                                                                      .applyJob(
                                                                          widget
                                                                              .company['job_id']);
                                                              setState(() {
                                                                loading = false;
                                                                applied = true;
                                                              });
                                                              if (result == 1) {
                                                                if (widget
                                                                    .company[
                                                                        'requirements']
                                                                    .contains(
                                                                        'Video Interview')) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => CompanyVideo(
                                                                                job: widget.company,
                                                                              )));
                                                                } else {
                                                                  showToast(
                                                                      'Your application has been submitted',
                                                                      context);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  Wrapper(
                                                                                    currentTab: 2,
                                                                                  )),
                                                                          (Route<dynamic> route) =>
                                                                              false);
                                                                }
                                                              } else {
                                                                showToast(
                                                                    'Error occurred, try again later',
                                                                    context);
                                                                Navigator.of(
                                                                        context)
                                                                    .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Wrapper(
                                                                                  currentTab: 2,
                                                                                )),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                              }
                                                            }
                                                          },
                                                          child: new Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: new Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                              }),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}

class CompanyVideo extends StatefulWidget {
  final Map job;
  final int status;

  CompanyVideo({Key key, this.job, this.status}) : super(key: key);

  @override
  _CompanyVideoState createState() => _CompanyVideoState();
}

class _CompanyVideoState extends State<CompanyVideo> {
  double width, height, scale;
  YoutubePlayerController _controller;
  bool loading = false, isPressed = false;
  final _APIService = APIService();
  Future _fetch;

  Future<dynamic> getInfo() async {
    dynamic result = await _APIService.getCompanyIntro(widget.job['job_id']);
    print(result);
    return result;
  }

  Widget videoPlayer(String link) {
    if (link.contains("https://www.youtube.com/")) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(link),
        flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            forceHD: true,
            loop: false,
            disableDragSeek: false),
      );
      return YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        liveUIColor: basicColor,
        aspectRatio: 1 / 1,
        bottomActions: <Widget>[],
      );
    }
    return AwsomeVideoPlayer(
      link,
      playOptions: VideoPlayOptions(
        aspectRatio: 1 / 1,
        loop: false,
        autoplay: false,
      ),
      videoStyle: VideoStyle(
          videoControlBarStyle: VideoControlBarStyle(
              fullscreenIcon: SizedBox(),
              forwardIcon: SizedBox(),
              rewindIcon: SizedBox()),
          videoTopBarStyle: VideoTopBarStyle(popIcon: Container())),
    );
  }

  @override
  void initState() {
    _fetch = getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              child: AppBar(
                  backgroundColor: basicColor,
                  automaticallyImplyLeading: false,
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
                      "Apply",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              preferredSize: Size.fromHeight(50),
            ),
            body: FutureBuilder(
                future: _fetch,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.1, right: width * 0.1, top: 15),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: snapshot.data['video'] != null
                                    ? videoPlayer(snapshot.data['video'])
                                    : SizedBox(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text(
                                  snapshot.data['text'] ?? "No Info Specified",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              Align(
                                child: RaisedButton(
                                  color: basicColor,
                                  elevation: 0,
                                  padding: EdgeInsets.only(left: 40, right: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: basicColor, width: 1.2),
                                  ),
                                  child: Text(
                                    'PROCEED TO VIDEO INTERVIEW',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompanyInstructions(
                                                  job: widget.job,
                                                )));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError)
                    return Center(
                      child: Text('Error occurred, try again later'),
                    );

                  return Loading();
                }),
          );
  }
}

class CompanyInstructions extends StatefulWidget {
  final Map job;

  const CompanyInstructions({Key key, this.job}) : super(key: key);
  @override
  _CompanyInstructionsState createState() => _CompanyInstructionsState();
}

class _CompanyInstructionsState extends State<CompanyInstructions> {
  double fontSize = 14, height, width;
  bool loading = false;
  List<CameraDescription> cameras;
  APIService _APIService = APIService();

  Future<dynamic> getInfo() async {
    dynamic result = await _APIService.fetchInterviewQ(widget.job['job_id']);
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              child: AppBar(
                  backgroundColor: basicColor,
                  automaticallyImplyLeading: false,
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
                      "Apply",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              preferredSize: Size.fromHeight(50),
            ),
            body: FutureBuilder(
                future: getInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data['error'] != null)
                      return Center(
                        child: Text(snapshot.data['error']),
                      );
                    else
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 18.0, left: 10.0, right: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, height * 0.1, 0, 0),
                                        child: Align(
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: 'Click ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: ' "START" ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: basicColor)),
                                                  TextSpan(
                                                      text:
                                                          ' when you are ready! '),
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 10, 0.0, 8),
                                        child: Align(
                                            child: Text(
                                                "Please read the following instructions carefully.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.center),
                                      ),
                                      SizedBox(height: height * 0.05),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10.0, 5, 0, 8),
                                        child: Align(
                                            child: Text(
                                                snapshot.data['questions'] !=
                                                        null
                                                    ? "1. There will be a total of  " +
                                                        snapshot
                                                            .data['questions']
                                                            .length
                                                            .toString() +
                                                        " questions in the interview."
                                                    : "1. There will be a total of 15 questions in the interview.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "2. You will be given 60 seconds for answering each question.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "3. You have to attempt all the questions.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "4. You cannot pause the interview in between.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "5. Don’t close or reload the window during the interview.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "6. Strict action will be taken if any abusive or offensive language is used.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 30.0),
                                          child: RaisedButton(
                                              color: basicColor,
                                              elevation: 0,
                                              padding: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: basicColor,
                                                    width: 1.2),
                                              ),
                                              child: Text(
                                                'START',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                bool storage = false,
                                                    camera = false,
                                                    microphone = false;
                                                var storageStatus =
                                                    await Permission
                                                        .storage.status;
                                                if (storageStatus ==
                                                    PermissionStatus.granted) {
                                                  storage = true;
                                                } else if (storageStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                  ].request();
                                                  if (statuses[
                                                          Permission.storage] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    storage = true;
                                                  }
                                                }
                                                var cameraeStatus =
                                                    await Permission
                                                        .camera.status;
                                                if (cameraeStatus ==
                                                    PermissionStatus.granted) {
                                                  camera = true;
                                                } else if (cameraeStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[
                                                          Permission.camera] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    camera = true;
                                                  }
                                                }
                                                var microphoneStatus =
                                                    await Permission
                                                        .microphone.status;
                                                if (microphoneStatus ==
                                                    PermissionStatus.granted) {
                                                  microphone = true;
                                                } else if (microphoneStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.microphone,
                                                  ].request();
                                                  if (statuses[Permission
                                                          .microphone] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    microphone = true;
                                                  }
                                                }
                                                if (storage &&
                                                    camera &&
                                                    microphone) {
                                                  print(snapshot
                                                      .data['startFrom']);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  JobQuestions(
                                                                    questions: snapshot
                                                                            .data[
                                                                        'questions'],
                                                                    whereToStart:
                                                                        snapshot
                                                                            .data['startFrom'],
                                                                    jobID: widget
                                                                            .job[
                                                                        'job_id'],
                                                                  )));
                                                } else
                                                  showToast('Permission denied',
                                                      context,
                                                      color: Colors.red);
                                              }),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error Occured"));
                  }
                  return Loading();
                }),
          );
  }
}
