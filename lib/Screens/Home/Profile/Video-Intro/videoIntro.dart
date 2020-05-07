import 'dart:async';
import 'dart:io';
import 'package:apli/Screens/Home/Profile/Video-Intro/cameraScreen.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apli/Shared/functions.dart';

enum currentState { none, uploading, success, failure }

class VideoIntro extends StatefulWidget {
  @override
  _VideoIntroState createState() => _VideoIntroState();
}

class _VideoIntroState extends State<VideoIntro>
    with SingleTickerProviderStateMixin {
  String email;
  String fileType = 'video';
  List<CameraDescription> cameras;
  File file;
  String fileName = '';
  String urlFromCamera;
  String operationText = '';
  bool loading = false;
  bool isUploaded = true, error = false;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;
  StorageUploadTask uploadTask;
  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: 'wfd3eGkCatE',
  //   flags: YoutubePlayerFlags(
  //     autoPlay: true,
  //     mute: true,
  //   ),
  // );

  camInit() async {
    cameras = await availableCameras();
  }

  userAddVideoUrl(String url) async {
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': url}).then((onValue) {
      setState(() {
        fetchUrl = url;
        //deleteDirecotry(urlFromCamera);
        setState(() {
          x = currentState.success;
        });
      });
    });
  }

  void deleteDirecotry(String x) {
    final dir = Directory(urlFromCamera);
    try {
      dir.deleteSync(recursive: true);
    } on Exception catch (e) {}
  }

  deleteVideoUrl() async {
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': 'deleted'});
  }

  double _bytesTransferred(StorageTaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalByteCount / 1024.0) / 1000;
    double x = double.parse(res.toStringAsFixed(2)) /
        double.parse(res2.toStringAsFixed(2));
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
            if (s.data['video_resume'] != null &&
                s.data['video_resume'] != 'deleted') {
              setState(() {
                fetchUrl = s.data['video_resume'];
                email = s.data['email'];
                x = currentState.success;
              });
            } else {
              setState(() {
                x = currentState.none;
                email = s.data['email'];
              });
            }
          });
        } catch (e) {
          setState(() {
            error = true;
          });
        }
      }
    });
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("resumeVideos/$filename");
    uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if (uploadTask.isInProgress) {
      setState(() {
        x = currentState.uploading;
      });
    }

    if (url != null) {
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
        _uploadFile(file, fileName);
        setState(() {
          x = currentState.uploading;
        });
      } else {}
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e.toString(),
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

  Future videoPicker(String path) async {
    file = File(path);
    try {
      fileName = p.basename(path);
      setState(() {
        fileName = p.basename(path);
      });
      _uploadFile(file, fileName);
      setState(() {
        x = currentState.uploading;
      });
    } catch (e) {
      //AwesomeDialog(context: context, dialogType: DialogType.WARNING).show();
    }
  }

  Widget uploadVideo() {
    switch (x) {
      case currentState.none:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 4),
              child: Align(
                  child: Text(videoIntroSlogan,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
              child: Align(
                  child: Text("Instructions to follow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: basicColor)),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  child: Text("1. Lorem ipsum dolor sit amet, consectetur",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  alignment: Alignment.center),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 35, 5, 8),
                    child: Align(
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.only(left: 22, right: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: basicColor, width: 1.5),
                        ),
                        child: Text(
                          'Upload \nFrom Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: basicColor, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          filePicker(context);
                        },
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 35, 0, 8),
                    child: Align(
                      child: RaisedButton(
                          color: Colors.white,
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
                            var status = await Permission.storage.status;
                            switch (status) {
                              case PermissionStatus.undetermined:
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.storage,
                                ].request();
                                break;
                              case PermissionStatus.granted:
                                urlFromCamera = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Camera(cameras: cameras)),
                                );
                                print(urlFromCamera);
                                if (urlFromCamera != null) {
                                  showToast(
                                      'Recorded Video Will Be Stored In Storage/Apli Folder',
                                      context);
                                  // videoPicker(urlFromCamera);
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
                      alignment: Alignment.center,
                    ),
                  ),
                )
              ],
            )
          ],
        );

        break;
      case currentState.uploading:
        return Padding(
          padding: EdgeInsets.only(top: 150, left: 50, right: 50),
          child: StreamBuilder<StorageTaskEvent>(
              stream: uploadTask.events,
              builder:
                  (context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  final StorageTaskEvent event = asyncSnapshot.data;
                  final StorageTaskSnapshot snapshot = event.snapshot;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          value: _bytesTransferred(snapshot),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${_bytesTransferred(snapshot)} MB Uploaded...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  );
                }
                return Align(child: Text("Uploading Your Resume!..."));
              }),
        );
        break;
      case currentState.success:
        return Align(
          child: Column(
            children: <Widget>[
              // YoutubePlayer(
              //   controller: _controller,
              //   showVideoProgressIndicator: true,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AwsomeVideoPlayer(fetchUrl ?? ""),
              ),
              Icon(
                Icons.done_outline,
                size: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Your Resume Has Been Uploaded Succesfully!",
                  textAlign: TextAlign.center,
                ),
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

                            await ref.then((reference) {
                              reference.delete().then((x) {
                                setState(() {
                                  x = currentState.none;
                                  fetchUrl = null;
                                });
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
  Widget build(BuildContext context) {
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
