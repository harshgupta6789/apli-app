import 'package:apli/Screens/Home/Jobs/appliedDetails.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final bool alreadyAccepted;

  const AppliedJobs(
      {Key key, this.appliedJobs, this.status, this.alreadyAccepted})
      : super(key: key);
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  double height, width, scale;

  @override
  void initState() {
    super.initState();
  }

  // Widget deadlineToShow(String status, String deadlineTimer, String deadline) {
  //   switch (status) {
  //     case "OFFERED":
  //       return StreamBuilder(
  //           stream: Stream.periodic(Duration(seconds: 1), (i) => i),
  //           builder: (BuildContext context, AsyncSnapshot<int> snapshot2) {
  //             // var dateString;

  //             // int now = DateTime.now().millisecondsSinceEpoch;

  //             // int estimateTs = deadlineTimer.millisecondsSinceEpoch;
  //             // Duration remaining = Duration(milliseconds: estimateTs - now);
  //             // if(remaining.isNegative)
  //             //   dateString = 'Deadline is over';
  //             // else if (remaining.inDays > 0) {
  //             //   if (remaining.inDays == 1) {
  //             //     dateString = remaining.inDays.toString() + ' day';
  //             //   } else
  //             //     dateString = remaining.inDays.toString() + ' days';
  //             // } else {
  //             //   if (remaining.inHours > 0) {
  //             //     if (remaining.inHours == 1)
  //             //       dateString = remaining.inHours.toString() + ' hour';
  //             //     else
  //             //       dateString = remaining.inHours.toString() + ' hours';
  //             //   } else if (remaining.inMinutes > 0) if (remaining.inMinutes ==
  //             //       1)
  //             //     dateString = remaining.inMinutes.toString() + ' min';
  //             //   else
  //             //     dateString = remaining.inMinutes.toString() + ' mins';
  //             //   else if (remaining.inSeconds == 1)
  //             //     dateString = remaining.inSeconds.toString() + ' sec';
  //             //   else
  //             //     dateString = remaining.inSeconds.toString() + ' sec';
  //             // }

  //             return AutoSizeText(
  //               "Deadline to accept : " + deadlineTimer,
  //               maxLines: 2,
  //               style: TextStyle(
  //                   //color: Colors.red,
  //                   fontSize: 12 * scale,
  //                   fontWeight: FontWeight.w500),
  //               overflow: TextOverflow.ellipsis,
  //             );
  //           });
  //       break;

  //     case "LETTER SENT":
  //       return StreamBuilder(
  //           stream: Stream.periodic(Duration(seconds: 1), (i) => i),
  //           builder: (BuildContext context, AsyncSnapshot<int> snapshot2) {
  //             var dateString;

  //             // int now = DateTime.now().millisecondsSinceEpoch;

  //             // int estimateTs = deadlineTimer.millisecondsSinceEpoch;
  //             // Duration remaining = Duration(milliseconds: estimateTs - now);
  //             // if(remaining.isNegative)
  //             //   dateString = 'Deadline is over';
  //             // else if (remaining.inDays > 0) {
  //             //   if (remaining.inDays == 1) {
  //             //     dateString = remaining.inDays.toString() + ' day';
  //             //   } else
  //             //     dateString = remaining.inDays.toString() + ' days';
  //             // } else {
  //             //   if (remaining.inHours > 0) {
  //             //     if (remaining.inHours == 1)
  //             //       dateString = remaining.inHours.toString() + ' hour';
  //             //     else
  //             //       dateString = remaining.inHours.toString() + ' hours';
  //             //   } else if (remaining.inMinutes > 0) if (remaining.inMinutes ==
  //             //       1)
  //             //     dateString = remaining.inMinutes.toString() + ' min';
  //             //   else
  //             //     dateString = remaining.inMinutes.toString() + ' mins';
  //             //   else if (remaining.inSeconds == 1)
  //             //     dateString = remaining.inSeconds.toString() + ' sec';
  //             //   else
  //             //     dateString = remaining.inSeconds.toString() + ' sec';
  //             // }

  //             return AutoSizeText(
  //               "Deadline to accept : " + dateString ??
  //                   "No Deadline" + 'remaining',
  //               maxLines: 2,
  //               style: TextStyle(
  //                   //color: Colors.red,
  //                   fontSize: 12 * scale,
  //                   fontWeight: FontWeight.w500),
  //               overflow: TextOverflow.ellipsis,
  //             );
  //           });
  //       break;

  //     default:
  //       return AutoSizeText(
  //         'Deadline: ' + deadline ?? "No Deadline",
  //         maxLines: 2,
  //         style: TextStyle(
  //             color: Colors.black,
  //             fontSize: 12 * scale,
  //             fontWeight: FontWeight.w500),
  //         overflow: TextOverflow.ellipsis,
  //       );
  //   }
  // }

  Widget differentBackground(String status) {
    Color temp;
    switch (status) {
      case "OFFERED":
        temp = Colors.green;
        break;
      case "INTERVIEW":
        temp = Colors.blue;
        break;
      case "LETTER SENT":
        temp = Colors.green;
        break;
      case "ACCEPTED":
        temp = Colors.green;
        break;
      case "UNREVIEWED":
        temp = Colors.grey;
        break;
      case "REJECTED":
        temp = Colors.red;
        break;
      case "HIRED":
        temp = Colors.green;
        break;
      default:
        temp = Colors.green;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        color: temp,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(status ?? "", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
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

    if ((widget.appliedJobs ?? []).length == 0) {
      return Center(
        child: Text('You have not applied for any jobs yet'),
      );
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
                                            if (widget.appliedJobs[index]
                                                        ['status'] ==
                                                    'LETTER SENT' ||
                                                widget.appliedJobs[index]
                                                        ['status'] ==
                                                    'ACCEPTED') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AppliedDetails(
                                                            job: widget
                                                                    .appliedJobs[
                                                                index],
                                                            status:
                                                                widget.status,
                                                            st: widget
                                                                    .appliedJobs[
                                                                index]['status'],
                                                          )));
                                            } else {
                                              if (widget.alreadyAccepted !=
                                                      null &&
                                                  widget.alreadyAccepted) {
                                                showToast("Already Accepted!",
                                                    context);
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AppliedDetails(
                                                              job: widget
                                                                      .appliedJobs[
                                                                  index],
                                                              status:
                                                                  widget.status,
                                                              st: widget.appliedJobs[
                                                                      index]
                                                                  ['status'],
                                                            )));
                                              }
                                            }
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
                                              // deadlineToShow(
                                              //     widget.appliedJobs[index]
                                              //         ['status'],
                                              //     widget.appliedJobs[index]
                                              //             ['accept_deadline'] ??
                                              //         '',
                                              //     widget.appliedJobs[index]
                                              //             ['deadline'] ??
                                              //         "")
                                            ],
                                          ),
                                          trailing: differentBackground(widget
                                              .appliedJobs[index]['status'])
                                          )),
                                ])),
                      );
                    }))),
      );
  }
}
