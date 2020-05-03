import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';

class ExtraC extends StatefulWidget {
  @override
  _ExtraCState createState() => _ExtraCState();
}

class _ExtraCState extends State<ExtraC> {
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
            'Extra Curricular',
            style: TextStyle(fontWeight: appBarFontWeight),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
