import 'package:flutter/material.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CompanyDetails extends StatefulWidget {
  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  bool isProceedClicked = false;

  Widget toShow() {
    if (isProceedClicked == false) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: AwsomeVideoPlayer(
              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1800s, when an nknown printer took agalley of type and scrambled ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: RaisedButton(
                color: basicColor,
                elevation: 0,
                padding: EdgeInsets.only(left: 22, right: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: basicColor, width: 1.2),
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isProceedClicked = true;
                  });
                }),
          )
        ],
      );
    } else {
      return Column(
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
                            "Flutter Developer",
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
                                  "Powai , Maharashtra",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                AutoSizeText(
                                  "2020-10-6",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon:
                                Icon(Icons.bookmark, color: Color(0xffebd234)),
                            onPressed: () {},
                          )),
                      ListTile(
                        dense: true,
                        title: AutoSizeText(
                          "Job's CTC : ",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: AutoSizeText(
                          "Notice Period: ",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
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
                              AutoSizeText(
                                "foisefheoifeoifehefieoiufhefoiefeiuefeioffeiofuefiuefehieuighroighruggorguregrghogrguhergruggrgregoregeriugergoregguigierogeriu",
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
                              AutoSizeText(
                                "1 .foisefheoifeoifehefieoiufhofuefiuefehieuighroighruggorguregrghogrguhergruggrgregoregeriugergoregguigierogeriu",
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
                          "Soft Skills : ",
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
                              AutoSizeText(
                                "1 .foisefheoifeoifehefieoiufhofuefiuefehieuighroighruggorguregrghogrguhergruggrgregoregeriugergoregguigierogeriu",
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
                          "Technical Skills  : ",
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
                              AutoSizeText(
                                "1 .foisefheoifeoifehefieoiufhofuefiuefehieuighroighruggorguregrghogrguhergruggrgregoregeriugergoregguigierogeriu",
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
                          "Requirements : ",
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
                              AutoSizeText(
                                "1. HElllo\n2. REsume\n3. BYe\n",
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
                    ]),
              ),
            ),
          ),
        ],
      );
    }
  }

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
              child: toShow()),
        ));
  }
}
