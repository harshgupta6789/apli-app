import 'package:apli/Shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseLive extends StatefulWidget {
  final String link;
  CourseLive({this.link});
  @override
  _CourseLiveState createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> {
  YoutubePlayerController _controller;
  bool visible = true, tapped = false, go = false;

  @override
  void initState() {
    Wakelock.enable();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.link),
      flags: YoutubePlayerFlags(
          enableCaption: false,
          autoPlay: true,
          mute: false,
          isLive: true,
          forceHD: true,
          loop: false,
          disableDragSeek: true,
          hideControls: true),
    );
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () {
            setState(() {
              visible = !visible;
              if (tapped != true) go = true;
            });
            if (go == true)
              Future.delayed(Duration(seconds: 4), () {
                if (mounted)
                  setState(() {
                    visible = false;
                    tapped = false;
                  });
              });
          },
          onDoubleTap: () {
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
              ]);
            else
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
          },
          child: Stack(
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
                onReady: () {
                  setState(() {
                    visible = false;
                  });
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    'Double tap to toggle fullscreen',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
