import 'dart:math';

import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Temp extends StatefulWidget {
  final String link;
  Temp({this.link});
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  YoutubePlayerController _controller;
  ScrollController _scrollController = new ScrollController();
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 1.0
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
      ),
    );
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.link),
      flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          isLive: true,
          forceHD: true,
          loop: false,
          disableDragSeek: true),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//        bottomNavigationBar: BottomAppBar(
//          color: Colors.transparent,
//          child: Container(
//            width: double.infinity,
//            height: 60,
//            color: Colors.transparent,
//            padding: EdgeInsets.only(top: 10, bottom: 5),
//            child: Center(
//                child: ListTile(
//                  leading: FlutterLogo(),
//                  title: TextFormField(
//                    textInputAction: TextInputAction.done,
//                    decoration: loginFormField.copyWith(
//                        hintText: 'Type Here',
//                        ),
//                  ),
//                  trailing: IconButton(
//                    icon: Icon(Icons.send),
//                    onPressed: () {
//                      showToast('msg', context);
//                    },
//                  ),
//                )),
//          ),
//          elevation: 0,
//        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      liveUIColor: basicColor,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (BuildContext context, int index) {
                            var rng = new Random();
                            return Container(
                              margin: EdgeInsets.all(8),
                              decoration: myBoxDecoration(),
                              child: ListTile(
                                isThreeLine: true,
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Text('randomAlpha(1).toUpperCase()'),
                                ),
                                title: Text('randomAlpha(10 * (1 + rng.nextInt(2)))', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                subtitle: Text('randomAlpha(10 * (1 + rng.nextInt(10)))', maxLines: 3, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                                trailing: Text('12:38 pm', style: TextStyle(fontSize: 12),),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: ListTile(
                          leading: FlutterLogo(),
                          title: TextFormField(
                            textInputAction: TextInputAction.done,
                            decoration: loginFormField.copyWith(
                              hintText: 'Type Here',
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              showToast('msg', context);
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
