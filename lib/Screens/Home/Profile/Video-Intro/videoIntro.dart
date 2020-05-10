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
import 'package:video_player/video_player.dart';

enum currentState { none, uploading, success, failure }

class VideoIntro extends StatefulWidget {
  @override
  _VideoIntroState createState() => _VideoIntroState();
}

double width, height;

class _VideoIntroState extends State<VideoIntro>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

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
  currentState x = currentState.none;
  StorageUploadTask uploadTask;
  VideoPlayerController fileVideocontroller;

  camInit() async {
    cameras = await availableCameras();
  }

  userAddVideoUrl(String url) async {
    String temp  = decimalToBinary(Status).toString();
    while(temp.length != 9) {
      temp = '0' + temp;
    }
    temp = temp.substring(0, 7) + '1' + temp.substring(8);
    Status = binaryToDecimal(int.parse(temp));
    print(temp);
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': url, 'profile_status' : Status}).then((onValue) {
      setState(() {
        fetchUrl = url;
        setState(() {
          Status = binaryToDecimal(int.parse(temp));
          x = currentState.success;
        });
      });
    });
  }

  void deleteDirecotry(String x) {
    final dir = Directory(urlFromCamera);
    try {
      dir.deleteSync(recursive: true);
    } on Exception catch (e) { print(e);}
  }

  deleteVideoUrl() async {
    String temp = decimalToBinary(Status).toString();
    while(temp.length != 9) {
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
        .setData({'video_resume': null, 'profile_status' : Status}, merge: true);
  }

  double _bytesTransferred(StorageTaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalByteCount / 1024.0) / 1000;
    double x = double.parse(res.toStringAsFixed(2)) /
        double.parse(res2.toStringAsFixed(2));
    double round = ((x * 100).roundToDouble()) / 100;
    return round * 100;
    // return double.parse(res.toStringAsFixed(2)) /
    //     double.parse(res2.toStringAsFixed(2));
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
      storageReference =
          FirebaseStorage.instance.ref().child("resumeVideos/${value.getString('email')}");
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
      if(fileVideocontroller != null) {
        await fileVideocontroller.dispose();
      }
      if(file != null) {
        fileVideocontroller = new VideoPlayerController.file(file)
          ..initialize().then((value) {
            if(fileVideocontroller.value.duration.inMinutes > 0) {
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
                    padding: EdgeInsets.fromLTRB(8, 35, 5, 8),
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
//                          getVideo();
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
                                if(statuses[Permission.storage] == PermissionStatus.granted) {
                                  var status2 = await Permission.camera.status;
                                  switch(status2) {
                                    case PermissionStatus.undetermined :
                                      Map<Permission, PermissionStatus> statuses2 =
                                      await [
                                        Permission.camera,
                                      ].request();
                                      if(statuses2[Permission.camera] == PermissionStatus.granted) {
                                        var status3 = await Permission.microphone.status;
                                        switch(status3) {
                                          case PermissionStatus.undetermined :
                                            Map<Permission, PermissionStatus> statuses3 =
                                            await [
                                              Permission.microphone,
                                            ].request();
                                            if(statuses3[Permission.microphone] == PermissionStatus.granted) {
                                              // TODO
                                              urlFromCamera = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Camera(cameras: cameras, status: Status,)),
                                              );
                                              print(urlFromCamera);
                                              if (urlFromCamera != null) {
                                              
                                              }
                                            } else showToast('Microphone Permission denied', context);
                                            break;
                                          case PermissionStatus.granted :
                                            // TODO
                                            urlFromCamera = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Camera(cameras: cameras, status: Status,)),
                                            );
                                            print(urlFromCamera);
                                            if (urlFromCamera != null) {
                                             
                                            }
                                            break;
                                          default :
                                            showToast('Microphone Permission denied', context);
                                            break;
                                        }
                                      } else showToast('Camera Permission denied', context);
                                      break;

                                    case PermissionStatus.granted :
                                      var status3 = await Permission.microphone.status;
                                      switch(status3) {
                                        case PermissionStatus.undetermined :
                                          Map<Permission, PermissionStatus> statuses3 =
                                          await [
                                            Permission.microphone,
                                          ].request();
                                          if(statuses3[Permission.microphone] == PermissionStatus.granted) {
                                            // TODO
                                            urlFromCamera = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Camera(cameras: cameras, status: Status,)),
                                            );
                                            print(urlFromCamera);
                                            if (urlFromCamera != null) {
                                             
                                            }
                                          } else showToast('Microphone Permission denied', context);
                                          break;
                                        case PermissionStatus.granted :
                                        // TODO
                                          urlFromCamera = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Camera(cameras: cameras, status: Status,)),
                                          );
                                          print(urlFromCamera);
                                          if (urlFromCamera != null) {
                                          
                                          }
                                          break;
                                        default :
                                          showToast('Microphone Permission denied', context);
                                          break;
                                      }
                                    break;
                                    default :
                                      showToast('Camera Permission Denied', context);
                                    break;
                                  }
                                } else {
                                  showToast('Storage Permission Denied', context);
                                }
                                break;
                              case PermissionStatus.granted:
                                var status2 = await Permission.camera.status;
                                switch(status2) {
                                  case PermissionStatus.undetermined :
                                    Map<Permission, PermissionStatus> statuses2 =
                                    await [
                                      Permission.camera,
                                    ].request();
                                    if(statuses2[Permission.camera] == PermissionStatus.granted) {
                                      var status3 = await Permission.camera.status;
                                      switch(status3) {
                                        case PermissionStatus.undetermined :
                                          Map<Permission, PermissionStatus> statuses3 =
                                          await [
                                            Permission.microphone,
                                          ].request();
                                          if(statuses3[Permission.microphone] == PermissionStatus.granted) {
                                            // TODO
                                            urlFromCamera = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Camera(cameras: cameras, status: Status,)),
                                            );
                                            print(urlFromCamera);
                                            if (urlFromCamera != null) {
                                             
                                            }
                                          } else showToast('Microphone Permission denied', context);
                                          break;
                                        case PermissionStatus.granted :
                                        // TODO
                                          urlFromCamera = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Camera(cameras: cameras, status: Status,)),
                                          );
                                          print(urlFromCamera);
                                          if (urlFromCamera != null) {
                                         
                                          }
                                          break;
                                        default :
                                          showToast('Microphone Permission denied', context);
                                          break;
                                      }
                                    } else showToast('Camera Permission denied', context);
                                    break;
                                  case PermissionStatus.granted :
                                    var status3 = await Permission.microphone.status;
                                    switch(status3) {
                                      case PermissionStatus.undetermined :
                                        Map<Permission, PermissionStatus> statuses3 =
                                        await [
                                          Permission.microphone,
                                        ].request();
                                        if(statuses3[Permission.microphone] == PermissionStatus.granted) {
                                          // TODO
                                          urlFromCamera = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Camera(cameras: cameras, status: Status,)),
                                          );
                                          print(urlFromCamera);
                                          if (urlFromCamera != null) {
                                           
                                          }
                                        } else showToast('Microphone Permission denied', context);
                                        break;
                                      case PermissionStatus.granted :
                                      // TODO
                                        urlFromCamera = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Camera(cameras: cameras, status: Status,)),
                                        );
                                        print(urlFromCamera);
                                        if (urlFromCamera != null) {
                                         
                                        }
                                        break;
                                      default :
                                        showToast('Microphone Permission denied', context);
                                        break;
                                    }
                                    break;
                                  default :
                                    showToast('Camera Permission Denied', context);
                                    break;
                                }
                                break;
                              default :
                                showToast('Storage Permission denied', context);
                                break;
                            }
                            // _recordVideo();
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
        );
        break;
      case currentState.uploading:
        return Center(
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
                          value: _bytesTransferred(snapshot) / 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('${_bytesProgress(snapshot)} % Uploaded...',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AwsomeVideoPlayer(
                    fetchUrl ?? "",
                  playOptions: VideoPlayOptions(
                    aspectRatio: 1 / 1,
                    loop: true,
                    autoplay: false,
                  ),
                  videoStyle: VideoStyle(
                    videoControlBarStyle: VideoControlBarStyle(
                      fullscreenIcon: SizedBox(),
                      forwardIcon: SizedBox(),
                      rewindIcon: SizedBox()
                    ),
                    videoTopBarStyle: VideoTopBarStyle(
                      popIcon: Container()
                    )
                  ),
                ),
              ),
              Icon(
                Icons.done_outline,
                size: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Your Video Intro Has Been Uploaded Succesfully!",
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
                          fontSize: 18.0,
                          color: basicColor,
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
                          //Navigator.of(context).pop();
                        },
                        btnOkOnPress: () async {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(fileVideocontroller != null)
      fileVideocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
