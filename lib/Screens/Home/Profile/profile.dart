import 'dart:async';
import 'dart:io';
import 'package:apli/Screens/Home/Profile/cameraScreen.dart';
import 'package:apli/Shared/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomeLoginWrapper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum currentState { none, uploading, success, failure }

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String email;
  TabController _tabController;
  String fileType = 'video';
  List<CameraDescription> cameras;
  File file;
  String fileName = '';
  String urlFromCamera;
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;

  camInit() async {
    cameras = await availableCameras();
  }

  userAddVideoUrl(String url) async {
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': url});
  }

  deleteVideoUrl() async {
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': 'deleted'});
  }

  usergetVideoUrl() async {
    await Firestore.instance
        .collection('candidates')
        .document(email)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data['video_resume'] != null &&
          ds.data['video_resume'] != 'deleted') {
        fetchUrl = ds.data['video_resume'];
        setState(() {
          x = currentState.success;
          print(x);
        });
      } else {
        setState(() {
          x = currentState.none;
        });
      }
      // if (fetchUrl!=null) {
      //   setState(() {
      //     x = currentState.success;
      //     print(fetchUrl);
      //     print(x);
      //   });
      // }
    });
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("resumeVideos/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if (uploadTask.isInProgress) {
      setState(() {
        x = currentState.uploading;
      });
      print(uploadTask.lastSnapshot.bytesTransferred.toString());
    }
    if (url != null) {
      setState(() {
        x = currentState.success;
        print("URL is $url");
      });
      userAddVideoUrl(url);
    } else if (url == null) {
      x = currentState.failure;
    }
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(type: FileType.video);
      if (file != null) {
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
        setState(() {
          x = currentState.uploading;
        });
      } else {}
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e,
              body: Text("Error Has Occured"))
          .show();
    }
  }

  // void _recordVideo() async {
  //   ImagePicker.pickVideo(source: ImageSource.camera)
  //       .then((File recordedVideo) {
  //     if (recordedVideo != null && recordedVideo.path != null) {
  //       GallerySaver.saveVideo(recordedVideo.path).then((onValue) {
  //         if (onValue == true) {
  //           filePicker(context);
  //         }
  //       });
  //     }
  //   });
  // }

  Future videoPicker(BuildContext context, String path) async {
    file = File(path);
    try {
      fileName = p.basename(path);
      setState(() {
        fileName = p.basename(path);
      });
      print(fileName);
      _uploadFile(file, fileName);
      setState(() {
        x = currentState.uploading;
      });
    } catch (e) {
      AwesomeDialog(context: context, dialogType: DialogType.WARNING).show();
    }
  }

  Widget uploadVideo() {
    switch (x) {
      case currentState.none:
        return Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: basicColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      child: Text(
                        "Upload From Gallery",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: basicColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        filePicker(context);
                      }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: basicColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                        child: Text(
                          "Record Now",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: basicColor,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          var status = await Permission.storage.status;
                          switch (status) {
                            case PermissionStatus.undetermined:
                              Map<Permission, PermissionStatus> statuses =
                                  await [
                                Permission.storage,
                              ].request();
                              print(statuses[Permission.storage]);
                              break;
                            case PermissionStatus.granted:
                              urlFromCamera = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Camera(cameras: cameras)),
                              );
                              if (urlFromCamera != null) {
                                videoPicker(context, urlFromCamera);
                              }
                              break;
                            case PermissionStatus.denied:
                              break;
                            case PermissionStatus.restricted:
                              break;
                            case PermissionStatus.permanentlyDenied:
                              break;
                          }

                          // _recordVideo();
                        }),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case currentState.uploading:
        return Padding(
          padding: EdgeInsets.only(top: 40),
          child: Align(child: Text("Uploading Your Resume!")),
        );
        break;
      case currentState.success:
        return Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Align(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.done_outline,
                  size: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Your Resume Has Been Uploaded Succesfully!"),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      child: Text(
                        "Delete & Re-Upload",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          tittle: "Are You Sure?",
                          desc: "Yes!",
                          btnCancelText: "Cancel",
                          btnCancelOnPress: () {
                            Navigator.of(context).pop();
                          },
                          btnOkOnPress: () async {
                            await usergetVideoUrl();
                            if (fetchUrl != null) {
                              var ref = FirebaseStorage.instance
                                  .getReferenceFromUrl(fetchUrl);
                              print(fetchUrl);

                              await ref.then((reference) {
                                reference.delete().then((x) {
                                  setState(() {
                                    x = currentState.none;
                                    fetchUrl = null;
                                  });
                                  print("deleted");
                                  deleteVideoUrl();
                                  usergetVideoUrl();
                                });
                              });
                            }
                          },
                          btnOkText: "Delete",
                        ).show();
                      }),
                ),
              ],
            ),
            alignment: Alignment.center,
          ),
        );
      default:
        return Loading();
    }
  }

  getPrefs() async {
    await SharedPreferences.getInstance().then((prefs) {
      setState(() {
        email = prefs.getString('email');
      });
      usergetVideoUrl();
      camInit();
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: customDrawer(context),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
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
                profile,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 5.0, color: basicColor),
                  ),
                  tabs: [
                    Tab(
                      text: resume,
                    ),
                    Tab(
                      text: videoIntro,
                    ),
                    Tab(text: psychTest)
                  ],
                  controller: _tabController,
                )),
          ),
          preferredSize: Size.fromHeight(105),
        ),
        body: TabBarView(children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "Assets/Images/profile.png",
                  height: 300,
                  width: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: " You can start applying for\n",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                              text: "Jobs",
                              style: TextStyle(color: basicColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper(
                                                currentTab: 1,
                                              )),
                                      (Route<dynamic> route) => false);
                                  setState(() {});
                                }),
                          TextSpan(text: " after filling in the details.")
                        ]),
                  ),
                )
              ],
            ),
          )),
          Center(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "Assets/Images/profile.png",
                        height: 300,
                        width: 300,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your video intro will appear here.",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ))),
          Center(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("Assets/Images/profile.png",
                          height: 300, width: 300),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Your test will be shown here.",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ))),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.all(20.0),
          //         child: Text(
          //           resumeSlogan,
          //           style: TextStyle(fontSize: 20),
          //         ),
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: <Widget>[
          //           Expanded(
          //             child: Padding(
          //               padding: EdgeInsets.only(left: 30.0),
          //               child: Image.asset("Assets/Images/job.png"),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Column(
          //               children: <Widget>[
          //                 Padding(
          //                   padding: const EdgeInsets.all(4.0),
          //                   child: IconButton(
          //                     icon: Icon(EvaIcons.editOutline),
          //                     onPressed: () {
          //                       Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) => EditResume()),
          //                       );
          //                     },
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(4.0),
          //                   child: IconButton(
          //                     icon: Icon(EvaIcons.shareOutline),
          //                     onPressed: () {},
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(4.0),
          //                   child: IconButton(
          //                     icon: Icon(EvaIcons.downloadOutline),
          //                     onPressed: () {},
          //                   ),
          //                 )
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.all(20.0),
          //         child: Text(
          //           videoIntroSlogan,
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: 20),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Align(
          //             child: Text("Instructions to follow",
          //                 style: TextStyle(
          //                     fontSize: 20, fontWeight: FontWeight.w600)),
          //             alignment: Alignment.center),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Align(
          //             child: Text("1. Lorem Ipsum",
          //                 style: TextStyle(fontSize: 20)),
          //             alignment: Alignment.center),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Align(
          //             child: Text("1. Lorem Ipsum",
          //                 style: TextStyle(fontSize: 20)),
          //             alignment: Alignment.center),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Align(
          //             child: Text("1. Lorem Ipsum",
          //                 style: TextStyle(fontSize: 20)),
          //             alignment: Alignment.center),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Align(
          //             child: Text(
          //               "1. Lorem Ipsum",
          //               style: TextStyle(fontSize: 20),
          //             ),
          //             alignment: Alignment.center),
          //       ),
          //       uploadVideo()
          //     ],
          //   ),
          // ),
          // Psychometry(),
        ], controller: _tabController));
  }
}
