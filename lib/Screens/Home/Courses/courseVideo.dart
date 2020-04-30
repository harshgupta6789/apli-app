import 'dart:io';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp(
      videoUrl: null,
      isCourse: null,
    ));

class VideoApp extends StatefulWidget {
  final String videoUrl;
  final String title;
  final File file;
  final bool isCourse;

  const VideoApp(
      {Key key,
      @required this.videoUrl,
      this.title,
      this.file,
      @required this.isCourse})
      : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  Future<void> _videoPlayerFuture;
  bool _controls = true;
  AnimationController _animationController;
  double height, width;
  String total;
  String current;
  Duration di, dt;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    if (widget.isCourse != true) {
      _videoPlayerController = VideoPlayerController.file(widget.file);
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    }

    _videoPlayerFuture = _videoPlayerController.initialize().then((_) => {
          _videoPlayerController
            ..play()
            ..setVolume(1.0),
          _animationController.forward()
        });

    _videoPlayerController.addListener(() {
      dt = _videoPlayerController.value.duration;
      di = _videoPlayerController.value.position;
      setState(() {
        total = '${dt.inMinutes}:${dt.inSeconds.remainder(60)}';
        current = '${di.inMinutes}:${di.inSeconds.remainder(60)}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _videoPlayerFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (_videoPlayerController.value.initialized &&
              snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController)),
                      onTap: () {
                        setState(() {
                          _controls = !_controls;
                        });
                      },
                    ),
                  ),
                  _controls
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              widget.title ?? "Now Playing",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
                      : Container(),
//                  if (_controls)
//                    Padding(
//                      padding: const EdgeInsets.all(20.0),
//                      child: Align(
//                        alignment: Alignment.topCenter,
//                        child: Text(
//                           widget.title??"Now Playing",
//                          style: TextStyle(color: Colors.white, fontSize: 18),
//                        ),
//                      ),
//                    ),
                  Align(
                    alignment: Alignment.center,
                    child: _controls
                        ? FloatingActionButton(
                            elevation: 0,
                            disabledElevation: 0.0,
                            focusElevation: 0.0,
                            highlightElevation: 0.0,
                            hoverElevation: 0.0,
                            heroTag: 'nonononon',
                            backgroundColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                if (_videoPlayerController.value.isPlaying) {
                                  _videoPlayerController.pause();
                                  _animationController.reverse();
                                } else {
                                  _videoPlayerController.play();
                                  _animationController.forward();
                                }
                              });
                            },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              size: 40,
                              progress: _animationController,
                            ),
                          )
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _controls
                        ? Padding(
                            padding: const EdgeInsets.only(right: 50.0),
                            child: FloatingActionButton(
                              elevation: 0,
                              disabledElevation: 0.0,
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              hoverElevation: 0.0,
                              heroTag: 'lololol',
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position +
                                        Duration(seconds: 10));
                              },
                              child: Icon(
                                Icons.forward_10,
                                size: 40,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _controls
                        ? Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: FloatingActionButton(
                              elevation: 0,
                              disabledElevation: 0.0,
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              hoverElevation: 0.0,
                              heroTag: 'none',
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                _videoPlayerController.seekTo(
                                    _videoPlayerController.value.position -
                                        Duration(seconds: 10));
                              },
                              child: Icon(Icons.replay_10, size: 40),
                            ),
                          )
                        : null,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: _controls
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: FloatingActionButton(
                              elevation: 0,
                              disabledElevation: 0.0,
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              hoverElevation: 0.0,
                              splashColor: Colors.transparent,
                              heroTag: 'none',
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 24,
                              ),
                            ),
                          )
                        : null,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  current.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 50.0),
                              child: Container(
                                width: width * 0.8,
                                child: VideoProgressIndicator(
                                  _videoPlayerController,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      playedColor:
                                          Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(total.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        )),
                  ),
                ]));
          } else {
            return Container(
              color: Colors.black,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoPlayerController.dispose();
  }
}
