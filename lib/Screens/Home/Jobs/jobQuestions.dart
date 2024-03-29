import 'dart:async';
import 'dart:io';

import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/animations.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import '../../HomeLoginWrapper.dart';

enum currentState { recording, uploading, success, failure }

class JobQuestions extends StatefulWidget {
  final List questions;
  final String logo;
  final String jobID;
  final int whereToStart;
  const JobQuestions(
      {Key key,
      @required this.questions,
      this.whereToStart,
      this.jobID,
      this.logo})
      : super(key: key);
  @override
  _JobQuestionsState createState() => _JobQuestionsState();
}

class _JobQuestionsState extends State<JobQuestions> {
  // THIS IS WHERE LIVE INTERVIEW TAKES PLACE //
  // AS YOU WOULD EXPECT WE PASS JOB ID , QUESTIONS PACKAGE TO THIS SCREEN //
  // IF A JOB IS LEFT INCOMPLETE THEN WE MAKE USE OF THE STARTFROM VARIABLE TO CONTINUE FROM THAT QUESTION //
  // BELOW METHODS ARE USED TO INIT THE CAMERA //
  // FIRST THE CANDIDATE IS GIVEN 30 SECONDS TO READ THE QUESTION => RECORDING INTERVIEW => UPLOADING THE INTERVIEW USING FIREBASE STORAGE => CALLING THE API TO UPDATE VIDEO LINKS IN FIREBASE DATABSE //

  double height, width;
  CameraController controller;
  bool isRecordingStopped = true;
  String path;
  Timer _timer, _timerRead;
  int seconds = 0, minute = 0, readSeconds = 0;
  String email;
  String fileType = 'video';
  File file;
  bool _isRecording = false;
  String fileName = '';
  String urlFromCamera;
  bool loading = false;
  bool isUploaded = true, error = false;
  StorageUploadTask uploadTask;
  String tempURL;
  bool isReading = true;
  int indexOfQuestions;
  currentState x = currentState.recording;
  List qs = [];
  List<CameraDescription> cameras;
  String name = Timestamp.now().toString();
  APIService apiService = APIService();

  camInit() async {
    qs = widget.questions;
    if (widget.whereToStart != null) {
      indexOfQuestions = widget.whereToStart;
    } else {
      indexOfQuestions = 0;
    }
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low);
    if (widget.questions != null) {
      if (widget.questions.length > 0) {
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          //startVideoRecording();
          readTimer();
          setState(() {});
        });
      } else {
        showToast('Error occurred, try again later', context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Wrapper(
                      currentTab: 2,
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      showToast('Error occurred, try again later', context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Wrapper(
                    currentTab: 2,
                  )),
          (Route<dynamic> route) => false);
    }

    //startTimer();
  }

  Widget companyLogo(String link) {
    if (link == null) {
      return Image.asset("Assets/Images/logo.png");
    } else {
      return CachedNetworkImage(
        width: 70,
        height: 70,
        imageUrl: link,
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
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
    // RETURNS UPLOADING PROGRESS //
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Leaving the window will mark the job as incomplete',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  stopVideoRecording(true);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Wrapper(
                                currentTab: 2,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: new Text(
                  'Yes',
                  style: TextStyle(),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _uploadFile(File file, String filename) async {
    // SAME FUNCTION AFTER FILE PICKER => UPLOAD FILES TO FIREBASE STORAGE //

    SharedPreferences.getInstance().then((value) async {
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance.ref().child(
          "jobInterviews/${widget.jobID}/${value.getString('email')}/$filename");
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
        setState(() {
          loading = true;
        });

        // NOW SINCE THE URL IS NOT NULL , THAT MEANS VIDEO IS UPLOADED //
        // WE USE THIS URL TO CALL THE API SO THAT IT SAVES , AND AGAIN WE MOVE TO NEXT QUESTION //
        //IF THE QUESTION IS LAST , WE SUBMIT THE INTERVIEW AND NAVIGATE BACK TO MAIN JOB SCREEN //

        if (indexOfQuestions + 1 < qs.length) {
          dynamic result = await apiService.submitInterViewQ(
              widget.jobID, "addVideo", qs[indexOfQuestions]['id'], url);
          if (result != -1 || result != -2 || result != 0) {
            print('abcd');
            print(result);
            print('abcd');
            setState(() {
              loading = false;
//              indexOfQuestions = indexOfQuestions + 1;
//              isReading = true;
//              _isRecording = false;
//              readTimer();
              // x = currentState.recording;
              // startVideoRecording();
            });
          } else {
            showToast('Error occurred, try again later', context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Wrapper(
                          currentTab: 2,
                        )),
                (Route<dynamic> route) => false);
          }
          setState(() {
            x = currentState.success;
            tempURL = url;
          });
        } else {
          setState(() {
            loading = true;
          });
          dynamic result = await apiService.submitInterViewQ(
              widget.jobID, "addVideo", qs[indexOfQuestions]['id'], url);
          if (result != -1 || result != -2 || result != 0) {
            showToast("Submitting your answers", context);
            print(result);
            dynamic finalResult = await apiService.submitInterViewQ(
                widget.jobID, "final", null, null);
            if (finalResult != -1 || finalResult != -2 || finalResult != 0) {
              showToast("Submitted Successfully", context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Wrapper(
                            currentTab: 2,
                          )),
                  (Route<dynamic> route) => false);
              print(finalResult);
            }
          } else {
            showToast('Error occurred, try again later', context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Wrapper(
                          currentTab: 2,
                        )),
                (Route<dynamic> route) => false);
          }
        }

        // MOVE TO NEXT QUESTION
      } else if (url == null) {
        showToast('Error occurred, try again later', context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Wrapper(
                      currentTab: 2,
                    )),
            (Route<dynamic> route) => false);
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

  Widget buttonToShow() {
    if (indexOfQuestions + 1 < qs.length) {
      return RaisedButton(
          color: basicColor,
          elevation: 0,
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0),
          ),
          child: Text(
            'NEXT',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            setState(() {
              indexOfQuestions = indexOfQuestions + 1;
              isReading = true;
              _isRecording = false;
              readTimer();
            });
//            setState(() {
//              loading = true;
//            });
//            dynamic result = await apiService.submitInterViewQ(
//                widget.jobID, "addVideo", qs[indexOfQuestions]['id'], tempURL);
//            if (result != -1 || result != -2 || result != 0) {
//              print(result);
//              setState(() {
//                loading = false;
//                indexOfQuestions = indexOfQuestions + 1;
//                isReading = true;
//                _isRecording = false;
//                readTimer();
//                // x = currentState.recording;
//                // startVideoRecording();
//              });
//            } else {
//              showToast('Error occurred, try again later', context);
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (context) => Wrapper(
//                            currentTab: 2,
//                          )),
//                  (Route<dynamic> route) => false);
//            }
          });
    } else {
      return RaisedButton(
          color: basicColor,
          elevation: 0,
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0),
          ),
          child: Text(
            'SUBMIT',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Wrapper(
                          currentTab: 2,
                        )),
                (Route<dynamic> route) => false);
//            setState(() {
//              loading = true;
//            });
//            dynamic result = await apiService.submitInterViewQ(
//                widget.jobID, "addVideo", qs[indexOfQuestions]['id'], tempURL);
//            if (result != -1 || result != -2 || result != 0) {
//              showToast("Submitting your answers", context);
//              print(result);
//              dynamic finalResult = await apiService.submitInterViewQ(
//                  widget.jobID, "final", null, null);
//              if (finalResult != -1 || finalResult != -2 || finalResult != 0) {
//                showToast("Submitted Successfully", context);
//                Navigator.of(context).pushAndRemoveUntil(
//                    MaterialPageRoute(
//                        builder: (context) => Wrapper(
//                              currentTab: 2,
//                            )),
//                    (Route<dynamic> route) => false);
//                print(finalResult);
//              }
//            }
          });
    }
  }

  Future<void> stopVideoRecording(bool backPressed) async {
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
      if (backPressed != true) {
        videoPicker(path);
      }
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
            if (seconds >= 59) {
              stopVideoRecording(false);
            }
          });
        else
          return;
      },
    );
  }

  void readTimer() {
    const oneSecRead = const Duration(seconds: 1);
    _timerRead = new Timer.periodic(
      oneSecRead,
      (Timer timer) {
        if (mounted)
          setState(() {
            readSeconds = readSeconds + 1;
            if (readSeconds >= 30) {
              setState(() {
                isReading = false;

                stopReadingTimer();
                x = currentState.recording;
                startVideoRecording();
              });
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

  void stopReadingTimer() {
    readSeconds = 0;
    _timerRead.cancel();
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller.dispose();
    _timer?.cancel();
    _timerRead.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.enable();
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
    if (controller == null) {
      return Loading();
    } else if (!controller.value.isInitialized &&
        _isRecording == false &&
        isReading == false)
      return Loading();
    else if (_isRecording == false &&
        x == currentState.uploading &&
        isReading == false) {
      return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
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
                                    fontWeight: FontWeight.bold,
                                  )),
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(
                //       width * 0.1, height * 0.04, width * 0.1, height * 0.04),
                //   child: Text(
                //     (indexOfQuestions + 1).toString() +
                //             ". " +
                //             qs[indexOfQuestions]['question'] ??
                //         "",
                //     style: TextStyle(
                //         fontWeight: FontWeight.w900,
                //         fontSize: 14,
                //         letterSpacing: 1.2),
                //     textAlign: TextAlign.justify,
                //   ),
                // ),
                RaisedButton(
                    color: Colors.grey,
                    elevation: 0,
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
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
        ),
      );
    } else if (_isRecording == false && isReading == true) {
      return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  companyLogo(widget.logo),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.1, height * 0.07, width * 0.1, 0),
                    child: Text(
                      (indexOfQuestions + 1).toString() +
                              ". " +
                              qs[indexOfQuestions]['question'] ??
                          "",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.2),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.07, 10, width * 0.07, 8),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Text(
                                "Your Video Will Appear Here.\nYou Have 30 Seconds To Read!"),
                          ))),
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
                            ((readSeconds.toString().length == 1)
                                ? ('0' + readSeconds.toString())
                                : (readSeconds.toString())),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //     padding:
                  //         EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                  //     child: new MyLinearProgressIndicator(
                  //       milliSeconds: 15000,
                  //     )),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )),
        ),
      );
    } else if (_isRecording == false &&
        x == currentState.success &&
        isReading == false) {
      return loading
          ? Loading()
          : WillPopScope(
              onWillPop: () => _onWillPop(),
              child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
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
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(' Uploading 100 %',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ],
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(width * 0.1, height * 0.04,
                      //       width * 0.1, height * 0.04),
                      //   child: Text(
                      //     (indexOfQuestions + 1).toString() +
                      //             ". " +
                      //             qs[indexOfQuestions]['question'] ??
                      //         "",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w900,
                      //         fontSize: 14,
                      //         letterSpacing: 1.2),
                      //     textAlign: TextAlign.justify,
                      //   ),
                      // ),
                      buttonToShow()
                    ],
                  ),
                ),
              ),
            );
    }
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.1, height * 0.07, width * 0.1, 0),
                    child: Text(
                      (indexOfQuestions + 1).toString() +
                              ". " +
                              qs[indexOfQuestions]['question'] ??
                          "",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.2),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.07, 10, width * 0.07, 8),
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
                      padding: EdgeInsets.only(
                          left: width * 0.1, right: width * 0.1),
                      child: new MyLinearProgressIndicator(
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
                        stopVideoRecording(false);
                      }),
                ],
              ),
            )),
      ),
    );
  }
}
