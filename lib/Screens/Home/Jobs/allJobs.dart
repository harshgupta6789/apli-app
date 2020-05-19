import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:apli/Shared/constants.dart';
import '../../HomeLoginWrapper.dart';
import 'companyDetails.dart';

class AllJobs extends StatefulWidget {
  @override
  _AllJobsState createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  double height, width, scale;
  final _APIService = APIService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<dynamic> getInfo() async {
    dynamic result = await _APIService.handleJobData();
    print(result);
    return result;
  }

  Future ref() async {
    setState(() {});
    return null;
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
    return FutureBuilder<Object>(
        future: getInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'frozen')
              return Center(
                child: Text("Your account is set on 'freeze' by your college"),
              );
            else if (snapshot.data.length == 0)
              return Center(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: RefreshIndicator(
                  onRefresh: ref,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
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
                                    "I know you are interested in job \nbut first build your ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                                  TextSpan(
                                      text: "Profile",
                                      style: TextStyle(color: basicColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Wrapper(
                                                            currentTab: 3,
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                          setState(() {});
                                        }),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
            else
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: RefreshIndicator(
                  onRefresh: ref,
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              physics: ScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 1),
                                  child: Card(
                                      elevation: 0.2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          side: BorderSide(
                                              color: Colors.black54)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10 * scale,
                                                  bottom: 13 * scale),
                                              child: ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CompanyProfile(
                                                                  company: snapshot
                                                                          .data[
                                                                      index],
                                                                )));
                                                  },
                                                  title: AutoSizeText(
                                                    snapshot.data[index]
                                                            ['role'] ??
                                                        "Role not provided",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: basicColor,
                                                        fontSize: 18 * scale,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AutoSizeText(
                                                        snapshot.data[index]
                                                                ['location'] ??
                                                            "Location not provided",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                12 * scale,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      AutoSizeText(
                                                        snapshot.data[index][
                                                                    'deadline'] !=
                                                                null
                                                            ? "Deadline : " +
                                                                snapshot
                                                                    .data[index]
                                                                        [
                                                                        'deadline']
                                                                    .toString()
                                                            : "No Deadline" ??
                                                                "No Deadline",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                12 * scale,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    ],
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.bookmark,
                                                        color:
                                                            Color(0xffebd234)),
                                                    onPressed: () async {
                                                      dynamic result =
                                                          await _APIService
                                                              .handleJobData();
                                                    },
                                                  )),
                                            ),
                                          ])),
                                );
                              }))),
                ),
              );
          } else if (snapshot.hasError)
            return Center(
              child: Text('Error occured, try again later'),
            );
          else
            return Loading();
        });
  }
}
