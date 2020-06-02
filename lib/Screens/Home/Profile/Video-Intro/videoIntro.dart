import 'dart:async';
import 'dart:io';

import 'package:apli/Screens/Home/Profile/Video-Intro/cameraScreen.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

enum currentState { none, uploading, success, failure }

class VideoIntro extends StatefulWidget {
  @override
  _VideoIntroState createState() => _VideoIntroState();
}

double width, height;
bool tempProfileStatus;

class _VideoIntroState extends State<VideoIntro>
    with SingleTickerProviderStateMixin {
  String email;
  int Status;
  List<CameraDescription> cameras;
  File file;
  String fileName = '';
  String urlFromCamera;
  String operationText = '';
  bool loading = false;
  bool isUploaded = true, error = false;
  String result = '';
  String fetchUrl;
  double fontSize = 15;
  currentState x = currentState.none;
  StorageUploadTask uploadTask;
  VideoPlayerController fileVideocontroller;

  camInit() async {
    cameras = await availableCameras();
  }

  userAddVideoUrl(String url) async {
    String temp = decimalToBinary(Status).toString();
    while (temp.length != 9) {
      temp = '0' + temp;
    }
    temp = temp.substring(0, 7) + '1' + temp.substring(8);
    Status = binaryToDecimal(int.parse(temp));
    print(temp);
    Firestore.instance.collection('candidates').document(email).updateData(
        {'video_resume': url, 'profile_status': Status}).then((onValue) {
      setState(() {
        fetchUrl = url;
        setState(() {
          Status = binaryToDecimal(int.parse(temp));
          x = currentState.success;
          tempProfileStatus = true;
        });
      });
    });
  }

  void deleteDirecotry(String x) {
    final dir = Directory(urlFromCamera);
    try {
      dir.deleteSync(recursive: true);
    } on Exception catch (e) {
      print(e);
    }
  }

  deleteVideoUrl() async {
    String temp = decimalToBinary(Status).toString();
    while (temp.length != 9) {
      temp = '0' + temp;
    }
    temp = temp.substring(0, 7) + '0' + temp.substring(8);
    setState(() {
      Status = binaryToDecimal(int.parse(temp));
    });
    print(Status);
    Firestore.instance
        .collection('candidates')
        .document(email)
        .setData({'video_resume': null, 'profile_status': Status}, merge: true);
    tempProfileStatus = false;
  }

  double _bytesProgress(StorageTaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalByteCount / 1024.0) / 1000;
    double x = double.parse(res.toStringAsFixed(2)) /
        double.parse(res2.toStringAsFixed(2));
    x = x * 100;
    double round = ((x * 100).roundToDouble()) / 100;
    return round;
    // return double.parse(res.toStringAsFixed(2)) /
    //     double.parse(res2.toStringAsFixed(2));
  }

  usergetVideoUrl() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        try {
          await Firestore.instance
              .collection('candidates')
              .document(prefs.getString('email'))
              .get()
              .then((s) {
            if (s.data['video_resume'] != null) {
              setState(() {
                fetchUrl = s.data['video_resume'];
                email = s.data['email'];
                x = currentState.success;
                Status = s.data['profile_status'] ?? 0;
              });
            } else {
              setState(() {
                x = currentState.none;
                email = s.data['email'];
                Status = s.data['profile_status'] ?? 0;
              });
            }
          });
        } catch (e) {
          print(e.toString());
          if (mounted)
            setState(() {
              error = true;
            });
        }
      }
    });
  }

  Future<void> _uploadFile(File file, String filename) async {
    await SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("resumeVideos/${value.getString('email')}");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      print('abd');
      if (uploadTask.isInProgress) {
        print('abd');
        setState(() {
          x = currentState.uploading;
        });
      }

      if (url != null) {
        userAddVideoUrl(url);
      } else if (url == null) {
        x = currentState.failure;
      }
    });
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(type: FileType.video);
      if (fileVideocontroller != null) {
        await fileVideocontroller.dispose();
      }
      if (file != null) {
        fileVideocontroller = new VideoPlayerController.file(file)
          ..initialize().then((value) {
            if (fileVideocontroller.value.duration.inMinutes > 0) {
              showToast('Video cannot exceed 1 minute', context, duration: 5);
            } else {
              fileName = p.basename(file.path);
              setState(() {
                fileName = p.basename(file.path);
              });
              _uploadFile(file, fileName);
              setState(() {
                x = currentState.uploading;
              });
            }
          });
      }
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e.toString(),
              body: Text("Error Has Occured"))
          .show();
    }
  }

  Widget uploadVideo() {
    switch (x) {
      case currentState.none:
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
                child: Align(
                    child: Text(videoIntroSlogan,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 8),
                child: Align(
                    child: Text("Instructions to follow",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: basicColor)),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.1, 5, width * 0.1, 8),
                child: Align(
                    child: Text(
                        "1. Say something which is not mentioned in your resume",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        )),
                    alignment: Alignment.centerLeft),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.1, 5, width * 0.1, 8),
                child: Align(
                    child: Text("2. Please be well dressed for the video",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        )),
                    alignment: Alignment.centerLeft),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.1, 5, width * 0.1, 8),
                child: Align(
                    child: Text(
                        "3. Please Keep your script limited to 60 seconds and be well prepared",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        )),
                    alignment: Alignment.centerLeft),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.1, 5, width * 0.1, 8),
                child: Align(
                    child: Text(
                        "4. Don't worry you can have as many takes as you want",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        )),
                    alignment: Alignment.centerLeft),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 20, 5, 8),
                      child: Align(
                        child: RaisedButton(
                          color: Theme.of(context).backgroundColor,
                          elevation: 0,
                          padding: EdgeInsets.only(left: 22, right: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: basicColor, width: 1.5),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              'Upload From Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: basicColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            filePicker(context);
//                          getVideo();
                          },
                        ),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 20, 0, 8),
                      child: Align(
                        child: RaisedButton(
                            color: Theme.of(context).backgroundColor,
                            elevation: 0,
                            padding: EdgeInsets.only(left: 22, right: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: basicColor, width: 1.5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                'Record Now',
                                style: TextStyle(
                                    color: basicColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () async {
                              bool storage = false,
                                  camera = false,
                                  microphone = false;
                              var storageStatus =
                                  await Permission.storage.status;
                              if (storageStatus == PermissionStatus.granted) {
                                storage = true;
                              } else if (storageStatus ==
                                  PermissionStatus.undetermined) {
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.storage,
                                ].request();
                                if (statuses[Permission.storage] ==
                                    PermissionStatus.granted) {
                                  storage = true;
                                }
                              }
                              var cameraeStatus =
                                  await Permission.camera.status;
                              if (cameraeStatus == PermissionStatus.granted) {
                                camera = true;
                              } else if (cameraeStatus ==
                                  PermissionStatus.undetermined) {
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.camera,
                                ].request();
                                if (statuses[Permission.camera] ==
                                    PermissionStatus.granted) {
                                  camera = true;
                                }
                              }
                              var microphoneStatus =
                                  await Permission.microphone.status;
                              if (microphoneStatus ==
                                  PermissionStatus.granted) {
                                microphone = true;
                              } else if (microphoneStatus ==
                                  PermissionStatus.undetermined) {
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.microphone,
                                ].request();
                                if (statuses[Permission.microphone] ==
                                    PermissionStatus.granted) {
                                  microphone = true;
                                }
                              }
                              if (storage && camera && microphone) {
                                urlFromCamera = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Camera(
                                            cameras: cameras,
                                            status: Status,
                                          )),
                                );
                                print(urlFromCamera);
                                if (urlFromCamera != null) {}
                              } else
                                showToast('Permission denied', context,
                                    color: Colors.red);
                            }),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
        break;
      case currentState.uploading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload),
                  StreamBuilder<StorageTaskEvent>(
                      stream: uploadTask.events,
                      builder: (context,
                          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          final StorageTaskEvent event = asyncSnapshot.data;
                          final StorageTaskSnapshot snapshot = event.snapshot;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                ' Uploading  ${_bytesProgress(snapshot)} %',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                          );
                        }
                        return Container();
                      }),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.1, height * 0.04, width * 0.1, height * 0.04),
                child: Text(
                  'Wait while we upload your Video Intro',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.2),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
        break;
      case currentState.success:
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
          child: Align(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AwsomeVideoPlayer(
                      fetchUrl ?? "",
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
                          videoTopBarStyle:
                              VideoTopBarStyle(popIcon: Container())),
                    ),
                  ),
                ),
                Icon(
                  Icons.done_outline,
                  size: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
                  child: Text(
                    "Your Video Intro Has Been Uploaded Successfully!",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: basicColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      child: Text(
                        "Delete & Re-Upload",
                        style: TextStyle(
                            fontSize: fontSize,
                            color: basicColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text(
                              'Are you sure you want to delete your Video Intro?',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  setState(() {
                                    loading = true;
                                  });
                                  await usergetVideoUrl();
                                  if (fetchUrl != null) {
                                    var ref = FirebaseStorage.instance
                                        .getReferenceFromUrl(fetchUrl);

                                    await ref.then((reference) {
                                      reference.delete().then((x) {
                                        setState(() {
                                          x = currentState.none;
                                          fetchUrl = null;
                                        });
                                        deleteVideoUrl();
                                        usergetVideoUrl();
                                      });
                                      setState(() {
                                        loading = false;
                                      });
                                    });
                                  }
                                },
                                child: new Text(
                                  'Yes',
                                  style: TextStyle(),
                                ),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: new Text(
                                  'No',
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                        );
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

  @override
  void initState() {
    usergetVideoUrl();
    camInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (fileVideocontroller != null) fileVideocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width <= 360) {
      fontSize = 12;
    }
    return email == null
        ? Loading()
        : loading
            ? Loading()
            : ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                    child: uploadVideo(),
                  ),
                ),
              );
  }
}
