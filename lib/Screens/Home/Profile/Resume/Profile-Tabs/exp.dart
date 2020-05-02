import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';

class Expereince extends StatefulWidget {
  @override
  _ExpereinceState createState() => _ExpereinceState();
}

class _ExpereinceState extends State<Expereince> {
  double width, height;

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
        preferredSize: Size.fromHeight(preferredSize),
        child: AppBar(
          backgroundColor: basicColor,
          title: Text(
            'Experience',
            style: TextStyle(fontWeight: appBarFontWeight),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
