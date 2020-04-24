import 'dart:async';
import 'dart:io';
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

  Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _start = _start + 1;
        },
      ),
    );
  }

  void stopTimer() {
    _start = 0;
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
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

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
          Text(_start.toString()??"" , style: TextStyle(color:Colors.white),),
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
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
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
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Stack(
        children: <Widget>[_buildCameraPreview()],
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
