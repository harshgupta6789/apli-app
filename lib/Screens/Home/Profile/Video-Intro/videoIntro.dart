import 'dart:async';
import 'dart:io';
import 'package:apli/Screens/Home/Profile/Video-Intro/cameraScreen.dart';
import 'package:apli/Shared/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isUploaded = true;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;
  StorageUploadTask uploadTask;

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

  double _bytesTransferred(StorageTaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalByteCount / 1024.0) / 1000;
    return double.parse(res.toStringAsFixed(4)) /
        double.parse(res2.toStringAsFixed(4));
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
    uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if (uploadTask.isInProgress) {
      setState(() {
        x = currentState.uploading;
      });
    }

    if (url != null) {
      setState(() {
        x = currentState.success;
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 35, 8, 8),
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
                        'Upload From Gallery',
                        style: TextStyle(
                            color: basicColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        filePicker(context);
                      },
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 35, 8, 8),
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
                          'Record Now',
                          style: TextStyle(
                              color: basicColor, fontWeight: FontWeight.bold),
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
                    alignment: Alignment.center,
                  ),
                ),
              )
            ],
          ),
        );
        break;
      case currentState.uploading:
        return Padding(
          padding: EdgeInsets.only(top: 40),
          child: StreamBuilder<StorageTaskEvent>(
              stream: uploadTask.events,
              builder:
                  (context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  final StorageTaskEvent event = asyncSnapshot.data;
                  final StorageTaskSnapshot snapshot = event.snapshot;
                  return Column(
                    children: <Widget>[
                      //Text('${_bytesTransferred(snapshot)} Megabytes sent'),
                      CircularProgressIndicator(
                        value: _bytesTransferred(snapshot),
                      )
                    ],
                  );
                }
                return Align(child: Text("Uploading Your Resume!"));
              }),
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
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              videoIntroSlogan,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                child: Text("Instructions to follow",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                alignment: Alignment.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                child: Text("1. Lorem Ipsum", style: TextStyle(fontSize: 20)),
                alignment: Alignment.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                child: Text("1. Lorem Ipsum", style: TextStyle(fontSize: 20)),
                alignment: Alignment.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                child: Text("1. Lorem Ipsum", style: TextStyle(fontSize: 20)),
                alignment: Alignment.center),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                child: Text(
                  "1. Lorem Ipsum",
                  style: TextStyle(fontSize: 20),
                ),
                alignment: Alignment.center),
          ),
          uploadVideo()
        ],
      ),
    );
  }
}
