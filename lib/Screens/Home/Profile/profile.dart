import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;
import 'package:apli/Screens/Home/Profile/editResume.dart';
import 'package:apli/Models/user.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum currentState { none, uploading, success, failure }

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String fileType = 'video';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  FirebaseUser user;
  String result = '';
  String fetchUrl;
  currentState x = currentState.none;

  userAddVideoUrl(String url) async {
    user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('candidates')
        .document(user.email)
        .updateData({'video_resume': url});
  }

  usergetVideoUrl() async {
    user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('candidates')
        .document(user.email)
        .get()
        .then((snapshot) => fetchUrl = snapshot.data['video_resume']);
    print(fetchUrl);
  }

 

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("videos/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    if (uploadTask.isInProgress) {
      setState(() {
        x = currentState.uploading;
      });
      print(uploadTask.lastSnapshot.bytesTransferred.toString());
    }
    if (url != null) {
      setState(() {
        x = currentState.success;
        print("URL is $url");
      });
      userAddVideoUrl(url);
    } else if (url == null) {
      x = currentState.failure;
    }
  }

  Future filePicker(BuildContext context) async {
    try {
      file = await FilePicker.getFile(type: FileType.video);
      fileName = p.basename(file.path);
      setState(() {
        fileName = p.basename(file.path);
      });
      print(fileName);
      _uploadFile(file, fileName);
    } catch (e) {
      AwesomeDialog(context: context, dialogType: DialogType.WARNING).show();
    }
  }

  Widget uploadVideo() {
    switch (x) {
      case currentState.none:
        if (fetchUrl == null) {
          return Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: basicColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      child: Text(
                        "Upload From Gallery",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: basicColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        filePicker(context);
                        setState(() {
                          x = currentState.uploading;
                        });
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: basicColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      child: Text(
                        "Record Now",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: basicColor,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => null),
                ),
              ],
            ),
          );
        }
        return Icon(Icons.done_outline);

        break;
      case currentState.uploading:
        return Text("Uploading Your Resume!");
        break;
      case currentState.success:
        return Icon(Icons.done_outline);
      default:
        return null;
    }
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    
    usergetVideoUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<User>(context);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: customDrawer(context, user),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
            ],
            title: Text(
              profile,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  tabs: [
                    new Tab(
                      text: resume,
                    ),
                    new Tab(
                      text: videoIntro,
                    ),
                    new Tab(text: psychTest)
                  ],
                  controller: _tabController,
                )),
          ),
          preferredSize: Size.fromHeight(120),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    resumeSlogan,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Image.asset("Assets/Images/job.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(EvaIcons.editOutline),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditResume()),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(EvaIcons.shareOutline),
                              onPressed: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(EvaIcons.downloadOutline),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem Ipsum",
                          style: TextStyle(fontSize: 20)),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem Ipsum",
                          style: TextStyle(fontSize: 20)),
                      alignment: Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      child: Text("1. Lorem Ipsum",
                          style: TextStyle(fontSize: 20)),
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
          ),
          Center(child: Image.asset("Assets/Images/job.png")),
        ], controller: _tabController));
  }
}
