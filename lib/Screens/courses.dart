import 'package:apli/Screens/courseVideo.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/customDrawer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: _listTabs.length);
    super.initState();
  }

  Widget _overView() {
    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type speciLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,.",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.start,
          ),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: basicColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                    child: Text(
                      enroll,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => null),
              )),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
    );
  }

  Widget _content() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
            "Introduction",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => VideoApp()));
            },
            title: Text(
              "Why Startup?",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Video | 2m"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: ListTile(
            title: Text(
              "What do you need for startup?",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Video | 2m"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: ListTile(
            title: Text(
              "Naming your startup?",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Video | 2m"),
          ),
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Widget _certificate() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            completion,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Image.asset("Assets/Images/job.png")),
          ),
        ],
      ),
    );
  }

  final List<Tab> _listTabs = [
    Tab(
      text: overview,
    ),
    Tab(
      text: content,
    ),
    Tab(
      text: certificate,
    )
  ];

  Widget _getWidget(Tab tab) {
    switch (tab.text) {
      case overview:
        return _overView();
      case content:
        return _content();
      case certificate:
        return _certificate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: customDrawer(context),
        backgroundColor: Colors.white,
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
                    EvaIcons.searchOutline,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    EvaIcons.moreVerticalOutline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  }),
            ],
            title: Text(
              courses,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset("Assets/Images/course.png"),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130.0,
                      left: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Trending",
                                style: TextStyle(color: Colors.yellow)),
                            Text("Startup 101",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                )),
                            Text("By Harvard",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 18,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, top: 30.0),
                  child: Text("What's Inside:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new TabBar(
                      controller: _tabController,
                      indicatorColor: basicColor,
                      unselectedLabelColor: Colors.grey,
                      labelColor: basicColor,
                      tabs: _listTabs),
                ),
                new Container(
                  height: 500.0,
                  child: new TabBarView(
                    controller: _tabController,
                    children: _listTabs.map((Tab tab) {
                      return _getWidget(tab);
                    }).toList(),
                  ),
                )
              ]),
        ));
  }
}
