import 'package:apli/Shared/constants.dart';
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
  double width, height;
  String email;
  bool loading = false;

  List skills;

  userInit() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if(mounted)
        setState(() {
          email = prefs.getString('email');
        });
      else
        email = prefs.getString('email');
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
    });
  }

  @override
  void initState() {
    userInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return loading ? Loading() : skills == null ? Loading() : Scaffold(
      backgroundColor: Colors.white,
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
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(color: basicColor, width: 1.5),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                          title: Text(
                            'Add Skill Group',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          titlePadding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'CLOSE',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(color: basicColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {});
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
                        'Add Skill Group',
                        style: TextStyle(color: basicColor, fontWeight: FontWeight.w600),
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
                    itemBuilder: (BuildContext context1, int index1) {
                      Map<String, dynamic> skillGroup = skills[index1];
                      String skillName = skillGroup.keys.first;
                      List miniSkills = skillGroup[skillName];
                      return Container(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  skillName ?? Error,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                FlatButton(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: basicColor, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {}),
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
                                    (BuildContext context2, int index2) {
                                  String miniSkill = miniSkills[index2].keys.first;
                                  String proficiency = miniSkills[index2][miniSkill];
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: width * 0.4,
                                            child: TextFormField(
                                              initialValue: miniSkill ?? 'Error',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                      ))),
                                              onChanged: (value) {
                                                setState(() {
                                                  skills[index1][skillName][index2].remove(miniSkill);
                                                  skills[index1][skillName][index2][value] = proficiency;
                                                });
                                              },
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Container(
                                              color: Colors.grey[300],
                                              padding:
                                                  EdgeInsets.fromLTRB(10, 0, 5, 0),
                                              child: DropdownButton<String>(
                                                value: proficiency ?? 'Basic',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                                icon: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Icon(
                                                      Icons.keyboard_arrow_down),
                                                ),
                                                underline: SizedBox(),
                                                items: <String>[
                                                  'Basic',
                                                  'Intermediate',
                                                  'Expert'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    skills[index1][skillName][index2][miniSkill] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 15),
                                            child: IconButton(
                                              icon: Icon(Icons.delete_outline),
                                              onPressed: () {
                                                print(index2);
                                                print(skills[index1][skillName].elementAt(index2));
                                                setState(() {
                                                  skills[index1][skillName].removeAt(index2);
                                                });
                                                print(skills[index1][skillName]);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 0.4,
                                  child: InkWell(
                                    onTap: () {},
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Add new skill',
                                            hintStyle: TextStyle(fontSize: 12),
                                            suffixIcon: Icon(Icons.add),
                                            contentPadding: EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                ))),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.grey[300],
                                    padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: DropdownButton<String>(
                                        value: 'Proficiency',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child:
                                              Icon(Icons.keyboard_arrow_down),
                                        ),
                                        underline: SizedBox(),
                                        items: <String>[
                                          'Proficiency',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(6.0),
                    side: BorderSide(
                        color: basicColor, width: 1.5),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: basicColor),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await Firestore.instance.collection('candidates').document(email).setData({'skills' : skills}, merge: true).then((f) {
                      Navigator.pop(context);
                    });
                  },
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
