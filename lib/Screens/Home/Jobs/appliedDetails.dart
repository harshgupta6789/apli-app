import 'dart:io';

import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../HomeLoginWrapper.dart';

class AppliedDetails extends StatefulWidget {
  final Map job;
  final int status;
  final String st;
  final bool isApplied;

  const AppliedDetails(
      {Key key, this.job, this.status, @required this.st, this.isApplied})
      : super(key: key);

  @override
  _AppliedDetailsState createState() => _AppliedDetailsState();
}

class _AppliedDetailsState extends State<AppliedDetails> {
  // THIS CLASS IS ALMOST AS SAME AS THE COMPAY DETAILS CLASS , EXCEPT THIS IS USED WHEN USER CLICKS ON A JOB THAT HE APPLIED TO EARLIER //
  // DEPENDING UPON THE JOB STATUS , AGAIN WE DIFFERENTIATE THE UI //
  // IN THE ARGUMENTS , THE ENTIRE MAP FOR ONE JOB IS PASSED ALONG WITH STATUS OF THR JOB WHICH IS USED AS PARAM //

  String tempURL;
  StorageUploadTask uploadTask;
  File fileToUpload;
  bool interOffer = false;
  final apiService = APIService();

  Widget companyLogo(String link) {
    if (link == null) {
      return SizedBox();
    } else {
      return CachedNetworkImage(
        imageUrl: link,
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }

  Future<void> downloadFile(StorageReference ref) async {
    // THIS METHOD HELPS CANDIDATE TO DOWNLOAD THE OFFER LETTER SENT //

    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    print(systemTempDir);
    String tempPath = 'storage/emulated/0/Download/offer-letter' +
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
      OpenFile.open(tempPath);
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
          loading = true;
        });
        _uploadFile(file, "offerletter");
        showToast("Uploading", context);
      } else {}
    } catch (e) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              tittle: e,
              body: Text("Error Has Occurred"))
          .show();
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    // THIS METHOD AND THE FILEPICKER TOGETHER HELPS THE USER TO UPLOAD THE FILE TO FIREBASE STORAGE //

    SharedPreferences.getInstance().then((value) async {
      String name = Timestamp.now().toString();
      StorageReference storageReference;
      storageReference = FirebaseStorage.instance
          .ref()
          .child("offerLetters/${value.getString('email')}/$name");
      uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());

      if (url != null) {
        setState(() {
          tempURL = url;
        });
        dynamic result = await apiService.updateJobOfferLetter(
            widget.job['job_id'], tempURL);
        if (result['error'] != null) {
          showToast("error", context);
        } else {
          showToast("Successfully Uploaded", context);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Wrapper(
                      currentTab: 2,
                    )),
            (Route<dynamic> route) => false);
        // MOVE TO NEXT QUESTION
      } else {
        showToast("Error occurred, try again later", context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Wrapper(
                      currentTab: 2,
                    )),
            (Route<dynamic> route) => false);
      }
    });
  }

  Widget button(String status, Map job) {
    // THIS WIDGET SERVES THE SAME FUNCTION AS  TO DIFFERENTIATE THE UI //

    bool candAccepted = widget.isApplied ?? false;
    print(job);
    switch (status) {
      case "OFFERED":
        bool deadlineOver = job['accept_deadline_passed'] ?? true;
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
                    side: BorderSide(color: Colors.grey, width: 1.2),
                  ),
                  child: Text(
                    'ACCEPT',
                    style: TextStyle(color: Colors.white),
                  )));
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                title: AutoSizeText(
                  "Congratulations!!",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.green),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: AutoSizeText(
                  "You are offered this job from " + job['organisation'] ?? "",
                  maxLines: 2,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ListTile(
                  title: AutoSizeText(
                    "Deadline To Accept : ",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.green),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    dateTimeToReadableDateTimeConverter(DateTime.parse(
                        job['accept_deadline'] ?? '2020-01-01T00:00:00Z')),
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  )),
              ListTile(
                  title: AutoSizeText(
                "Download your offer letter!",
                maxLines: 2,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              )),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: RaisedButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context2, setState) {
                                  return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: loading
                                        ? Loading()
                                        : new AlertDialog(
                                            title: new Text(
                                              'Once you accept this job you will not be able to apply for any other jobs. Are you sure you want to accept this offer?',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  dynamic result =
                                                      await apiService
                                                          .acceptJobOffer(widget
                                                              .job['job_id']);
                                                  if (result['error'] != null) {
                                                    showToast(
                                                        result['error']
                                                            .toString(),
                                                        context);
                                                  } else {
                                                    showToast(
                                                        "Accepted Job Offer!",
                                                        context);
                                                  }
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Wrapper(
                                                                        currentTab:
                                                                            2,
                                                                      )),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: new Text(
                                                  'Yes',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: new Text(
                                                  'No',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                }));
                      },
                      color: Colors.green,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.green, width: 1.2),
                      ),
                      child: Text(
                        'ACCEPT OFFER',
                        style: TextStyle(color: Colors.white),
                      ))),
            ],
          );
        }

        break;
      case "INTERVIEW":
        setState(() {
          interOffer = true;
        });
        if (job['schedule'] != null) {
          if (job['schedule']['is_online'] != true && candAccepted == false) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Interviewer",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    widget.job['schedule']['interviewer'] ??
                        "Name Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Your interview has been scheduled",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.yellow[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    "Scheduled By " + widget.job['schedule']['interviewer'] ??
                        "Name Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Date & Time",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    dateTimeToReadableDateTimeConverter(DateTime.parse(
                        widget.job['schedule']['when'] ??
                            '2020-01-01T00:00:00Z')),
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Location",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    widget.job['schedule']['where'] ?? "Location Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0),
                    child: RaisedButton(
                        color: job['schedule']['cand_accepted']
                            ? Colors.grey
                            : Colors.yellow[700],
                        onPressed: () async {
                          if (!job['schedule']['cand_accepted']) {
                            await showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                  builder: (context2, setState) {
                                return Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: loading
                                        ? Loading()
                                        : new AlertDialog(
                                            title: new Text(
                                              'Are you sure?',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  showToast(
                                                      "Accepting", context);
                                                  dynamic result =
                                                      await apiService
                                                          .acceptInterView(
                                                              widget.job[
                                                                  'job_id']);
                                                  if (result['error'] != null) {
                                                    showToast(
                                                        result['error']
                                                            .toString(),
                                                        context);
                                                  } else {
                                                    showToast(
                                                        "Accepted Interview!",
                                                        context);
                                                  }
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Wrapper(
                                                                        currentTab:
                                                                            2,
                                                                      )),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: new Text(
                                                  'Yes',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: new Text(
                                                  'No',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ));
                              }),
                            );
                          }
                        },
                        elevation: 0,
                        padding: EdgeInsets.only(left: 30, right: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'ACCEPT INTERVIEW',
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            );
          } else if (job['interview_date_passed'] &&
              job['schedule']['cand_accepted'] &&
              candAccepted == false) {
            return Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: RaisedButton(
                    onPressed: null,
                    elevation: 0,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.grey, width: 1.2),
                    ),
                    child: Text(
                      'ACCEPT INTERVIEW',
                      style: TextStyle(color: Colors.black),
                    )));
          } else if (job['interview_room_link'] != null &&
              job['schedule']['cand_accepted'] &&
              candAccepted == false) {
            return Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: RaisedButton(
                    onPressed: () async {
                      var url =
                          "https://dev.apli.ai" + job['interview_room_link'] ??
                              'https://flutter.dev';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    color: basicColor,
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Your interview has been scheduled",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    "Scheduled By " + widget.job['schedule']['interviewer'] ??
                        "Name Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Date & Time",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    dateTimeToReadableDateTimeConverter(DateTime.parse(
                        widget.job['schedule']['when'] ??
                            '2020-01-01T00:00:00Z')),
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Interviewer",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    widget.job['schedule']['interviewer'] ??
                        "Name Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: AutoSizeText(
                    "Location",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    widget.job['schedule']['where'] ?? "Location Not Specified",
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0),
                    child: RaisedButton(
                        color: candAccepted ? Colors.grey : Colors.yellow[700],
                        onPressed: () async {
                          if (!candAccepted)
                            await showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                        builder: (context2, setState) {
                                      return Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: loading
                                              ? Loading()
                                              : new AlertDialog(
                                                  title: new Text(
                                                    'Are you sure?',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        showToast("Accepting",
                                                            context);
                                                        dynamic result =
                                                            await apiService
                                                                .acceptInterView(
                                                                    widget.job[
                                                                        'job_id']);
                                                        if (result['error'] !=
                                                            null) {
                                                          showToast(
                                                              result['error']
                                                                  .toString(),
                                                              context);
                                                        } else {
                                                          showToast(
                                                              "Check Interview link!",
                                                              context);
                                                        }
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Wrapper(
                                                                              currentTab: 2,
                                                                            )),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      },
                                                      child: new Text(
                                                        'Yes',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: new Text(
                                                        'No',
                                                        style: TextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                    }));
                        },
                        elevation: 0,
                        padding: EdgeInsets.only(left: 30, right: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'ACCEPT INTERVIEW',
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            );
          }
        } else
          return Container();
        break;
      case "LETTER SENT":
        if (job['offer_letter'] != null) {
          return Column(
            children: [
              Center(
                child: RaisedButton(
                    onPressed: () {
                      filePicker(context);
                    },
                    color: Colors.green,
                    elevation: 0,
                    padding: EdgeInsets.only(left: 43, right: 43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.green, width: 1.2),
                    ),
                    child: Text(
                      'UPLOAD LETTER',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Center(
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
                          if (job['offer_letter'] != null) {
                            String firebaseUrl = job['offer_letter'].replaceAll(
                                pdfUrltoBeReplaced, pdfUrltoreplacedWith);
                            firebaseUrl = firebaseUrl.replaceAll("%40", "@");
                            print(firebaseUrl);

                            var ref = FirebaseStorage.instance
                                .getReferenceFromUrl(firebaseUrl);

                            await ref.then((reference) {
                              showToast("Downloading", context, duration: 1);
                              downloadFile(reference);
                            });
                          }
                        } else
                          showToast('Permission denied', context);
                      },
                      color: Colors.green,
                      elevation: 0,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.green, width: 1.2),
                      ),
                      child: Text(
                        'DOWNLOAD LETTER',
                        style: TextStyle(color: Colors.white),
                      ))),
            ],
          );
        } else {
          return Container();
        }
        break;
      case "ACCEPTED":
        return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: RaisedButton(
                onPressed: null,
                elevation: 0,
                padding: EdgeInsets.only(left: 30, right: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.grey, width: 1.2),
                ),
                child: Text(
                  'APPLY NOW',
                  style: TextStyle(color: Colors.white),
                )));
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
                  side: BorderSide(color: Colors.grey, width: 1.2),
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
                  side: BorderSide(color: Colors.grey, width: 1.2),
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
                  side: BorderSide(color: Colors.grey, width: 1.2),
                ),
                child: Text(
                  'APPLY NOW',
                  style: TextStyle(color: Colors.white),
                )));
        break;
    }
  }

  bool loading = false;

  @override
  void initState() {
    if (widget.job['status'] == 'INTERVIEW' ||
        widget.job['status'] == 'OFFERED') {
      setState(() {
        //interOffer = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
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
            body: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 16.0, left: 10.0, right: 10.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {},
                                      trailing: companyLogo(
                                          widget.job['company_logo']),
                                      title: AutoSizeText(
                                        widget.job['role'] ??
                                            "Role not declared",
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: basicColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              widget.job['location'] ??
                                                  "Location not declared",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            AutoSizeText(
                                              'Deadline: ' +
                                                  dateTimeToReadableDateTimeConverter(
                                                      DateTime.parse(widget.job[
                                                              'deadline'] ??
                                                          '2020-05-26 00:00:00')),
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    widget.job['ctc'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              dense: true,
                                              title: Row(
                                                children: [
                                                  Text('Jobs CTC : ',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  Text(
                                                      widget.job['ctc'] ??
                                                          "Not Specified",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                            ))
                                        : SizedBox(),
                                    widget.job['notice_period'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              dense: true,
                                              title: Row(
                                                children: [
                                                  Text('Notice Period : ',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  Text(
                                                      widget.job[
                                                              'notice_period'] ??
                                                          "Not Specified",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                            ))
                                        : SizedBox(),
                                    widget.job['description'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              title: AutoSizeText(
                                                "Role Description : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      widget.job[
                                                              'description'] ??
                                                          "Not Specified",
                                                      maxLines: 999999,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        : SizedBox(),
                                    widget.job['key_resp'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              title: AutoSizeText(
                                                "Key Responsibilities : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                      widget.job['key_resp'] ??
                                                          "Not Specified",
                                                      maxLines: 999999,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        : SizedBox(),
                                    widget.job['soft_skills'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              title: AutoSizeText(
                                                "Soft Skills : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                            .job['soft_skills']
                                                            .length ??
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.job['soft_skills']
                                                                [index] ??
                                                            "None",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            ))
                                        : SizedBox(),
                                    widget.job['tech_skills'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              title: AutoSizeText(
                                                "Technical Skills  : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                            .job['tech_skills']
                                                            .length ??
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.job['tech_skills']
                                                                [index] ??
                                                            "None",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    widget.job['requirements'] != null
                                        ? Visibility(
                                            visible: !interOffer,
                                            child: ListTile(
                                              title: AutoSizeText(
                                                "Requirements : ",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        (widget.job['requirements'] ??
                                                                    [])
                                                                .length ??
                                                            1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Text(
                                                        widget.job['requirements']
                                                                [index] ??
                                                            "No specific requirements",
                                                        //maxLines: 4,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    }),
                                              ),
                                            ))
                                        : SizedBox(),
                                    button(widget.job['status'], widget.job)
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
  }
}
