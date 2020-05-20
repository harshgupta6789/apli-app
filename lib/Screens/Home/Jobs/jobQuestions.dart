import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:apli/Shared/animations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum currentState { none, uploading, success, failure }

class JobQuestions extends StatefulWidget {
  final List<CameraDescription> cameras;

  const JobQuestions({Key key, this.cameras}) : super(key: key);
  @override
  _JobQuestionsState createState() => _JobQuestionsState();
}

class _JobQuestionsState extends State<JobQuestions> {
  double height, width;
  CameraController controller;
  bool isRecordingStopped = false;
  String path;
  Timer _timer;
  int seconds = 0, minute = 0;
  String email;
  String fileType = 'video';
  File file;
  bool _isRecording = true;
  String fileName = '';
  String urlFromCamera;
  bool loading = false;
  bool isUploaded = true, error = false;
  StorageUploadTask uploadTask;
  int Status;
  currentState x = currentState.none;
  List<CameraDescription> cameras;
  String name = Timestamp.now().toString();

  camInit() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      startVideoRecording();
      setState(() {});
    });
    //startTimer();
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
          .child("resumeVideos/${value.getString('email')}");
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
        // MOVE TO NEXT QUESTION
      } else if (url == null) {
        x = currentState.failure;
      }
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    name = Timestamp.now().toString();
    final String dirPath = 'storage/emulated/0/apli';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/$name.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await controller.startVideoRecording(filePath);
      setState(() {
        _isRecording = true;
      });
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
      });
      videoPicker(path);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted)
          setState(() {
            seconds = seconds + 1;
            print('abcd');
            if (seconds >= 60) {
              stopVideoRecording();
            }
          });
        else
          return;
      },
    );
  }

  void stopTimer() {
    seconds = 0;
    _timer?.cancel();
  }

  @override
  void initState() {
    camInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    if (controller == null) {
      return Loading();
    } else if (!controller.value.isInitialized && _isRecording == false)
      return Loading();
    else if (_isRecording == false && x == currentState.uploading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                                  color: Colors.black,
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
                    width * 0.1, height * 0.04, width * 0.1, height*0.04),
                child: Text(
                  '1. Tell me about your education',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.2),
                  textAlign: TextAlign.left,
                ),
              ),
              RaisedButton(
                  color: Colors.grey,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30 ,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 0),
                  ),
                  child: Text(
                    'WAIT',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.1, height * 0.07, width * 0.1, 0),
              child: Text(
                '1. Tell me about your educationTell me about your education',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(width * 0.07, 10, width * 0.07, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                )),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.timer),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '00:' +
                      ((seconds.toString().length == 1)
                          ? ('0' + seconds.toString())
                          : (seconds.toString())),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: MyLinearProgressIndicator(
                  milliSeconds: 60000,
                )),
            SizedBox(
              height: 5,
            ),
            RaisedButton(
                color: Colors.red,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(width: 0),
                ),
                child: Text(
                  'DONE',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  stopVideoRecording();
                }),
          ],
        ),
      )),
    );
  }
}