import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseLive extends StatefulWidget {
  final String link, documentID;
  CourseLive({this.link, this.documentID});
  @override
  _CourseLiveState createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive> with SingleTickerProviderStateMixin {
  YoutubePlayerController _controller;
  AnimationController _animationController;
  ScrollController _scrollController = new ScrollController(initialScrollOffset: 0);
  bool visible = true, tapped = false, go = false, loading = false, playing = true;
  TextEditingController _textEditingController = new TextEditingController(text: '');
  FocusNode _focusNode = new FocusNode();
  String name, email;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  getInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      await Firestore.instance.collection('candidates').document(prefs.getString('email')).get().then((value) {
        setState(() {
          email = prefs.getString('email');
          name = (value.data['First_name'] ?? '') + ' ' + (value.data['Last_name'] ?? '');
        });
      });
    });
  }

  @override
  void initState() {
    getInfo();
    Wakelock.enable();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
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
          hideControls: false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    _textEditingController.dispose();
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
    return name == null ? Loading() : SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if(MediaQuery.of(context).orientation == Orientation.landscape)
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
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
                      ),
//                      GestureDetector(
//                        onTap: () {
//                          setState(() {
//                            visible = !visible;
//                            if (tapped != true) go = true;
//                          });
//                          if (go == true)
//                            Future.delayed(Duration(seconds: 4), () {
//                              if (mounted)
//                                setState(() {
//                                  visible = false;
//                                  tapped = false;
//                                });
//                            });
//                        },
//                        onDoubleTap: () {
//                          if (MediaQuery.of(context).orientation ==
//                              Orientation.portrait)
//                            SystemChrome.setPreferredOrientations([
//                              DeviceOrientation.landscapeLeft,
//                            ]);
//                          else
//                            SystemChrome.setPreferredOrientations([
//                              DeviceOrientation.portraitUp,
//                            ]);
//                        },
//                        child: Stack(
//                          children: <Widget>[
//                            YoutubePlayer(
//                              controller: _controller,
//                              showVideoProgressIndicator: true,
//                              onReady: () {
//                                setState(() {
//                                  visible = false;
//                                });
//                              },
//                            ),
//                            Align(
//                              alignment: Alignment.topCenter,
//                              child: AnimatedOpacity(
//                                opacity: visible ? 1 : 0,
//                                duration: Duration(milliseconds: 200),
//                                child: Text(
//                                  'Double tap to toggle fullscreen',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold, backgroundColor: Colors.black45),
//                                ),
//                              ),
//                            ),
////                            Align(
//////                              top: (MediaQuery.of(context).orientation == Orientation.portrait) ?30 :  MediaQuery.of(context).size.height / 2,
//////                              left: MediaQuery.of(context).size.width / 2,
//////                              right: MediaQuery.of(context).size.width / 2,
////                            alignment: Alignment.center,
////                              child: AnimatedOpacity(
////                                opacity: visible ? 1 : 0,
////                                duration: Duration(milliseconds: 200),
////                                child: InkWell(
////                                  onTap: () {
////                                    setState(() {
////                                      if (playing) {
////                                        _controller.pause();
////                                        _animationController.reverse();
////                                      } else {
////                                        _controller.play();
////                                        _animationController.forward();
////                                      }
////                                    });
////                                  },
////                                  child: AnimatedIcon(
////                                    icon: AnimatedIcons.play_pause,
////                                    size: 40,
////                                    progress: _animationController,
////                                  ),
////                                ),
////                              ),
////                            )
//                          ],
//                        ),
//                      ),
                      Visibility(
                        visible: MediaQuery.of(context).orientation == Orientation.portrait,
                        child: Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.white)]
                            ),
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('edu_courses')
                                    .document(widget.documentID)
                                    .collection("comments")
                                    .orderBy("timestamp", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    if((snapshot.data.documents ?? []).length == 0) {
                                      return Center(child: Text('Be the first one to write a comment'),);
                                    }
                                    else return ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      controller: _scrollController,
                                      itemCount: (snapshot.data.documents ?? []).length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var comments = snapshot.data.documents[index] ?? {};
                                        String commentName = comments['name'] ?? 'Anonymous';
                                        String commentNameLetter = (commentName.substring(0, 1)).toUpperCase();
                                        String commentContent = comments['comment'] ?? '';
                                        List<String> commentContentDivided = commentContent.split("#AskAQuestion");
                                        String commentTime = timestampToReadableTimeConverter(comments['timestamp'] ?? Timestamp.now());
                                        Color commentColor = ['A', 'B', 'C', 'D', 'E', 'F'].contains(commentNameLetter) ? Colors.redAccent :
                                        ['G', 'H', 'I', 'J', 'K', 'L'].contains(commentNameLetter) ? Colors.green :
                                        ['M', 'N', 'O', 'P', 'Q', 'R'].contains(commentNameLetter) ? Colors.orange :
                                        ['S', 'T', 'U', 'V', 'W', 'X'].contains(commentNameLetter) ? Colors.blue : Colors.white;
                                        return Container(
                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.all(8),
                                          decoration: myBoxDecoration(),
                                          child: ListTile(
                                            isThreeLine: true,
                                            dense: true,
                                            leading: CircleAvatar(
                                              backgroundColor: commentColor,
                                              child:
                                              Text(commentNameLetter, style: TextStyle(color: Colors.white),),
                                            ),
                                            title: Text(
                                                commentName,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold)),
                                            subtitle: Linkify(
                                              text: commentContent,
                                              onOpen: (link) async {
                                                if (await canLaunch(link.url)) {
                                                  await launch(link.url);
                                                } else {
                                                  throw 'Could not launch $link';
                                                }
                                              },
                                              maxLines: 5,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            trailing: Text(
                                              commentTime,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if(snapshot.hasError) {
                                    return Center(child: Text('Error occurred, tray again later'),);
                                  } else
                                    return Loading();
                                }),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: MediaQuery.of(context).orientation == Orientation.portrait,
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: ListTile(
                              leading: FlutterLogo(),
                              title: TextFormField(
                                controller: _textEditingController,
                                focusNode: _focusNode,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type Here'
                                )
                              ),
                              trailing: loading ? CircularProgressIndicator() : IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  if(_textEditingController.text.isNotEmpty) {
                                    setState(() {
                                      loading = true;
                                    });
                                    await Firestore.instance
                                        .collection('edu_courses')
                                        .document(widget.documentID)
                                        .collection("comments")
                                        .document()
                                        .setData({
                                      'timestamp': Timestamp.now(),
                                      'name': name,
                                      'email': email,
                                      'comment': _textEditingController.text
                                    }).then((value) {
                                      _focusNode.unfocus();
                                      setState(() {
                                        loading = false;
                                        _textEditingController.text = '';
                                        _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
                                      });
                                    });
                                  }
                                },
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
