import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'appliedDetails.dart';
import 'companyDetails.dart';

class JobsTabs extends StatefulWidget {
  final List jobs;
  final int profileStatus;
  final bool alreadyAccepted;
  final int tabNo;

  const JobsTabs(
      {Key key,
      this.jobs,
      this.profileStatus,
      this.alreadyAccepted,
      this.tabNo})
      : super(key: key);

  @override
  _JobsTabssState createState() => _JobsTabssState();
}

class _JobsTabssState extends State<JobsTabs> {
  double height, width, scale;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width >= 360) {
      scale = 1.0;
    } else {
      scale = 0.7;
    }

    Widget deadlineToShow(
        String status, String deadlineTimer, String deadline) {
      print(deadlineTimer);
      switch (status) {
        case "OFFERED":
          return StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1), (i) => i),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot2) {
                // var dateString;

                // int now = DateTime.now().millisecondsSinceEpoch;

                // int estimateTs = deadlineTimer.millisecondsSinceEpoch;
                // Duration remaining = Duration(milliseconds: estimateTs - now);
                // if(remaining.isNegative)
                //   dateString = 'Deadline is over';
                // else if (remaining.inDays > 0) {
                //   if (remaining.inDays == 1) {
                //     dateString = remaining.inDays.toString() + ' day';
                //   } else
                //     dateString = remaining.inDays.toString() + ' days';
                // } else {
                //   if (remaining.inHours > 0) {
                //     if (remaining.inHours == 1)
                //       dateString = remaining.inHours.toString() + ' hour';
                //     else
                //       dateString = remaining.inHours.toString() + ' hours';
                //   } else if (remaining.inMinutes > 0) if (remaining.inMinutes ==
                //       1)
                //     dateString = remaining.inMinutes.toString() + ' min';
                //   else
                //     dateString = remaining.inMinutes.toString() + ' mins';
                //   else if (remaining.inSeconds == 1)
                //     dateString = remaining.inSeconds.toString() + ' sec';
                //   else
                //     dateString = remaining.inSeconds.toString() + ' sec';
                // }
                return AutoSizeText(
                  "Deadline to accept : " + deadlineTimer,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              });
          break;

        case "LETTER SENT":
          return StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1), (i) => i),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot2) {
                var dateString;

                // int now = DateTime.now().millisecondsSinceEpoch;

                // int estimateTs = deadlineTimer.millisecondsSinceEpoch;
                // Duration remaining = Duration(milliseconds: estimateTs - now);
                // if(remaining.isNegative)
                //   dateString = 'Deadline is over';
                // else if (remaining.inDays > 0) {
                //   if (remaining.inDays == 1) {
                //     dateString = remaining.inDays.toString() + ' day';
                //   } else
                //     dateString = remaining.inDays.toString() + ' days';
                // } else {
                //   if (remaining.inHours > 0) {
                //     if (remaining.inHours == 1)
                //       dateString = remaining.inHours.toString() + ' hour';
                //     else
                //       dateString = remaining.inHours.toString() + ' hours';
                //   } else if (remaining.inMinutes > 0) if (remaining.inMinutes ==
                //       1)
                //     dateString = remaining.inMinutes.toString() + ' min';
                //   else
                //     dateString = remaining.inMinutes.toString() + ' mins';
                //   else if (remaining.inSeconds == 1)
                //     dateString = remaining.inSeconds.toString() + ' sec';
                //   else
                //     dateString = remaining.inSeconds.toString() + ' sec';
                // }

                return AutoSizeText(
                  "Deadline to accept : " + deadlineTimer ??
                      "No Deadline" + 'remaining',
                  maxLines: 2,
                  style: TextStyle(
                      //color: Colors.red,
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              });
          break;

        default:
          return AutoSizeText(
            'Deadline: ' + deadline ?? "No Deadline",
            maxLines: 2,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12 * scale,
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          );
      }
    }

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
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            child: Text(status ?? "", style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    if ((widget.jobs ?? []).length == 0) {
      return Center(
          child: Text(widget.tabNo == 0
              ? 'You have not applied for any jobs yet'
              : widget.tabNo == 1
                  ? "There are no new jobs"
                  : "You don't have any incomplete jobs"));
    } else
      return ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.jobs.length,
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
                                          if (widget.tabNo == 0)
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppliedDetails(
                                                          job: widget
                                                              .jobs[index],
                                                          status: widget
                                                              .profileStatus,
                                                          st: widget.jobs[index]
                                                              ['status'],
                                                        )));
                                          else if (widget.tabNo == 1)
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompanyProfile(
                                                          isApplied: widget
                                                              .alreadyAccepted,
                                                          company: widget
                                                              .jobs[index],
                                                          status: widget
                                                              .profileStatus,
                                                        )));
                                          else {
                                            if (widget.alreadyAccepted !=
                                                    null &&
                                                widget.alreadyAccepted) {
                                              showToast(
                                                  "You have already accepted a job",
                                                  context);
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CompanyVideo(
                                                            job: widget
                                                                .jobs[index],
                                                            status: widget
                                                                .profileStatus,
                                                          )));
                                            }
                                          }
                                        },
                                        title: AutoSizeText(
                                          widget.jobs[index]['role'] ??
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
                                              widget.jobs[index]['location'] ??
                                                  "Location not provided",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12 * scale,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            widget.tabNo == 0
                                                ? deadlineToShow(
                                                    widget.jobs[index]
                                                        ['status'],
                                                    widget.jobs[index][
                                                            'accept_deadline'] ??
                                                        '',
                                                    widget.jobs[index]
                                                            ['deadline'] ??
                                                        "")
                                                : AutoSizeText(
                                                    'Deadline: ' +
                                                            widget.jobs[index]
                                                                ['deadline'] ??
                                                        "No Deadline",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12 * scale,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                          ],
                                        ),
                                        trailing: widget.tabNo == 0
                                            ? differentBackground(
                                                widget.jobs[index]['status'])
                                            : IconButton(
                                                icon: Icon(
                                                  EvaIcons.bookmarkOutline,
                                                ),
                                                onPressed: () async {},
                                              )),
                                  ),
                                ])),
                      );
                    }))),
      );
  }
}
