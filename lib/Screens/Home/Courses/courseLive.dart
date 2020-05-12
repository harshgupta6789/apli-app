import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseLive extends StatefulWidget {
  String link;
  CourseLive({this.link});
  @override
  _CourseLiveState createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> {
  
  YoutubePlayerController _controller;
  
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.link),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: true
      ),
    );
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        body: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
