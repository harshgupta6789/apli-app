import 'package:apli/Shared/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Skills extends StatefulWidget {
  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  double width, height;
  TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: basicColor,
          title: Text(
            'Skills',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'Add Skills',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                    child: IconButton(
                      icon: Icon(EvaIcons.editOutline),
                      color: Colors.grey,
                      onPressed: null,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'eg. Management, Programming',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Skill'),
                            SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              initialValue: 'JavaScript',
                              enabled: false,
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('Proficiency'),
                            SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              initialValue: 'Basic',
                              enabled: false,
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
