import 'package:apli/Screens/Home/Profile/editResume.dart';
import 'package:apli/Models/user.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:apli/Shared/customTabBar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<User>(context);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: customDrawer(context, user),
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
            ],
            title: Text(
              profile,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            bottom: ColoredTabBar(
                Colors.white,
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: basicColor,
                  tabs: [
                    new Tab(
                      text: resume,
                    ),
                    new Tab(
                      text: videoIntro,
                    ),
                    new Tab(text: psychTest)
                  ],
                  controller: _tabController,
                )),
          ),
          preferredSize: Size.fromHeight(120),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    resumeSlogan,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Image.asset("Assets/Images/job.png"),
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
                                      builder: (context) => EditResume()),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(EvaIcons.shareOutline),
                              onPressed: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(EvaIcons.downloadOutline),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    videoIntroSlogan,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child:Text("Instructions to follow" , style: TextStyle(fontSize:20 ,fontWeight: FontWeight.w600)) , alignment:Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child:Text("1. Lorem Ipsum" , style: TextStyle(fontSize:20)), alignment:Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child: Text("1. Lorem Ipsum" , style: TextStyle(fontSize:20)), alignment:Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child: Text("1. Lorem Ipsum" ,style: TextStyle(fontSize:20)), alignment:Alignment.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(child: Text("1. Lorem Ipsum" , style: TextStyle(fontSize:20),), alignment:Alignment.center),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: basicColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                child: Text(
                                  "Upload From Gallery",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: basicColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () => null),
                          ),
                      Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: basicColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                child: Text(
                                  "Record Now",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: basicColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () => null),
                          ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Center(child: Image.asset("Assets/Images/job.png")),
        ], controller: _tabController));
  }
}
