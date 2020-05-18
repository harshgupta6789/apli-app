import 'dart:async';
import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobQuestions extends StatefulWidget {
   final List<CameraDescription> cameras;

  const JobQuestions({Key key, this.cameras}) : super(key: key);
  @override
  _JobQuestionsState createState() => _JobQuestionsState();
}

class _JobQuestionsState extends State<JobQuestions> {
double height , width;
CameraController controller;
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
  StorageUploadTask uploadTask;
  int Status;
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
       appBar: PreferredSize(
          child: AppBar(
              backgroundColor: basicColor,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context)),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Apply",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              )),
          preferredSize: Size.fromHeight(50),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
              child: Column(
                children: [_buildCameraPreview()],
              )),
        ));
  }
}