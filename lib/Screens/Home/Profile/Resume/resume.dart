import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
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

class _ResumeState extends State<Resume> {
  bool error = false, loading = false;
  String pdfUrl;
  String email;
  String path;

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

  void loadPdf() async {
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('storage/emulated/0/resume.pdf');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
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
              email = s.data['email'];
            });
          });
        } catch (e) {
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
    //loadPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return email == null
        ? Loading()
        : loading
            ? Loading()
            : ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(resumeSlogan,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            pdfUrl == null
                                ? Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 30.0),
                                        child: Image.asset(
                                            "Assets/Images/job.png")),
                                  )
                                : path != null
                                    ? Container(
                                        height: 200,
                                        width: 300,
                                        child: PdfViewer(
                                          filePath: path,
                                        ),
                                      )
                                    : RaisedButton(
                                        child: Text("Load pdf"),
                                        onPressed: loadPdf,
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
                                              builder: (context) =>
                                                  EditResume()),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: IconButton(
                                        icon: Icon(EvaIcons.shareOutline),
                                        onPressed: () async {
                                          if (pdfUrl != null) {
                                            var request = await HttpClient()
                                                .getUrl(Uri.parse(pdfUrl));
                                            var response =
                                                await request.close();
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
                                    padding: const EdgeInsets.all(4.0),
                                    child: IconButton(
                                        icon: Icon(EvaIcons.downloadOutline),
                                        onPressed: () async {
                                          var status =
                                              await Permission.storage.status;
                                          switch (status) {
                                            case PermissionStatus.undetermined:
                                              Map<Permission, PermissionStatus>
                                                  statuses = await [
                                                Permission.storage,
                                              ].request();
                                              break;
                                            case PermissionStatus.granted:
                                              if (pdfUrl != null) {
                                                String firebaseUrl = pdfUrl.replaceAll(
                                                    "https://storage.googleapis.com/aplidotai.appspot.com/",
                                                    "gs://aplidotai.appspot.com/");
                                                firebaseUrl = firebaseUrl
                                                    .replaceAll("%40", "@");

                                                var ref = FirebaseStorage
                                                    .instance
                                                    .getReferenceFromUrl(
                                                        firebaseUrl);

                                                await ref.then((reference) {
                                                  downloadFile(reference);
                                                });
                                              } else {
                                                showToast(
                                                    "Please Complete Your Profile First!",
                                                    context);
                                              }
                                              break;
                                            case PermissionStatus.denied:
                                              break;
                                            case PermissionStatus.restricted:
                                              break;
                                            case PermissionStatus
                                                .permanentlyDenied:
                                              break;
                                          }
                                        }),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
