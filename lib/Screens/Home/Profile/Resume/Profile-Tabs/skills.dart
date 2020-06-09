import 'package:apli/Services/APIService.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Skills extends StatefulWidget {
  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {

 // THIS SCREEN LETS THE USER ADD , DELETE & DISPLAY THE SKILLS //
 // USES API TO UPDATE THE DATA , FOR API DOCUMENTATION REFER TO PROFILE WIKI ON GITHUB APIS CAN BE FOUND IN APISERVICE FILE//

  double width, height, scale;
  String email, newSkillGroup, newMiniSkill;
  bool loading = false, error = false;
  final apiService = APIService(profileType: 2);
  List skills;
  Map<String, TextEditingController> temp = {};
  final _formKey = GlobalKey<FormState>();

  userInit() async {

  // USES FIREBASE READ TO FETCH ALL THE LIST OF SKILLS , IF ANY //

    await SharedPreferences.getInstance().then((prefs) async {
      if (mounted)
        setState(() {
          email = prefs.getString('email');
        });
      else
        email = prefs.getString('email');
      try {
        await Firestore.instance
            .collection('candidates')
            .document(prefs.getString('email'))
            .get()
            .then((snapshot) {
          if (mounted)
            setState(() {
              skills = snapshot.data['skills'] ?? [];
            });
          else
            skills = snapshot.data['skills'] ?? [];
        });
      } catch (e) {
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  void initState() {
    userInit();
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
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(preferredSize),
              child: AppBar(
                backgroundColor: basicColor,
                title: Text(
                  'Skills',
                  style: TextStyle(fontWeight: appBarFontWeight),
                ),
              ),
            ),
            body: error
                ? Center(
                    child: Text('Error occured, try again later'),
                  )
                : skills == null
                    ? Loading()
                    : ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(width * 0.04 * scale),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        25 * scale, 5, 25 * scale, 5),
                                    child: RaisedButton(
                                      padding: EdgeInsets.all(0),
                                      color: Theme.of(context).backgroundColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        side: BorderSide(
                                            color: basicColor, width: 1.5),
                                      ),
                                      onPressed: () {
                                        newSkillGroup = null;
                                        showDialog(
                                          context: context,
                                          builder: (_) => SimpleDialog(
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            title: Text(
                                              'Add Skill Group',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            children: <Widget>[
                                              Container(
                                                width: width * 0.4 * scale,
                                                padding: EdgeInsets.fromLTRB(
                                                    20 * scale,
                                                    20,
                                                    20 * scale,
                                                    20),
                                                child: TextField(
                                                  autofocus: false,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'eg: Management, Programming',
                                                      contentPadding:
                                                          EdgeInsets.all(
                                                              10 * scale),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                              ))),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newSkillGroup = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      'CLOSE',
                                                      style: TextStyle(),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text(
                                                      'ADD',
                                                      style: TextStyle(),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (newSkillGroup != null)
                                                        setState(() {
                                                          skills.add({
                                                            newSkillGroup: [
                                                              {'': 'Basic'}
                                                            ]
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
                                        //focusColor: Theme.of(context).backgroundColor,
                                        leading: Text(
                                          'Add Skill Group',
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
                                      itemCount: skills.length,
                                      itemBuilder:
                                          (BuildContext context1, int index1) {
                                        Map<String, dynamic> skillGroup =
                                            skills[index1];
                                        String skillName =
                                            skillGroup.keys.first;
                                        List miniSkills = skillGroup[skillName];
                                        return Container(
                                          padding: EdgeInsets.only(bottom: 40),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    skillName ?? Error,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  FlatButton(
                                                      child: Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color: basicColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          skills
                                                              .removeAt(index1);
                                                        });
                                                      }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemCount: miniSkills.length,
                                                  itemBuilder:
                                                      (BuildContext context2,
                                                          int index2) {
                                                    String miniSkill =
                                                        miniSkills[index2]
                                                            .keys
                                                            .first;
                                                    String proficiency =
                                                        miniSkills[index2]
                                                            [miniSkill];
                                                    if (!temp.containsKey(
                                                        skillName +
                                                            index2.toString()))
                                                      temp[skillName +
                                                              index2
                                                                  .toString()] =
                                                          new TextEditingController(
                                                              text: miniSkill);
                                                    return Column(
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: width *
                                                                  0.4 *
                                                                  scale,
                                                              child:
                                                                  TextFormField(
                                                                controller: temp[
                                                                    skillName +
                                                                        index2
                                                                            .toString()],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12),
                                                                decoration: InputDecoration(
                                                                    contentPadding: EdgeInsets.all(10 * scale),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        borderSide: BorderSide(
                                                                          color:
                                                                              Colors.grey,
                                                                        ))),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    skills[index1][skillName]
                                                                            [
                                                                            index2]
                                                                        .remove(
                                                                            miniSkill);
                                                                    skills[index1][skillName][index2]
                                                                            [
                                                                            value] =
                                                                        proficiency;
                                                                  });
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  if (value
                                                                      .isEmpty)
                                                                    return 'cannot be empty';
                                                                  else
                                                                    return null;
                                                                },
                                                              ),
                                                            ),
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .backgroundColor,
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                        10 *
                                                                            scale,
                                                                        0,
                                                                        5 * scale,
                                                                        0),
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  value: proficiency ==
                                                                          null
                                                                      ? 'Basic'
                                                                      : proficiency
                                                                              .substring(0,
                                                                                  1)
                                                                              .toUpperCase() +
                                                                          proficiency
                                                                              .substring(1),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline4
                                                                          .color,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12),
                                                                  icon: Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 10.0 *
                                                                            scale),
                                                                    child: Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down),
                                                                  ),
                                                                  underline:
                                                                      SizedBox(),
                                                                  items: <
                                                                      String>[
                                                                    'Starter',
                                                                    'Basic',
                                                                    'Intermediate',
                                                                    'Expert'
                                                                  ].map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                      value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      skills[index1][skillName][index2]
                                                                              [
                                                                              miniSkill] =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 15 *
                                                                          scale),
                                                              child: IconButton(
                                                                icon: Icon(Icons
                                                                    .delete_outline),
                                                                onPressed: () {
                                                                  if (miniSkills
                                                                          .length ==
                                                                      1) {
                                                                  } else {
                                                                    miniSkills
                                                                        .removeAt(
                                                                            index2);
                                                                    skills[index1]
                                                                            [
                                                                            skillName] =
                                                                        miniSkills;
                                                                    for (int i =
                                                                            index2;
                                                                        i < miniSkills.length;
                                                                        i++) {
                                                                      temp[skillName + i.toString()]
                                                                          .text = miniSkills[
                                                                              i]
                                                                          .keys
                                                                          .first;
                                                                    }
                                                                    temp.remove(skillName +
                                                                        miniSkills
                                                                            .length
                                                                            .toString());
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: width * 0.4 * scale,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              SimpleDialog(
                                                            title: Text(
                                                              'Add Skill',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            ),
                                                            children: <Widget>[
                                                              Container(
                                                                width: width *
                                                                    0.35 *
                                                                    scale,
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                        20 *
                                                                            scale,
                                                                        20,
                                                                        20 *
                                                                            scale,
                                                                        20),
                                                                child:
                                                                    TextField(
                                                                  autofocus:
                                                                      false,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12),
                                                                  decoration: InputDecoration(
                                                                      hintText: 'eg: Javascript, Python3',
                                                                      contentPadding: EdgeInsets.all(10 * scale),
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          borderSide: BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                          ))),
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      newMiniSkill =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                      'CLOSE',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                      'ADD',
                                                                      style: TextStyle(
                                                                          color:
                                                                              basicColor),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      if (newMiniSkill !=
                                                                          null)
                                                                        setState(
                                                                            () {
                                                                          skills[index1][skillName]
                                                                              .add({
                                                                            newMiniSkill:
                                                                                'Basic'
                                                                          });
                                                                          newMiniSkill =
                                                                              null;
                                                                        });
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: IgnorePointer(
                                                        ignoring: true,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Add new skill',
                                                                  hintStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                  suffixIcon:
                                                                      Icon(Icons
                                                                          .add),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(10 *
                                                                              scale),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                          ))),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Container(
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10 * scale,
                                                              0,
                                                              5 * scale,
                                                              0),
                                                      child: IgnorePointer(
                                                        ignoring: true,
                                                        child: DropdownButton<
                                                            String>(
                                                          value: 'Proficiency',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4
                                                                  .color,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13),
                                                          icon: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0 *
                                                                        scale),
                                                            child: Icon(Icons
                                                                .keyboard_arrow_down),
                                                          ),
                                                          underline: SizedBox(),
                                                          items: <String>[
                                                            'Proficiency',
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 15 * scale),
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.delete_outline),
                                                      onPressed: () {},
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    color: Theme.of(context).backgroundColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      side: BorderSide(
                                          color: basicColor, width: 1.5),
                                    ),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: basicColor),
                                    ),
                                    onPressed: () async {

                                      // API CALLS OCCUR HERE //

                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        Map<String, dynamic> map = {};
                                        map['skill'] = List.from(skills);
                                        map['index'] = -1;
                                        dynamic result = await apiService
                                            .sendProfileData(map);
                                        if (result == 1) {
                                          showToast('Data Updated Successfully',
                                              context);
                                        } else {
                                          showToast('Unexpected error occured',
                                              context);
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
                        ),
                      ),
          );
  }
}
