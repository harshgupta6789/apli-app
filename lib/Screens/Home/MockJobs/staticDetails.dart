import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mockQuestions.dart';

class RandomDetails extends StatefulWidget {
  final String package;

  const RandomDetails({Key key, this.package}) : super(key: key);
  @override
  _RandomDetailsState createState() => _RandomDetailsState();
}

class _RandomDetailsState extends State<RandomDetails> {

  // SIMILAR TO COMPANY DETAILS , REFER THERE //

  @override
  void initState() {
    print(widget.package);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 25, 8, 8),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 18.0, left: 10.0, right: 10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ListTile(
                                          onTap: () {},
                                          title: AutoSizeText(
                                            "Apli.ai",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
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
                                                AutoSizeText(
                                                  "Office Of Apli",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                AutoSizeText(
                                                  "No Deadline yet",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: AutoSizeText(
                                            "Skills : ",
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "1. English",
                                                  //maxLines: 4,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "2. Leadership",
                                                  //maxLines: 4,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 10.0),
                                            child: RaisedButton(
                                                color: basicColor,
                                                elevation: 0,
                                                padding: EdgeInsets.only(
                                                    left: 30, right: 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  side: BorderSide(
                                                      color: basicColor,
                                                      width: 1.2),
                                                ),
                                                child: Text(
                                                  'APPLY NOW',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MockCompanyInstructions(
                                                                  pack: widget
                                                                      .package)));
                                                }),
                                          ),
                                        )
                                      ]))))
                    ])))));
  }
}

class MockCompanyInstructions extends StatefulWidget {
  final String pack;

  const MockCompanyInstructions({Key key, this.pack}) : super(key: key);
  @override
  _MockCompanyInstructionsState createState() =>
      _MockCompanyInstructionsState();
}

class _MockCompanyInstructionsState extends State<MockCompanyInstructions> {
  double fontSize = 14, height, width;
  bool loading = false;
  List<CameraDescription> cameras;
  APIService apiService = APIService();

  Future<dynamic> getInfo() async {
    dynamic result = await apiService.fetchMockInterviewQ(widget.pack);
    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
            body: FutureBuilder(
                future: getInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data['error'] != null)
                      return Center(
                        child: Text(snapshot.data['error']),
                      );
                    else
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 18.0, left: 10.0, right: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, height * 0.1, 0, 0),
                                        child: Align(
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: 'Click ',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .color,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: ' "START" ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: basicColor)),
                                                  TextSpan(
                                                      text:
                                                          ' when you are ready! ',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline4
                                                            .color,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 10, 0.0, 8),
                                        child: Align(
                                            child: Text(
                                                "Please read the following instructions carefully.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.center),
                                      ),
                                      SizedBox(height: height * 0.05),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10.0, 5, 0, 8),
                                        child: Align(
                                            child: Text(
                                                snapshot.data['pack'] != null
                                                    ? "1. There will be a total of  " +
                                                        snapshot
                                                            .data['pack'].length
                                                            .toString() +
                                                        " questions in the interview."
                                                    : "1. There will be a total of 15 questions in the interview.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "2. You will be given 60 seconds for answering each question.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "3. You have to attempt all the questions.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "4. You cannot pause the interview in between.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "5. Don’t close or reload the window during the interview.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 8),
                                        child: Align(
                                            child: Text(
                                                "6. Strict action will be taken if any abusive or offensive language is used.",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            alignment: Alignment.centerLeft),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 30.0),
                                          child: RaisedButton(
                                              color: basicColor,
                                              elevation: 0,
                                              padding: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: basicColor,
                                                    width: 1.2),
                                              ),
                                              child: Text(
                                                'START',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                bool storage = false,
                                                    camera = false,
                                                    microphone = false;
                                                var storageStatus =
                                                    await Permission
                                                        .storage.status;
                                                if (storageStatus ==
                                                    PermissionStatus.granted) {
                                                  storage = true;
                                                } else if (storageStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                  ].request();
                                                  if (statuses[
                                                          Permission.storage] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    storage = true;
                                                  }
                                                }
                                                var cameraeStatus =
                                                    await Permission
                                                        .camera.status;
                                                if (cameraeStatus ==
                                                    PermissionStatus.granted) {
                                                  camera = true;
                                                } else if (cameraeStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[
                                                          Permission.camera] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    camera = true;
                                                  }
                                                }
                                                var microphoneStatus =
                                                    await Permission
                                                        .microphone.status;
                                                if (microphoneStatus ==
                                                    PermissionStatus.granted) {
                                                  microphone = true;
                                                } else if (microphoneStatus ==
                                                    PermissionStatus
                                                        .undetermined) {
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.microphone,
                                                  ].request();
                                                  if (statuses[Permission
                                                          .microphone] ==
                                                      PermissionStatus
                                                          .granted) {
                                                    microphone = true;
                                                  }
                                                }
                                                if (storage &&
                                                    camera &&
                                                    microphone) {
                                                  print(snapshot
                                                      .data['startFrom']);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MockJobQuestions(
                                                                packName:
                                                                    widget.pack,
                                                                questions:
                                                                    snapshot.data[
                                                                        'pack'],
                                                                whereToStart:
                                                                    snapshot.data[
                                                                        'startFrom'],
                                                                docID: snapshot
                                                                        .data[
                                                                    'docId'],
                                                              )));
                                                } else
                                                  showToast('Permission denied',
                                                      context,
                                                      color: Colors.red);
                                              }),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error Occured"));
                  }
                  return Loading();
                }),
          );
  }
}
