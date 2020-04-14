import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
   key: _scaffoldKey,
      endDrawer: customDrawer(context),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    EvaIcons.funnelOutline,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    _scaffoldKey.currentState.openEndDrawer();
                  }),
            ],
            title: Text(
              updates,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     RawChip(
          //       label: Text("New Jobs"),
          //       selected: false,
          //       backgroundColor: basicColor,
          //     ),
          //     RawChip(label: Text("Messages"), selected: true),
          //     RawChip(label: Text("Application"), selected: false),
          //   ],
          // ),
          Container(
              height: 180.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  ListTile(
                    title: Text(
                        "We found 7 new jobs at Deloitte, Samsung, Infosys and 4 others that you may be interested in."),
                    trailing: Text("8h"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0 , left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: basicColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                            child: Text(
                              "View Jobs",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: basicColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => null),
                      )),
                ]),
              ),
          ),
          Container(
              height: 180.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  ListTile(
                    title: Text(
                        "You have been shortlisted for the job - Data Analyst at Deloitte."),
                    trailing: Text("1 mo"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0 , left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: basicColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                            child: Text(
                              "View Application",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: basicColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => null),
                      )),
                ]),
              ),
          ),
           Container(
              height: 180.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  ListTile(
                    title: Text(
                        "You have an interview at Deloitte, scheduled on 2/04/2020"),
                    trailing: Text("1 mo"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0 , left: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: basicColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                            child: Text(
                              "View Application",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: basicColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => null),
                      )),
                ]),
              ),
          )
        ]),
            )));
  }
}
