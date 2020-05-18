import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:apli/Shared/constants.dart';
import 'companyDetails.dart';

class AllJobs extends StatefulWidget {
  @override
  _AllJobsState createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  double height, width, scale;
  final _APIService = APIService(type: 0);

  Future<dynamic> init() async {
    dynamic result = await _APIService.handleJobData();
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
    if (width >= 360) {
      scale = 1.0;
    } else {
      scale = 0.7;
    }
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 15,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 1),
                      child: Card(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: BorderSide(color: Colors.black54)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10 * scale, bottom: 13 * scale),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CompanyDetails()));
                                    },
                                    title: AutoSizeText(
                                      "Flutter Developer",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: basicColor,
                                          fontSize: 18 * scale,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "Powai , Maharashtra",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12 * scale,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AutoSizeText(
                                          "Deadline: 20th April 2020",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12 * scale,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.bookmark,
                                          color: Color(0xffebd234)),
                                      onPressed: () {},
                                    )),
                              ),
                            ])
                      ),
                    );
                  }))
          // child: FutureBuilder(
          //     future: init(),
          //     builder: (context, AsyncSnapshot snapshot) {
          //       if (!snapshot.hasData) {
          //         return Center(child: Loading());
          //       } else {
          //         if (snapshot.data['frozen'] != true) {
          //           return Container(
          //               child: ListView.builder(
          //                   itemCount: snapshot.data['jobs'].length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     if (snapshot.data['jobs'].length != 0) {
          //                       return Padding(
          //                         padding: const EdgeInsets.all(4.0),
          //                         child: Container(
          //                           child: Card(
          //                             elevation: 0.2,
          //                             shape: RoundedRectangleBorder(
          //                                 borderRadius:
          //                                     BorderRadius.circular(12.0),
          //                                 side:
          //                                     BorderSide(color: Colors.black54)),
          //                             child: Padding(
          //                               padding:
          //                                   EdgeInsets.only(bottom: 15.0),
          //                               child: Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: <Widget>[
          //                                     Padding(
          //                                       padding: EdgeInsets.only(
          //                                           left: width * 0.01,
          //                                           top: 15.0),
          //                                       child: ListTile(
          //                                           title: AutoSizeText(
          //                                             snapshot.data['jobs']
          //                                                         [index]
          //                                                     ['role'] ??
          //                                                 "Flutter Developer",
          //                                             maxLines: 2,
          //                                             style: TextStyle(
          // color: basicColor,
          //                                                 fontSize: 18,
          //                                                 fontWeight:
          //                                                     FontWeight
          //                                                         .w500),
          //                                             overflow: TextOverflow
          //                                                 .ellipsis,
          //                                           ),
          //                                           subtitle: Column(
          //                                             children: [
          //                                               AutoSizeText(
          //                                                 snapshot.data['jobs']
          //                                                             [index]
          //                                                         ['location'] ??
          //                                                     "No Location Specified",
          // //TextStyle(
          //                                         color: Colors.black,
          //                                         fontWeight: FontWeight.w500),
          //                                                 maxLines: 2,
          //                                                 overflow:
          //                                                     TextOverflow
          //                                                         .ellipsis,
          //                                               ),
          //                                               AutoSizeText(
          //                                                 snapshot.data['jobs']
          //                                                             [index][
          //                                                         'deadline'] ??
          //                                                     DateTime.fromMicrosecondsSinceEpoch(snapshot.data['jobs']
          //                                                                 [
          //                                                                 index]
          //                                                             [
          //                                                             'deadline'])
          //                                                         .toString(),
          //                                                 maxLines: 2,
          // //TextStyle(
          //                                         color: Colors.black,
          //                                         fontWeight: FontWeight.w500),
          //                                                 overflow:
          //                                                     TextOverflow
          //                                                         .ellipsis,
          //                                               )
          //                                             ],
          //                                           ),
          //                                           trailing: IconButton(
          //                                             icon: Icon(Icons
          //                                                 .bookmark_border),
          //                                             onPressed: () {},
          //                                           )),
          //                                     ),
          //                                   ]),
          //                             ),
          //                           ),
          //                         ),
          //                       );
          //                     }
          //                     return Center(
          //                       child: Text("No Jobs Available"),
          //                     );
          //                   }));
          //         }
          //         return Center(
          //           child: Text("Account is Frozen"),
          //         );
          //       }
          //     })),
          ),
    );
  }
}
