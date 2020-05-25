import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:apli/Shared/constants.dart';
import 'package:flutter/rendering.dart';
import '../../HomeLoginWrapper.dart';
import 'companyDetails.dart';

class IncompleteJobs extends StatefulWidget {
  final List incompleteJobs;
  final int status;
  final bool alreadyAccepted;

  const IncompleteJobs(
      {Key key, this.incompleteJobs, this.status, this.alreadyAccepted})
      : super(key: key);
  @override
  _IncompleteJobsState createState() => _IncompleteJobsState();
}

class _IncompleteJobsState extends State<IncompleteJobs> {
  double height, width, scale;

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

    if ((widget.incompleteJobs ?? []).length == 0) {
      return Center(
        child: Text('You do not have any incomplete jobs yet'),
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
                    itemCount: (widget.incompleteJobs ?? []).length,
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
                                          if (widget.alreadyAccepted != null &&
                                              widget.alreadyAccepted) {
                                            showToast(
                                                "Already Accepted!", context);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompanyVideo(
                                                          job: widget
                                                                  .incompleteJobs[
                                                              index],
                                                          status: widget.status,
                                                        )));
                                          }
                                        },
                                        title: AutoSizeText(
                                          widget.incompleteJobs[index]
                                                  ['role'] ??
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
                                              widget.incompleteJobs[index]
                                                      ['location'] ??
                                                  "Location not provided",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12 * scale,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            AutoSizeText(
                                              'Deadline: ' +
                                                      widget.incompleteJobs[
                                                          index]['deadline'] ??
                                                  "No Deadline",
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
