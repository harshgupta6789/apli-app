import 'dart:async';
import 'dart:io';
import 'package:apli/Screens/HomeLoginWrapper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/functions.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum currentState { none, uploading, success, failure }

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Camera({Key key, @required this.cameras}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  double height, width;
  bool isRecordingStopped = false;
  String path;
  Timer _timer;
  int seconds = 0, minute = 0;
  String email;
  String fileType = 'video';
  File file;
  String fileName = '';
  String urlFromCamera;
  bool loading = false;
  bool isUploaded = true, error = false;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;
  StorageUploadTask uploadTask;

  userAddVideoUrl(String url) async {
    Firestore.instance
        .collection('candidates')
        .document(email)
        .updateData({'video_resume': url}).then((onValue) {
      setState(() {
        fetchUrl = url;

        print(fetchUrl);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Wrapper(
                      currentTab: 3,
                    )),
            (Route<dynamic> route) => false);
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
    } on Exception catch (e) {
      print(e);
    }
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

  Future<void> _uploadFile(File file, String filename) async {
    SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("resumeVideos/$filename}");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      if (uploadTask.isInProgress) {
        if (mounted)
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

  Future videoPicker(String path) async {
    file = File(path);
    print('a');
    fileName = p.basename(path);
    if (mounted)
      setState(() {
        fileName = p.basename(path);
      });
    print(fileName);
    _uploadFile(file, fileName);
    print('a');
    setState(() {
      x = currentState.uploading;
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          seconds = seconds + 1;
          if (seconds >= 59 && _isRecording) {
            stopVideoRecording();
          }
        },
      ),
    );
  }

  void stopTimer() {
    seconds = 0;
    _timer?.cancel();
  }

  //final _timerKey = GlobalKey<VideoTimerState>();
  bool _isRecording = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (controller.description == widget.cameras[0])
            ? widget.cameras[1]
            : widget.cameras[0];
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {}
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget _options() {
    if (isRecordingStopped)
      switch (x) {
        case currentState.none:
          return Container(
            color: Colors.black,
            height: height,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: MaterialButton(
                  //       color: Colors.white,
                  //       child: Text(
                  //         "Play Video",
                  //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  //       ),
                  //       onPressed: () {
                  //         if (path != null) {
                  //           File temp = File(path);

                  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //               builder: (BuildContext context) => VideoApp(
                  //                     videoUrl: null,
                  //                     title: "My Resume",
                  //                     isCourse: false,
                  //                     file: temp,
                  //                   )));
                  //         } else {
                  //           Navigator.pop(context);
                  //         }
                  //       }),
                  // ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              color: Colors.white,
                              child: Text(
                                "Upload",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                if (path != null) {
                                  videoPicker(path);
                                  // Navigator.pop(context, path);
                                  // showToast(
                                  //     'Recorded Video Will Be Stored In Storage/Apli Folder',
                                  //     context);

                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              color: Colors.white,
                              child: Text(
                                "Re-Take",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                final dir =
                                    Directory('storage/emulated/0/apli/');
                                try {
                                  dir.deleteSync(recursive: true);
                                  setState(() {
                                    isRecordingStopped = false;
                                  });
                                } on Exception catch (e) {
                                  print(e);
                                  setState(() {
                                    isRecordingStopped = false;
                                  });
                                }
                              }),
                        ),
                      ])
                ]),
          );
          break;
        case currentState.uploading:
          return Container(
            color: Colors.black,
            height: height,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<StorageTaskEvent>(
                      stream: uploadTask.events,
                      builder: (context,
                          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
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
                                    '${_bytesProgress(snapshot)} % Uploaded...',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          );
                        }
                        return Align(child: Text("Uploading Your Resume!..."));
                      }),
                ]),
          );
          break;
        case currentState.success:
          return Container();
          break;
        case currentState.failure:
          break;
      }

    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.black,
      height: 100.0,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                (_isRecording) ? Icons.stop : Icons.videocam,
                size: 28.0,
                color: (_isRecording) ? Colors.red : Colors.white,
              ),
              onPressed: () {
                if (_isRecording) {
                  stopVideoRecording();
                } else {
                  startVideoRecording();
                }
              },
            ),
            Text(
              '0' +
                      minute.toString() +
                      " : " +
                      ((seconds.toString().length == 1) ? '0' : '') +
                      seconds.toString() ??
                  "",
              style: TextStyle(color: Colors.white),
            ),
            Visibility(
              visible: !_isRecording,
              child: IconButton(
                icon: Icon(
                  Icons.autorenew,
                  color: Colors.white,
                ),
                onPressed: () {
                  _onCameraSwitch();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final String dirPath = 'storage/emulated/0/apli';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await controller.startVideoRecording(filePath);
      setState(() {
        _isRecording = true;
      });
//    AwesomeDialog(
//            context: context,
//            dialogType: DialogType.WARNING,
//            tittle: "Note",
//            body: Text("Video Will Be Stopped After 1 Minute"))
//        .show();
      startTimer();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    path = filePath;
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
      stopTimer();
      setState(() {
        _isRecording = false;
        isRecordingStopped = true;
        showToast(
            'Recorded Video Will Be Stored In Storage/Apli Folder', context);
      });
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  void init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("email") != null) {
      setState(() {
        email = preferences.getString("email");
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      bottomNavigationBar:
          isRecordingStopped ? SizedBox() : _buildBottomNavigationBar(),
      body: Stack(
        children: <Widget>[_buildCameraPreview(), _options()],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
