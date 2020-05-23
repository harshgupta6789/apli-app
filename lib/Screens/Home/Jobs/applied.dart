import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/rendering.dart';
import '../../HomeLoginWrapper.dart';
import 'companyDetails.dart';

class AppliedJobs extends StatefulWidget {
  final List appliedJobs;
  final int status;

  const AppliedJobs({Key key, this.appliedJobs, this.status}) : super(key: key);
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  double height, width, scale;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.appliedJobs);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width >= 360) {
      scale = 1.0;
    } else {
      scale = 0.7;
    }

    if ((widget.appliedJobs ?? []).length == 0) {
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
                          "I know you are interested in job \nbut first build your ",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(
                            text: "Profile",
                            style: TextStyle(color: basicColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper(
                                              currentTab: 3,
                                            )),
                                    (Route<dynamic> route) => false);
                                setState(() {});
                              }),
                      ]),
                ),
              )
            ],
          ),
        ),
      ));
    } else
      return ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (widget.appliedJobs ?? []).length,
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
                                                        CompanyProfile(
                                                          isApplied: true,
                                                          company: widget
                                                                  .appliedJobs[
                                                              index],
                                                          status: widget.status,
                                                        )));
                                          },
                                          title: AutoSizeText(
                                            widget.appliedJobs[index]['role'] ??
                                                "Role not provided",
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
                                                widget.appliedJobs[index]
                                                        ['location'] ??
                                                    "Location not provided",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12 * scale,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              AutoSizeText(
                                                'Deadline: ' +
                                                        widget.appliedJobs[
                                                                index]
                                                            ['deadline'] ??
                                                    "No Deadline",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12 * scale,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                          trailing: widget.appliedJobs[index]
                                                      ['status'] !=
                                                  null
                                              ? Text(widget.appliedJobs[index]
                                                  ['status'])
                                              : Container())),
                                ])),
                      );
                    }))),
      );
  }
}
