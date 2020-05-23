import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum currentState { none, uploading, success, failure }

class AppliedDetails extends StatefulWidget {
  final Map company;
  final int status;
  final String st;

  const AppliedDetails({Key key, this.company, this.status, @required this.st})
      : super(key: key);

  @override
  _AppliedDetailsState createState() => _AppliedDetailsState();
}

class _AppliedDetailsState extends State<AppliedDetails> {
  String tempURL;
  StorageUploadTask uploadTask;
  currentState x = currentState.none;
  File fileToUpload;

  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    String tempPath = 'storage/emulated/0/Download/resume' +
        DateTime.now().toString() +
        '.pdf';
    final File tempFile = File(tempPath);
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    print(bodyBytes);
    task.future.whenComplete(() {
      showToast("Downloaded", context);
    });
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path \nBytes Count :: $byteCount',
    );
  }

  Future filePicker(BuildContext context) async {
    try {
      File file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
      );
      if (file != null) {
        setState(() {
          fileToUpload = file;

          //currentFileNames[index] = p.basename(file.path);
        });
        _uploadFile(file, "offerletter");
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

  Future<void> _uploadFile(File file, String filename) async {
    SharedPreferences.getInstance().then((value) async {
      String name = Timestamp.now().toString();
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("offerLetters/${value.getString('email')}/$name");
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
          x = currentState.success;
          tempURL = url;
        });
        print(url);

        // MOVE TO NEXT QUESTION
      } else if (url == null) {
        setState(() {
          x = currentState.failure;
        });
      }
    });
  }

  Widget button(String status, Map company) {
    switch (status) {
      case "OFFERED":
        bool deadlineOver = company['accept_deadline_passed'] ?? false;
        bool candAccepted = company[' cand_accepted_job'] ?? false;
        if (deadlineOver || candAccepted) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: RaisedButton(
                  onPressed: null,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'APPLY NOW',
                    style: TextStyle(color: Colors.white),
                  )));
        } else {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: RaisedButton(
                  onPressed: () {
                    print("CALL ME");
                  },
                  color: Colors.grey,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'APPLY NOW',
                    style: TextStyle(color: Colors.white),
                  )));
        }

        break;
      case "INTERVIEW":
        if (company['schedule']['is_online'] != true) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: Column(
                children: [
                  Text("Where :" + company['schedule']['where'].toString()),
                  //Text("When :" + company['schedule']['when'].toString())
                ],
              ));
        } else if (company['interview_date_passed'] ||
            company['schedule']['cand_accepted']) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: RaisedButton(
                  onPressed: null,
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'ACCEPT INTERVIEW',
                    style: TextStyle(color: Colors.white),
                  )));
        } else if (company['interview_room_link'] != null &&
            company['schedule']['cand_accepted']) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: RaisedButton(
                  onPressed: () async {
                    var url =
                        company['interview_room_link'] ?? 'https://flutter.dev';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                    print("INTERVIEW ");
                  },
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'OPEN INTERVIEW',
                    style: TextStyle(color: Colors.white),
                  )));
        } else {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: RaisedButton(
                  onPressed: () {
                    print("CALL ME");
                  },
                  elevation: 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: basicColor, width: 1.2),
                  ),
                  child: Text(
                    'ACCEPT INTERVIEW',
                    style: TextStyle(color: Colors.white),
                  )));
        }
        break;
      case "LETTER SENT":
        if (company['offer_letter'] != null) {
          return Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: RaisedButton(
                      onPressed: () async {
                        bool allowed = false;
                        var storageStatus = await Permission.storage.status;
                        if (storageStatus == PermissionStatus.granted) {
                          allowed = true;
                        } else if (storageStatus ==
                            PermissionStatus.undetermined) {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                          if (statuses[Permission.storage] ==
                              PermissionStatus.granted) {
                            allowed = true;
                          }
                        }
                        if (allowed) {
                          if (company['offer_letter'] != null) {
                            String firebaseUrl = company['offer_letter']
                                .replaceAll(
                                    pdfUrltoBeReplaced, pdfUrltoreplacedWith);
                            firebaseUrl = firebaseUrl.replaceAll("%40", "@");
                            print(firebaseUrl);

                            var ref = FirebaseStorage.instance
                                .getReferenceFromUrl(firebaseUrl);

                            await ref.then((reference) {
                              showToast("Downloading", context, duration: 1);
                              downloadFile(reference);
                            });
                          } else {
                            showToast(
                                "Please Complete Your Profile First!", context);
                          }
                        }
                      },
                      color: Colors.green,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: basicColor, width: 1.2),
                      ),
                      child: Text(
                        'DOWNLOAD LETTER',
                        style: TextStyle(color: Colors.white),
                      ))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: RaisedButton(
                      onPressed: () {
                        filePicker(context);
                      },
                      color: Colors.green,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: basicColor, width: 1.2),
                      ),
                      child: Text(
                        'UPLOAD LETTER',
                        style: TextStyle(color: Colors.white),
                      ))),
            ],
          );
        } else {
          return Container();
        }
        break;
      case "ACCEPTED":
        return ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(status ?? "", style: TextStyle(color: Colors.white)),
            ),
          ),
        );
        break;
      case "UNREVIEWED":
        return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: RaisedButton(
                onPressed: null,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: basicColor, width: 1.2),
                ),
                child: Text(
                  'APPLY NOW',
                  style: TextStyle(color: Colors.white),
                )));
        break;
      case "REJECTED":
        return Container();
      case "HIRED":
        return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: RaisedButton(
                onPressed: null,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: basicColor, width: 1.2),
                ),
                child: Text(
                  'APPLY NOW',
                  style: TextStyle(color: Colors.white),
                )));
        break;
      default:
        return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: RaisedButton(
                onPressed: null,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: basicColor, width: 1.2),
                ),
                child: Text(
                  'APPLY NOW',
                  style: TextStyle(color: Colors.white),
                )));
    }
  }

  final _APIService = APIService();
  bool loading = false;

  @override
  void initState() {
    print(widget.company);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 18.0, left: 10.0, right: 10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {},
                                    title: AutoSizeText(
                                      widget.company['role'] ??
                                          "Role not declared",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: basicColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            widget.company['location'] ??
                                                "Location not declared",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          AutoSizeText(
                                            'Deadline: ' +
                                                    widget
                                                        .company['deadline'] ??
                                                "No Deadline yet",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  widget.company['ctc'] != null
                                      ? ListTile(
                                          dense: true,
                                          title: RichText(
                                            text: TextSpan(
                                              text: 'Jobs CTC : ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        widget.company['ctc'] ??
                                                            "Not Specified",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['notice_period'] != null
                                      ? ListTile(
                                          dense: true,
                                          title: RichText(
                                            text: TextSpan(
                                              text: 'Notice Period : ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: widget.company[
                                                            'notice_period'] ??
                                                        "Not Specified",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['description'] != null
                                      ? ListTile(
                                          title: AutoSizeText(
                                            "Role Description : ",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.company[
                                                          'description'] ??
                                                      "Not Specified",
                                                  maxLines: 4,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['key_resp'] != null
                                      ? ListTile(
                                          title: AutoSizeText(
                                            "Key Responsibilities : ",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.company['key_resp'] ??
                                                      "Not Specified",
                                                  // maxLines: 4,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['soft_skills'] != null
                                      ? ListTile(
                                          title: AutoSizeText(
                                            "Soft Skills : ",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: widget
                                                        .company['soft_skills']
                                                        .length ??
                                                    1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    widget.company[
                                                                'soft_skills']
                                                            [index] ??
                                                        "None",
                                                    //maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                }),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['tech_skills'] != null
                                      ? ListTile(
                                          title: AutoSizeText(
                                            "Technical Skills  : ",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: widget
                                                        .company['tech_skills']
                                                        .length ??
                                                    1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    widget.company[
                                                                'tech_skills']
                                                            [index] ??
                                                        "None",
                                                    //maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                }),
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.company['requirements'] != null
                                      ? ListTile(
                                          title: AutoSizeText(
                                            "Requirements : ",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: (widget.company[
                                                                'requirements'] ??
                                                            [])
                                                        .length ??
                                                    1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    widget.company[
                                                                'requirements']
                                                            [index] ??
                                                        "No specific requirements",
                                                    //maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                }),
                                          ),
                                        )
                                      : SizedBox(),
                                  button(
                                      widget.company['status'], widget.company)
                                ]),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}
