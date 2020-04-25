import 'dart:async';
import 'dart:io';
import 'package:apli/Screens/Home/Courses/courseVideo.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          seconds = seconds + 1;
          if (seconds == 60) {
            minute = minute + 1;
            seconds = 0;
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
      return Container(
        color: Colors.black,
        height: height,
        width: width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                color: Colors.white,
                child: Text(
                  "Play Video",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  print(path);
                  if (path != null) {
                    File temp = File(path);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => VideoApp(
                              videoUrl: null,
                              title: "My Resume",
                              isCourse: false,
                              file: temp,
                            )));
                  } else {
                    Navigator.pop(context);
                  }
                }),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                  color: Colors.white,
                  child: Text(
                    "Upload",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    print(path);
                    if (path != null) {
                      Navigator.pop(context, path);
                    } else {
                      Navigator.pop(context);
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                  color: Colors.white,
                  child: Text(
                    "Re-Take",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    final dir = Directory('storage/emulated/0/apli/');
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
    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.black,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            minute.toString() + " : " + seconds.toString() ?? "",
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: Icon(
              Icons.crop_rotate,
              color: Colors.white,
            ),
            onPressed: () {
              _onCameraSwitch();
            },
          ),
        ],
      ),
    );
  }

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    startTimer();

    final String dirPath = 'storage/emulated/0/apli';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await controller.startVideoRecording(filePath);
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
    stopTimer();
    setState(() {
      _isRecording = false;
      isRecordingStopped = true;
    });

    try {
      await controller.stopVideoRecording();
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

  @override
  void initState() {
    controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
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
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Stack(
        children: <Widget>[_buildCameraPreview(), _options()],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
