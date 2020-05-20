import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'pdfResume.dart';

class CompanyProfile extends StatelessWidget {
  final Map company;

  const CompanyProfile({Key key, this.company}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              onTap: () {},
                              title: AutoSizeText(
                                company['role'] ?? "Role not provided",
                                maxLines: 2,
                                style: TextStyle(
                                    color: basicColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      company['location'] ??
                                          "Location not provided",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AutoSizeText(
                                      'Deadline: ' + company['deadline'] ??
                                          "No Deadline",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(Icons.bookmark,
                              //       color: Color(0xffebd234)),
                              //   onPressed: () {},
                              // )),
                            ),
                            ListTile(
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
                                        text: company['ctc'] ?? "Not Specified",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                              // title: AutoSizeText(
                              //   // company['ctc']!=null?"Job's CTC" + company['ctc']??,
                              //   maxLines: 2,
                              //   style: TextStyle(
                              //       fontSize: 18, fontWeight: FontWeight.w600),
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ),
                            ListTile(
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
                                        text: company['notice_period'] ??
                                            "Not Specified",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                "Role Description : ",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company['description'] ?? "Not Specified",
                                      maxLines: 4,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                "Key Responsibilities : ",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company['key_resp'] ?? "Not Specified",
                                      // maxLines: 4,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                "Soft Skills : ",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        company['soft_skills'].length ?? 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                        company['soft_skills'][index] ??
                                            "Not Specified",
                                        //maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                "Technical Skills  : ",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        company['tech_skills'].length ?? 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                        company['tech_skills'][index] ??
                                            "Not Specified",
                                        //maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                              ),
                            ),
                            ListTile(
                              title: AutoSizeText(
                                "Requirements : ",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: (company['requirements'] ?? [])
                                            .length ??
                                        1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                        company['requirements'][index] ??
                                            "Not Specified",
                                        //maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 10.0),
                                child: RaisedButton(
                                    color: basicColor,
                                    elevation: 0,
                                    padding:
                                        EdgeInsets.only(left: 30, right: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: basicColor, width: 1.2),
                                    ),
                                    child: Text(
                                      'APPLY NOW',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CompanyVideo(
                                                    job: company,
                                                  )));
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
    );
  }
}

class CompanyVideo extends StatefulWidget {
  final Map job;

  CompanyVideo({Key key, this.job}) : super(key: key);

  @override
  _CompanyVideoState createState() => _CompanyVideoState();
}

class _CompanyVideoState extends State<CompanyVideo> {
  double width, height, scale;
  YoutubePlayerController _controller;
  final _APIService = APIService();

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
            autoPlay: true,
            mute: false,
            forceHD: true,
            loop: false,
            disableDragSeek: true),
      );
      return YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        liveUIColor: basicColor,
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

  Future ref() async {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
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
      body: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(left: width * 0.1, right: width * 0.1, top: 15),
        child: FutureBuilder(
            future: getInfo(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: snapshot.data['video'] != null
                            ? videoPlayer(snapshot.data['video'])
                            : Container(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          snapshot.data['text'] ?? "No Info Specified",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      RaisedButton(
                          color: basicColor,
                          elevation: 0,
                          padding: EdgeInsets.only(left: 40, right: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: basicColor, width: 1.2),
                          ),
                          child: Text(
                            'PROCEED',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyInstructions(
                                          job: widget.job,
                                        )));
                          }),
                    ],
                  ),
                );
              } else if (snapshot.hasError)
                return Center(
                  child: Text('Error occured, try again later'),
                );
              else
                return Loading();
            }),
      ),
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
  double fontSize = 14;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.0, left: 10.0, right: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        title: AutoSizeText(
                          widget.job['role'] ?? "No Role Sepcified",
                          maxLines: 2,
                          style: TextStyle(
                              color: basicColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                widget.job['location'] ??
                                    "Location not provided",
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              AutoSizeText(
                                widget.job['deadline'] != null
                                    ? "Deadline : " +
                                        widget.job['deadline'].toString()
                                    : "No Deadline" ?? "No Deadline",
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        // trailing: IconButton(
                        //   icon:
                        //       Icon(Icons.bookmark, color: Color(0xffebd234)),
                        //   onPressed: () {},
                        // )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
                        child: Align(
                            child: RichText(
                              text: TextSpan(
                                text: 'Click ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' "Start" ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: basicColor)),
                                  TextSpan(text: ' when you are ready! '),
                                ],
                              ),
                            ),
                            alignment: Alignment.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 8),
                        child: Align(
                            child: Text(
                                "Please read the following instructions carefully.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.center),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 0, 8),
                        child: Align(
                            child: Text(
                                "1. There will be a total of 15 questions in the interview.",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child: Text(
                                "2. You will be given 60 seconds for answering each question.",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child: Text(
                                "3. You have to attempt all the questions.",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child: Text(
                                "4. You cannot pause the interview in between.",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child: Text(
                                "5. Don’t close or reload the window during the interview.",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child: Text(
                                "6. Strict action will be taken if any abusive or offensive language is used.",
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
                              left: 20.0, right: 20.0, top: 30.0),
                          child: RaisedButton(
                              color: basicColor,
                              elevation: 0,
                              padding: EdgeInsets.only(left: 30, right: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: basicColor, width: 1.2),
                              ),
                              child: Text(
                                'NEXT',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadResumeScreen()));
                              }),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
