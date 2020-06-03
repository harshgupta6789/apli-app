import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/Projects/newProject.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Project extends StatelessWidget {
  double width, height;
  String userEmail;
  bool error;

  Future<List> getInfo() async {
    List temp;
    await SharedPreferences.getInstance().then((value) async {
      try {
        await Firestore.instance
            .collection('candidates')
            .document(value.getString('email'))
            .get()
            .then((snapshot) {
          temp = snapshot.data['projects'] ?? [];
        });
      } catch (e) {
        temp = [
          {'error': true}
        ];
      }
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Projects',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),
          preferredSize: Size.fromHeight(55),
        ),
        body: FutureBuilder(
          future: getInfo(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.length > 0 &&
                  snapshot.data[0].containsKey('error'))
                return Center(
                  child: Text('Error occured, try again later'),
                );
              else
                return Projects(
                  projects: snapshot.data ?? [],
                );
            } else {
              if (snapshot.hasError)
                return Center(
                  child: Text('Error occured, try again later'),
                );
              else
                return Loading();
            }
          },
        ));
  }
}

class Projects extends StatefulWidget {
  List projects;
  Projects({this.projects});

  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  double width, height;
  bool loading = false;

  List projects;

  final apiService = APIService(profileType: 5);

  @override
  void initState() {
    projects = widget.projects;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Container(
            padding: EdgeInsets.fromLTRB(width * 0.05, 30, width * 0.05, 0),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: RaisedButton(
                        padding: EdgeInsets.all(0),
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: basicColor, width: 1.5),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewProject(
                                        old: false,
                                        projects: projects,
                                        index: projects.length,
                                      )));
                        },
                        child: ListTile(
                          leading: Text(
                            'Add New Activity',
                            style: TextStyle(
                                color: basicColor, fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(
                            Icons.add,
                            color: basicColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: projects.length,
                        itemBuilder: (BuildContext context1, int index) {
                          String from = projects[index]['from'] == null
                              ? null
                              : DateTime.fromMicrosecondsSinceEpoch(
                                          projects[index]['from']
                                              .microsecondsSinceEpoch)
                                      .month
                                      .toString() +
                                  '-' +
                                  DateTime.fromMicrosecondsSinceEpoch(
                                          projects[index]['from']
                                              .microsecondsSinceEpoch)
                                      .year
                                      .toString();
                          String to = projects[index]['to'] == null
                              ? null
                              : DateTime.fromMicrosecondsSinceEpoch(
                                          projects[index]['to']
                                              .microsecondsSinceEpoch)
                                      .month
                                      .toString() +
                                  '-' +
                                  DateTime.fromMicrosecondsSinceEpoch(
                                          projects[index]['to']
                                              .microsecondsSinceEpoch)
                                      .year
                                      .toString();
                          String duration = (from ?? '') +
                              ' to ' +
                              ((from != null && to == null)
                                  ? 'ongoing'
                                  : to ?? '');
                          String info1, info2;
                          info1 = projects[index]['information'] == null
                              ? ''
                              : projects[index]['information'][0];
                          info2 = projects[index]['information'] == null
                              ? ''
                              : projects[index]['information'][1];
                          return Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.grey)),
                                    padding: EdgeInsets.all(8),
                                    child: ListTile(
                                      title: Text(
                                        projects[index]['Name'] ??
                                            'Project Title',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('Company/University: ' +
                                              (projects[index]
                                                      ['University_Company'] ??
                                                  '')),
                                          Text('Duration: ' + duration),
                                          Text('Responsibilities: '),
                                          Text('1: ' + info1),
                                          Text('2: ' + info2),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.only(left: 8),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PopupMenuButton<int>(
                                        icon: Icon(Icons.more_vert),
                                        onSelected: (int result) async {
                                          if (result == 0) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewProject(
                                                          projects: projects,
                                                          index: index,
                                                          old: true,
                                                        )));
                                          } else if (result == 1) {
                                            setState(() {
                                              loading = true;
                                            });
                                            Map<String, dynamic> map = {};
                                            map['project'] =
                                                List.from(projects);
                                            map['index'] = index;

                                            dynamic result = await apiService
                                                .sendProfileData(map);
                                            if (result == 1) {
                                              showToast(
                                                  'Data Updated Successfully',
                                                  context);
                                            } else {
                                              showToast(
                                                  'Unexpected error occured',
                                                  context);
                                            }
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Project()));
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<int>>[
                                          const PopupMenuItem<int>(
                                            value: 0,
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          const PopupMenuItem<int>(
                                            value: 1,
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
