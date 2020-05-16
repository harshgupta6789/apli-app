import 'dart:io';

import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Awards extends StatefulWidget {
  @override
  _AwardsState createState() => _AwardsState();
}

class _AwardsState extends State<Awards> {
  String userEmail;

  void fetchInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('email') != null) {
        setState(() {
          userEmail = prefs.getString('email');
        });
      }
    });
  }

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: basicColor,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                awards,
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
          future: Firestore.instance
              .collection('candidates')
              .document(userEmail)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error, try again later'),
              );
            } else if (snapshot.connectionState == ConnectionState.done)
              return AwardsForm(snapshot: snapshot, email: userEmail);
            else
              return Loading();
          },
        ));
  }
}

class AwardsForm extends StatefulWidget {
  AsyncSnapshot snapshot;
  String email;
  AwardsForm({this.snapshot, this.email});
  @override
  _AwardsFormState createState() => _AwardsFormState();
}

class _AwardsFormState extends State<AwardsForm> {
  AsyncSnapshot snapshot;
  double width, height, scale;
  List awards;
  File file;
  String desc, newAwardDescription, email;
  bool loading = false;
  Timestamp newAwardDate;
  Map<String, TextEditingController> temp = {}, temp2 = {};
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("MM-yyyy");
  final _APIService = APIService(type: 3);

  @override
  void initState() {
    email = widget.email;
    snapshot = widget.snapshot;
    awards = snapshot.data['award'] ?? [];
    super.initState();
  }

  @override
  void dispose() {
    temp.forEach((k, v) {
      v.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width < 360)
      scale = 0.7;
    else
      scale = 1;
    return loading
        ? Loading()
        : ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(width * 0.04 * scale),
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                25 * scale, 5, 25 * scale, 5),
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: basicColor, width: 1.5),
                              ),
                              onPressed: () {
                                newAwardDescription = null;
                                newAwardDate = null;
                                showDialog(
                                  context: context,
                                  builder: (_) => SimpleDialog(
                                    title: Text(
                                      'Add New Award',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    children: <Widget>[
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.fromLTRB(
                                            20 * scale, 20, 20 * scale, 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            TextFormField(
                                              autofocus: true,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'eg: 1st Prize in Skating',
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                      ))),
                                              onChanged: (value) {
                                                setState(() {
                                                  newAwardDescription = value;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: width * 0.4 * scale,
                                              child: DateTimeField(
                                                  textAlign: TextAlign.left,
                                                  format: DateFormat("MM-yyyy"),
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final date =
                                                        await showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime(1900),
                                                            initialDate:
                                                                DateTime.now(),
                                                            lastDate:
                                                                DateTime(2100));

                                                    return date;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newAwardDate = value ==
                                                              null
                                                          ? null
                                                          : Timestamp
                                                              .fromMicrosecondsSinceEpoch(
                                                                  value
                                                                      .microsecondsSinceEpoch);
                                                    });
                                                  },
                                                  decoration: x("Date")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'CLOSE',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              'ADD',
                                              style:
                                                  TextStyle(color: basicColor),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              if (newAwardDescription != null &&
                                                  newAwardDate !=
                                                      null) if (newAwardDescription !=
                                                  '')
                                                setState(() {
                                                  awards.add({
                                                    'description':
                                                        newAwardDescription,
                                                    'date': newAwardDate
                                                  });
                                                });
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Text(
                                  'Add New Award',
                                  style: TextStyle(
                                      color: basicColor,
                                      fontWeight: FontWeight.w600),
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
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: awards.length,
                              itemBuilder: (BuildContext context1, int index) {
                                if (!temp.containsKey(index.toString())) {
                                  temp[index.toString()] =
                                      new TextEditingController(
                                          text: awards[index]['description']);
                                  temp2[index.toString()] =
                                      new TextEditingController(
                                          text: DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      awards[index]['date']
                                                          .microsecondsSinceEpoch)
                                              .toString()
                                              .substring(0, 7));
                                }
                                return Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Award ' + (index + 1).toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: temp[index.toString()],
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                        decoration: InputDecoration(
                                            hintText:
                                                'eg: 1st Prize in Skating',
                                            contentPadding: EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                ))),
                                        onChanged: (value) {
                                          setState(() {
                                            awards[index]['description'] =
                                                value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value.isEmpty)
                                            return 'field cannot be empty';
                                          else
                                            return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              child: SizedBox(
                                                width: width * 0.2 * scale,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    DateTime date = await showDatePicker(
                                                        context: context,
                                                        firstDate:
                                                            DateTime(1900),
                                                        initialDate: awards[index]
                                                                    ['date'] !=
                                                                null
                                                            ? DateTime.fromMicrosecondsSinceEpoch(
                                                                awards[index]
                                                                        ['date']
                                                                    .microsecondsSinceEpoch)
                                                            : DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100));
                                                    setState(() {
                                                      if (date != null)
                                                        temp2[index.toString()]
                                                                .text =
                                                            date
                                                                .toString()
                                                                .substring(
                                                                    0, 7);
                                                      awards[index]
                                                          ['date'] = date ==
                                                              null
                                                          ? null
                                                          : Timestamp
                                                              .fromMicrosecondsSinceEpoch(
                                                                  date.microsecondsSinceEpoch);
                                                    });
                                                  },
                                                  child: Container(
                                                    width: width * 0.3 * scale,
                                                    color: Colors.transparent,
                                                    child: IgnorePointer(
                                                        child: TextFormField(
                                                      controller: temp2[
                                                          index.toString()],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13),
                                                      decoration:
                                                          InputDecoration(
                                                              //labelText: 'Date',
                                                              hintText:
                                                                  'eg: 1st Prize in Skating',
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              border:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                      ))),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          awards[index][
                                                                  'description'] =
                                                              value;
                                                        });
                                                      },
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(),
                                            child: IconButton(
                                              icon: Icon(Icons.delete_outline),
                                              onPressed: () {
                                                awards.removeAt(index);
                                                for (int i = index;
                                                    i < awards.length;
                                                    i++) {
                                                  temp[i.toString()].text =
                                                      awards[i]['description'];
                                                  temp2[i.toString()]
                                                      .text = DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              awards[i]['date']
                                                                  .microsecondsSinceEpoch)
                                                      .toString()
                                                      .substring(0, 7);
                                                }
                                                temp.remove(
                                                    awards.length.toString());
                                                temp2.remove(
                                                    awards.length.toString());
                                                setState(() {});
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (index == awards.length - 1)
                                        SizedBox()
                                      else
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: basicColor, width: 1.5),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: basicColor),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                Map<String, dynamic> map = {};
                                map['award'] = List.from(awards);
                                map['index'] = -1;
                                dynamic result =
                                    await _APIService.sendProfileData(map);
                                if (result == 1) {
                                  showToast(
                                      'Data Updated Successfully', context);
                                } else {
                                  showToast(
                                      'Unexpected error occured', context);
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
