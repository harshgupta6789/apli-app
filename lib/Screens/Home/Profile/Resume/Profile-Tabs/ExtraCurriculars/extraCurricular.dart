import 'package:apli/Screens/Home/Profile/Resume/Profile-Tabs/ExtraCurriculars/newExtraCurricular.dart';
import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtraCurricular extends StatelessWidget {
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
          temp = snapshot.data['extra_curricular'] ?? [];
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: basicColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  extra,
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
                    onPressed: () => Navigator.pop(context, true)),
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
                  return ExtraCurriculars(
                    extraCurriculars: snapshot.data ?? [],
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
          )),
    );
  }
}

class ExtraCurriculars extends StatefulWidget {
  List extraCurriculars;
  ExtraCurriculars({this.extraCurriculars});

  @override
  _ExtraCurricularsState createState() => _ExtraCurricularsState();
}

class _ExtraCurricularsState extends State<ExtraCurriculars> {
  double width, height;
  bool loading = false, orderChanged = false;

  List extraCurriculars;

  final apiService = APIService(profileType: 4);

  @override
  void initState() {
    extraCurriculars = widget.extraCurriculars;
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
                                  builder: (context) => NewExtraCurricular(
                                        old: false,
                                        extraCurriculars: extraCurriculars,
                                        index: extraCurriculars.length,
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
                    Visibility(
                      visible: orderChanged,
                      child: RaisedButton(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: basicColor, width: 1.5),
                        ),
                        child: Text(
                          'Save Order',
                          style: TextStyle(color: basicColor),
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          Map<String, dynamic> map = {};
                          map['extra_curricular'] = List.from(extraCurriculars);
                          map['index'] = -1;
                          dynamic result =
                              await apiService.sendProfileData(map);
                          if (result == 1) {
                            showToast('Data Updated Successfully', context);
                          } else {
                            showToast('Unexpected error occurred', context);
                          }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExtraCurricular()));
                        },
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
                        itemCount: extraCurriculars.length,
                        itemBuilder: (BuildContext context1, int index) {
                          String start =
                              extraCurriculars[index]['start'] == null
                                  ? null
                                  : DateTime.fromMicrosecondsSinceEpoch(
                                              extraCurriculars[index]['start']
                                                  .microsecondsSinceEpoch)
                                          .month
                                          .toString() +
                                      '-' +
                                      DateTime.fromMicrosecondsSinceEpoch(
                                              extraCurriculars[index]['start']
                                                  .microsecondsSinceEpoch)
                                          .year
                                          .toString();
                          String end = extraCurriculars[index]['end'] == null
                              ? null
                              : DateTime.fromMicrosecondsSinceEpoch(
                                          extraCurriculars[index]['end']
                                              .microsecondsSinceEpoch)
                                      .month
                                      .toString() +
                                  '-' +
                                  DateTime.fromMicrosecondsSinceEpoch(
                                          extraCurriculars[index]['end']
                                              .microsecondsSinceEpoch)
                                      .year
                                      .toString();
                          String duration = (start ?? '') +
                              ' to ' +
                              ((start != null && end == null)
                                  ? 'ongoing'
                                  : end ?? '');
                          String info1, info2;
                          info1 = extraCurriculars[index]['info'] == null
                              ? ''
                              : extraCurriculars[index]['info'][0];
                          info2 = extraCurriculars[index]['info'] == null
                              ? ''
                              : extraCurriculars[index]['info'][1];
                          return Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    padding: EdgeInsets.all(8),
                                    child: ListTile(
                                      title: Text(
                                        extraCurriculars[index]['role'] ??
                                            'Role',
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
                                          Text('Organisation/Committee: ' +
                                              (extraCurriculars[index]
                                                      ['organisation'] ??
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
                                                        NewExtraCurricular(
                                                          extraCurriculars:
                                                              extraCurriculars,
                                                          index: index,
                                                          old: true,
                                                        )));
                                          } else if (result == 1) {
                                            setState(() {
                                              loading = true;
                                            });
                                            Map<String, dynamic> map = {};
                                            map['extra_curricular'] =
                                                List.from(extraCurriculars);
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
                                                        ExtraCurricular()));
                                          } else if (result == 2) {
                                            int x = index;
                                            int y = index - 1;
                                            var l1 = extraCurriculars[x];
                                            var l2 = extraCurriculars[y];
                                            extraCurriculars[x] = l2;
                                            extraCurriculars[y] = l1;
                                            setState(() {
                                              orderChanged = true;
                                            });
                                          } else if (result == 3) {
                                            int x = index;
                                            int y = index + 1;
                                            var l1 = extraCurriculars[x];
                                            var l2 = extraCurriculars[y];
                                            extraCurriculars[x] = l2;
                                            extraCurriculars[y] = l1;
                                            setState(() {
                                              orderChanged = true;
                                            });
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          if (extraCurriculars.length == 1)
                                            return <PopupMenuEntry<int>>[
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ];
                                          else if (index == 0)
                                            return <PopupMenuEntry<int>>[
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 3,
                                                child: Visibility(
                                                  visible: (index ==
                                                          projects.length - 1)
                                                      ? false
                                                      : true,
                                                  child: Text(
                                                    'Move Down',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ];
                                          else if (index ==
                                              extraCurriculars.length - 1)
                                            return <PopupMenuEntry<int>>[
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 2,
                                                child: Text(
                                                  'Move Up',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ];
                                          else
                                            return <PopupMenuEntry<int>>[
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 2,
                                                child: Text(
                                                  'Move Up',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 3,
                                                child: Text(
                                                  'Move Down',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ];
                                        },
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
