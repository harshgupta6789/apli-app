import 'dart:io';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum currentState { none, uploading, success, failure }

class UploadResumeScreen extends StatefulWidget {
  @override
  _UploadResumeScreenState createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  double height, width;
  String path;
  String email;
  File file;
  String fileName = '';
  bool loading = false;
  bool isUploaded = true, error = false;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;
  StorageUploadTask uploadTask;
  String resumeText;
  List<String> resumeList = ["MEWO.pdf", "HELLO.pdf"];

  List<CameraDescription> cameras;
  camInit() async {
    cameras = await availableCameras();
  }

  @override
  void initState() {
    camInit();
    super.initState();
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
        // CALL API
      } else if (url == null) {
        x = currentState.failure;
      }
    });
  }

  Widget toShow() {
    if (x == currentState.none) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              resumeText != null
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          resumeText = null;
                        });
                      },
                      child: TextFormField(
                        enabled: false,
                        initialValue: resumeText,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        decoration: loginFormField.copyWith(
                            hintText: resumeText ?? "Select A Resume",
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.school, color: basicColor),
                            suffixIcon: Icon(Icons.delete)),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        String x = await showDialog(
                            context: context,
                            builder: (_) {
                              return MyDialogContent(listToSearch: resumeList);
                            });
                        setState(() {
                          resumeText = x;
                        });
                        print(x);
                      },
                      child: TextFormField(
                        enabled: false,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        decoration: loginFormField.copyWith(
                            hintText: resumeText ?? "Select A Resume",
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.school, color: basicColor),
                            suffixIcon: Icon(Icons.keyboard_arrow_up)),
                      ),
                    ),
              SizedBox(
                height: height * 0.02,
              ),
              Visibility(
                child: RaisedButton(
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
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool storage = false, camera = false, microphone = false;
                      var storageStatus = await Permission.storage.status;
                      if (storageStatus == PermissionStatus.granted) {
                        storage = true;
                      } else if (storageStatus ==
                          PermissionStatus.undetermined) {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                        ].request();
                        if (statuses[Permission.storage] ==
                            PermissionStatus.granted) {
                          storage = true;
                        }
                      }
                      var cameraeStatus = await Permission.camera.status;
                      if (cameraeStatus == PermissionStatus.granted) {
                        camera = true;
                      } else if (cameraeStatus ==
                          PermissionStatus.undetermined) {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.camera,
                        ].request();
                        if (statuses[Permission.camera] ==
                            PermissionStatus.granted) {
                          camera = true;
                        }
                      }
                      var microphoneStatus = await Permission.microphone.status;
                      if (microphoneStatus == PermissionStatus.granted) {
                        microphone = true;
                      } else if (microphoneStatus ==
                          PermissionStatus.undetermined) {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.microphone,
                        ].request();
                        if (statuses[Permission.microphone] ==
                            PermissionStatus.granted) {
                          microphone = true;
                        }
                      }
                      if (storage && camera && microphone)
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => JobQuestions(
                        //               cameras: cameras,
                        //             )));

                        // showToast('Permission denied', context,
                        //     color: Colors.red);
                        ;
                    }),
              ),
            ]),
      );
    } else if (x == currentState.uploading) {
      return Center(
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
                          child:
                              Text(' Uploading  ${_bytesProgress(snapshot)} %',
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
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                "Add Resume",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            )),
        preferredSize: Size.fromHeight(50),
      ),
      body: toShow(),
    );
  }
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
    this.listToSearch,
  }) : super(key: key);
  final listToSearch;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  TextEditingController editingController = TextEditingController();
  String val;
  var items = List<dynamic>();

  @override
  void initState() {
    items.addAll(widget.listToSearch);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(widget.listToSearch);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        val = query;
      });

      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.listToSearch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              autofocus: true,
              controller: editingController,
              decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: basicColor),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)))),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                    onTap: () {
                      Navigator.pop(context, '${items[index]}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
