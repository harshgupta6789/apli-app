import 'package:flutter/material.dart';

class MyLinearProgressIndicator extends StatefulWidget {
  int milliSeconds;
  MyLinearProgressIndicator({this.milliSeconds});
  @override
  _MyLinearProgressIndicatorState createState() =>
      _MyLinearProgressIndicatorState();
}

class _MyLinearProgressIndicatorState extends State<MyLinearProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  AnimationController controller2;
  Animation<Color> color;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.milliSeconds), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();
    controller2 =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    color = ColorTween(begin: Colors.green, end: Colors.red).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void animateColor() {
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.grey[300],
        valueColor: color,
      ),
    ));
  }
}
