import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MockJobs extends StatefulWidget {
  @override
  _MockJobsState createState() => _MockJobsState();
}

class _MockJobsState extends State<MockJobs> {
  final _APIService = APIService();
  bool loading = true;
  dynamic mockJobs;
  double height, width, scale;

  getInfo() async {
    dynamic result = await _APIService.getJobs();
    if (mounted)
      setState(() {
        mockJobs = result;
        loading = false;
      });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width >= 360) {
      scale = 1.0;
    } else {
      scale = 0.7;
    }
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Visibility(
          visible: !loading,
          child: FloatingActionButton(
            backgroundColor: basicColor,
            child: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loading = true;
              });
              getInfo();
            },
          ),
        ),
        endDrawer: customDrawer(context, _scaffoldKey),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.funnelOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: () {}),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 10.0),
//                child: IconButton(
//                    icon: Icon(
//                      EvaIcons.searchOutline,
//                      color: Colors.white,
//                    ),
//                    onPressed: null),
//              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                      icon: Icon(
                        EvaIcons.moreVerticalOutline,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer())),
            ],
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                jobsAvailable,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(55),
        ),
        body: loading
            ? Loading()
            : mockJobs == null
                ? Center(
                    child: Text('Error occurred, try again later'),
                  )
                : mockJobs == 'frozen'
                    ? Center(
                        child: Text(
                            "Your account is set on 'freeze' by your college"),
                      )
                    : mockJobs == 0
                        ? Center(
                            child: Text('Error occurred, try again later'),
                          )
                        : ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 15, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                "Assets/Images/mock.png",
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5, 20, 15, 10),
                                    child: AutoSizeText(
                                          "Mock Interviews",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: (mockJobs ?? []).length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 1),
                                                child: Card(
                                                  elevation: 0.2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black54)),
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10 * scale,
                                                          bottom: 13 * scale),
                                                      child: ListTile(
                                                        onTap: () {},
                                                        dense: true,
                                                        title: AutoSizeText(
                                                          "Interview 0",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )),
                                                ),
                                              );
                                            }),
                                      ],
                                    ))),
                          ));
  }
}
