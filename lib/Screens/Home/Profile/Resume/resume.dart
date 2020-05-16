import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'editResume.dart';

class Resume extends StatefulWidget {
  @override
  _ResumeState createState() => _ResumeState();
}

class _ResumeState extends State<Resume> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double height, width;
  int status;
  bool error = false, loading = false;
  String pdfUrl;
  String email;
  String path;
  PDFDocument doc;
  bool downloading = false;

  bool checkStatus(int status) {
    if (status < 384)
      return false;
    else
      return true;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(pdfUrl);
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  void loadPdf(String url) async {
    doc = await PDFDocument.fromURL(url);
//    await writeCounter(await fetchPost());
//    await existsFile();
//    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

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

  void getInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        try {
          await Firestore.instance
              .collection('candidates')
              .document(prefs.getString('email'))
              .get()
              .then((s) {
            setState(() {
              pdfUrl = s.data['pdfResume'];
              status = s.data['profile_status'] ?? 0;
              email = s.data['email'];
            });
            if (checkStatus(status)) {
              if (s.data['pdfResume'] != null)
                loadPdf(s.data['pdfResume']);
              else
                setState(() {
                  error = true;
                });
            }
          });
        } catch (e) {
          print(e.toString());
          setState(() {
            error = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return error
        ? Scaffold(
            body: Center(
              child: Text('Error occured, try again later'),
            ),
          )
        : email == null
            ? Loading()
            : loading
                ? Loading()
                : !checkStatus(status) && pdfUrl == null
                    ? noResume()
                    : doc == null
                        ? Loading()
                        : ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(resumeSlogan,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                      height: height * 0.5,
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Stack(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: Stack(
                                                children: <Widget>[
                                                  PDFViewer(
                                                    document: doc,
                                                    showIndicator: false,
                                                    showPicker: false,
                                                    tooltip: PDFViewerTooltip(
                                                        last: null,
                                                        jump: null,
                                                        previous: null),
                                                  ),
                                                  Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Container(
                                                        width: width * 0.8,
                                                        height: 50,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, width * 0.3, 8, 8),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        EvaIcons.editOutline,
                                                        color: Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditResume()),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: IconButton(
                                                        icon: Icon(
                                                          EvaIcons.shareOutline,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () async {
                                                          if (pdfUrl != null) {
                                                            var request =
                                                                await HttpClient()
                                                                    .getUrl(Uri
                                                                        .parse(
                                                                            pdfUrl));
                                                            var response =
                                                                await request
                                                                    .close();
                                                            Uint8List bytes =
                                                                await consolidateHttpClientResponseBytes(
                                                                    response);
                                                            await Share.file(
                                                                'My Resume',
                                                                'resume.pdf',
                                                                bytes,
                                                                'application/pdf');
                                                          } else {
                                                            showToast(
                                                                "Please Complete Your Profile First!",
                                                                context);
                                                          }
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: IconButton(
                                                        icon: Icon(
                                                          EvaIcons
                                                              .downloadOutline,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () async {
                                                          var status =
                                                              await Permission
                                                                  .storage
                                                                  .status;
                                                          switch (status) {
                                                            case PermissionStatus
                                                                .undetermined:
                                                              Map<Permission,
                                                                      PermissionStatus>
                                                                  statuses =
                                                                  await [
                                                                Permission
                                                                    .storage,
                                                              ].request();
                                                              break;
                                                            case PermissionStatus
                                                                .granted:
                                                              if (pdfUrl !=
                                                                  null) {
                                                                String
                                                                    firebaseUrl =
                                                                    pdfUrl.replaceAll(
                                                                        pdfUrltoBeReplaced,
                                                                        pdfUrltoreplacedWith);
                                                                firebaseUrl =
                                                                    firebaseUrl
                                                                        .replaceAll(
                                                                            "%40",
                                                                            "@");
                                                                print(
                                                                    firebaseUrl);

                                                                var ref = FirebaseStorage
                                                                    .instance
                                                                    .getReferenceFromUrl(
                                                                        firebaseUrl);

                                                                await ref.then(
                                                                    (reference) {
                                                                  showToast(
                                                                      "Downloading",
                                                                      context,
                                                                      duration:
                                                                          1);
                                                                  downloadFile(
                                                                      reference);
                                                                });
                                                              } else {
                                                                showToast(
                                                                    "Please Complete Your Profile First!",
                                                                    context);
                                                              }
                                                              break;
                                                            case PermissionStatus
                                                                .denied:
                                                              break;
                                                            case PermissionStatus
                                                                .restricted:
                                                              break;
                                                            case PermissionStatus
                                                                .permanentlyDenied:
                                                              break;
                                                          }
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
  }

  Widget noResume() {
    return Center(
        child: ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("Assets/Images/job.png"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        "We can help you build your Resume \nBut first build your ",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                          text: "Profile",
                          style: TextStyle(color: basicColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditResume()),
                              );
                            }),
                    ]),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
