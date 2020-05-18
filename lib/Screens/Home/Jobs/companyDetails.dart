import 'package:apli/Screens/Home/Jobs/jobQuestions.dart';
import 'package:apli/Shared/functions.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:apli/Shared/constants.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:permission_handler/permission_handler.dart';

class CompanyDetails extends StatefulWidget {
  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  bool isProceedClicked = false, toShowStart = false;
  double height, width, fontSize = 15;
  List<CameraDescription> cameras;
  camInit() async {
    cameras = await availableCameras();
  }

  Widget toShow() {
    if (isProceedClicked == false && toShowStart == false) {
      return Container(
        padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1, top: 15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1800s, when an nknown printer took agalley of type and scrambled ",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: height * 0.05,),
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
                  setState(() {
                    isProceedClicked = true;
                  });
                }),
          ],
        ),
      );
    } else if (isProceedClicked == true && toShowStart == false) {
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: RaisedButton(
                              color: basicColor,
                              elevation: 0,
                              padding: EdgeInsets.only(left: 30, right: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: basicColor, width: 1.2),
                              ),
                              child: Text(
                                'APPLY NOW',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  isProceedClicked = true;
                                  toShowStart = true;
                                });
                              }),
                        ),
                      )
                    ]),
              ),
            ),
          ),
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.center),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 0, 8),
                        child: Align(
                            child: Text(
                                "1. Say something which is not mentioned in your resume",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                            alignment: Alignment.centerLeft),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 8),
                        child: Align(
                            child:
                                Text("2. Please be well dressed for the video",
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
                                "3. Please Keep your script limited to 60 seconds and be well prepared",
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
                                "4. Don't worry you can have as many takes as you want",
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
                                'START',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                var status = await Permission.storage.status;
                                switch (status) {
                                  case PermissionStatus.undetermined:
                                    Map<Permission, PermissionStatus> statuses =
                                        await [
                                      Permission.storage,
                                    ].request();
                                    if (statuses[Permission.storage] ==
                                        PermissionStatus.granted) {
                                      var status2 =
                                          await Permission.camera.status;
                                      switch (status2) {
                                        case PermissionStatus.undetermined:
                                          Map<Permission, PermissionStatus>
                                              statuses2 = await [
                                            Permission.camera,
                                          ].request();
                                          if (statuses2[Permission.camera] ==
                                              PermissionStatus.granted) {
                                            var status3 = await Permission
                                                .microphone.status;
                                            switch (status3) {
                                              case PermissionStatus
                                                  .undetermined:
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses3 = await [
                                                  Permission.microphone,
                                                ].request();
                                                if (statuses3[Permission
                                                        .microphone] ==
                                                    PermissionStatus.granted) {
                                                  // TODO

                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            JobQuestions(
                                                              cameras: cameras,
                                                            )),
                                                  );
                                                } else
                                                  showToast(
                                                      'Microphone Permission denied',
                                                      context);
                                                break;
                                              case PermissionStatus.granted:
                                                // TODO

                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobQuestions(
                                                            cameras: cameras,
                                                          )),
                                                );

                                                break;
                                              default:
                                                showToast(
                                                    'Microphone Permission denied',
                                                    context);
                                                break;
                                            }
                                          } else
                                            showToast(
                                                'Camera Permission denied',
                                                context);
                                          break;

                                        case PermissionStatus.granted:
                                          var status3 = await Permission
                                              .microphone.status;
                                          switch (status3) {
                                            case PermissionStatus.undetermined:
                                              Map<Permission, PermissionStatus>
                                                  statuses3 = await [
                                                Permission.microphone,
                                              ].request();
                                              if (statuses3[
                                                      Permission.microphone] ==
                                                  PermissionStatus.granted) {
                                                // TODO
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobQuestions(
                                                            cameras: cameras,
                                                          )),
                                                );
                                              } else
                                                showToast(
                                                    'Microphone Permission denied',
                                                    context);
                                              break;
                                            case PermissionStatus.granted:
                                              // TODO
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobQuestions(
                                                          cameras: cameras,
                                                        )),
                                              );

                                              break;
                                            default:
                                              showToast(
                                                  'Microphone Permission denied',
                                                  context);
                                              break;
                                          }
                                          break;
                                        default:
                                          showToast('Camera Permission Denied',
                                              context);
                                          break;
                                      }
                                    } else {
                                      showToast(
                                          'Storage Permission Denied', context);
                                    }
                                    break;
                                  case PermissionStatus.granted:
                                    var status2 =
                                        await Permission.camera.status;
                                    switch (status2) {
                                      case PermissionStatus.undetermined:
                                        Map<Permission, PermissionStatus>
                                            statuses2 = await [
                                          Permission.camera,
                                        ].request();
                                        if (statuses2[Permission.camera] ==
                                            PermissionStatus.granted) {
                                          var status3 =
                                              await Permission.camera.status;
                                          switch (status3) {
                                            case PermissionStatus.undetermined:
                                              Map<Permission, PermissionStatus>
                                                  statuses3 = await [
                                                Permission.microphone,
                                              ].request();
                                              if (statuses3[
                                                      Permission.microphone] ==
                                                  PermissionStatus.granted) {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobQuestions(
                                                            cameras: cameras,
                                                          )),
                                                );
                                              } else
                                                showToast(
                                                    'Microphone Permission denied',
                                                    context);
                                              break;
                                            case PermissionStatus.granted:
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobQuestions(
                                                          cameras: cameras,
                                                        )),
                                              );

                                              break;
                                            default:
                                              showToast(
                                                  'Microphone Permission denied',
                                                  context);
                                              break;
                                          }
                                        } else
                                          showToast('Camera Permission denied',
                                              context);
                                        break;
                                      case PermissionStatus.granted:
                                        var status3 =
                                            await Permission.microphone.status;
                                        switch (status3) {
                                          case PermissionStatus.undetermined:
                                            Map<Permission, PermissionStatus>
                                                statuses3 = await [
                                              Permission.microphone,
                                            ].request();
                                            if (statuses3[
                                                    Permission.microphone] ==
                                                PermissionStatus.granted) {
                                              // TODO
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobQuestions(
                                                          cameras: cameras,
                                                        )),
                                              );
                                            } else
                                              showToast(
                                                  'Microphone Permission denied',
                                                  context);
                                            break;
                                          case PermissionStatus.granted:
                                            // TODO
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobQuestions(
                                                        cameras: cameras,
                                                      )),
                                            );

                                            break;
                                          default:
                                            showToast(
                                                'Microphone Permission denied',
                                                context);
                                            break;
                                        }
                                        break;
                                      default:
                                        showToast('Camera Permission Denied',
                                            context);
                                        break;
                                    }
                                    break;
                                  default:
                                    showToast(
                                        'Storage Permission denied', context);
                                    break;
                                }
                                // _recordVideo();
                              }),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    camInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if (width <= 360) {
      fontSize = 12;
    }

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
