import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseLive extends StatefulWidget {
  final String link, documentID, hashtag;
  CourseLive({this.link, this.documentID, this.hashtag});
  @override
  _CourseLiveState createState() => _CourseLiveState();
}

class _CourseLiveState extends State<CourseLive>
    with SingleTickerProviderStateMixin {

   // THIS SCREEN USES YOUTUBE VIDEO PLAYER PACKAGE TO PLAY LIVE VIDEOS //
   // THIS SCREEN ALSO HAS LIVE CHAT IMPLEMENTED WITH THE HELP OF FIREBASE COLLECTION AND STREAMBUILDERS //

  YoutubePlayerController _controller;
  bool isEmoji = false, isFocus = false;
  AnimationController _animationController;
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 0);
  bool visible = true,
      tapped = false,
      go = false,
      loading = false,
      playing = true;
  TextEditingController _textEditingController =
      new TextEditingController(text: '');
  FocusNode _focusNode = new FocusNode();
  String name, email, profilePicture;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  Widget emojiKeyboard() {
    return EmojiPicker(
      bgColor: Theme.of(context).backgroundColor,
      indicatorColor: Theme.of(context).backgroundColor,
      rows: 4,
      columns: 9,
      onEmojiSelected: (emoji, category) {
        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
    );
  }

  getInfo() async {
    await SharedPreferences.getInstance().then((prefs) async {
      await Firestore.instance
          .collection('candidates')
          .document(prefs.getString('email'))
          .get()
          .then((value) {
        setState(() {
          email = prefs.getString('email');
          name = (value.data['First_name'] ?? '') +
              ' ' +
              (value.data['Last_name'] ?? '');
          profilePicture = (value.data['profile_picture'] == null ||
                  value.data['profile_picture'] == defaultPic)
              ? null
              : value.data['profile_picture'];
        });
      });
    });
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) if (mounted)
        setState(() {
          isEmoji = false;
        });
    });
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
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return name == null
        ? Loading()
        : SafeArea(
            child: WillPopScope(
              onWillPop: () {
                if (MediaQuery.of(context).orientation == Orientation.landscape)
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                else {
                  if (isEmoji) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                    setState(() {
                      isEmoji = false;
                      isFocus = false;
                    });
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                    Navigator.pop(context);
                  }
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
                            Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? MediaQuery.of(context).size.height - 27
                                  : 250,
                              child: YoutubePlayer(
                                controller: _controller,
                              ),
                            ),
                            Visibility(
                              visible: MediaQuery.of(context).orientation ==
                                  Orientation.portrait,
                              child: Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.white),
                                      ]),
                                  child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('edu_courses')
                                          .document(widget.documentID)
                                          .collection("comments")
                                          .orderBy("timestamp",
                                              descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if ((snapshot.data.documents ?? [])
                                                  .length ==
                                              0) {
                                            return Center(
                                              child: Text(
                                                  'Be the first one to write a comment'),
                                            );
                                          } else
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              reverse: true,
                                              controller: _scrollController,
                                              itemCount:
                                                  (snapshot.data.documents ??
                                                          [])
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var comments = snapshot.data
                                                        .documents[index] ??
                                                    {};
                                                String commentName =
                                                    comments['name'] ??
                                                        'Anonymous';
                                                String commentNameLetter =
                                                    (commentName.substring(
                                                            0, 1))
                                                        .toUpperCase();
                                                String commentProfilePicture =
                                                    comments['profile_picture'];
                                                String commentContent =
                                                    comments['comment'] ?? '';
                                                List<String>
                                                    commentContentDivided =
                                                    commentContent.split(" ");
                                                List<Widget> temp =
                                                    commentContentDivided
                                                        .map((e) {
                                                  if (e.toLowerCase() ==
                                                      ((widget.hashtag == null)
                                                          ? '#askaquestion'
                                                          : widget.hashtag
                                                              .toLowerCase()))
                                                    return Linkify(
                                                      text: e + ' ',
                                                      onOpen: (link) async {
                                                        if (await canLaunch(
                                                            link.url)) {
                                                          await launch(
                                                              link.url);
                                                        } else {
                                                          throw 'Could not launch $link';
                                                        }
                                                      },
                                                      style: TextStyle(
                                                          wordSpacing: 0,
                                                          color: basicColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    );
                                                  else
                                                    return Linkify(
                                                      text: e + ' ',
                                                      onOpen: (link) async {
                                                        if (await canLaunch(
                                                            link.url)) {
                                                          await launch(
                                                              link.url);
                                                        } else {
                                                          throw 'Could not launch $link';
                                                        }
                                                      },
                                                      style: TextStyle(
                                                          wordSpacing: 0,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    );
                                                }).toList();
                                                String commentTime =
                                                    timestampToReadableTimeConverter(
                                                        comments['timestamp'] ??
                                                            Timestamp.now());
                                                Color commentColor = [
                                                  'A',
                                                  'J',
                                                  'P',
                                                  'D',
                                                  'E',
                                                  'F'
                                                ].contains(commentNameLetter)
                                                    ? Colors.redAccent
                                                    : [
                                                        'G',
                                                        'H',
                                                        'I',
                                                        'B',
                                                        'K',
                                                        'L'
                                                      ].contains(
                                                            commentNameLetter)
                                                        ? Colors.green
                                                        : [
                                                            'M',
                                                            'N',
                                                            'O',
                                                            'C',
                                                            'Q',
                                                            'R'
                                                          ].contains(
                                                                commentNameLetter)
                                                            ? Colors.orange
                                                            : [
                                                                'S',
                                                                'T',
                                                                'U',
                                                                'V',
                                                                'W',
                                                                'X'
                                                              ].contains(
                                                                    commentNameLetter)
                                                                ? Colors.blue
                                                                : Colors
                                                                    .deepPurpleAccent;
                                                return Container(
                                                  padding: EdgeInsets.all(0),
                                                  margin: EdgeInsets.fromLTRB(
                                                      8, 3, 8, 3),
                                                  decoration: myBoxDecoration(),
                                                  child: ListTile(
                                                    isThreeLine: true,
                                                    dense: true,
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          commentColor,
                                                      backgroundImage:
                                                          commentProfilePicture ==
                                                                  null
                                                              ? null
                                                              : NetworkImage(
                                                                  commentProfilePicture),
                                                      child: Text(
                                                        commentNameLetter,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(commentName,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    subtitle: Wrap(
                                                      children: temp,
                                                    ),
                                                    trailing: Text(
                                                      commentTime,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error occurred, tray again later'),
                                          );
                                        } else
                                          return Loading();
                                      }),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: MediaQuery.of(context).orientation ==
                                    Orientation.portrait,
                                child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: ListTile(
                                        leading: IconButton(
                                            icon: Icon(
                                              isEmoji
                                                  ? Icons.keyboard
                                                  : Icons.tag_faces,
//                                              color: isEmoji
//                                                  ? basicColor
//                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              if (_focusNode.hasFocus) {
                                                _focusNode.unfocus();
                                                setState(() {
                                                  isEmoji = true;
                                                  isFocus = false;
                                                });
                                              } else {
                                                if (isEmoji == true) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_focusNode);
                                                  setState(() {
                                                    isEmoji = false;
                                                    isFocus = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isEmoji = true;
                                                    isFocus = false;
                                                  });
                                                }
                                              }
                                            }),
                                        title: TextFormField(
                                            onFieldSubmitted: (value) async {
                                              if (_textEditingController
                                                  .text.isNotEmpty) {
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
                                                  'comment':
                                                      _textEditingController
                                                          .text,
                                                  'profile_picture':
                                                      profilePicture
                                                }).then((value) {
                                                  _focusNode.unfocus();
                                                  setState(() {
                                                    loading = false;
                                                    isEmoji = false;
                                                    isFocus = false;
                                                    _textEditingController
                                                        .text = '';
                                                    _scrollController.animateTo(
                                                        _scrollController
                                                            .position
                                                            .minScrollExtent,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        curve: Curves.easeOut);
                                                  });
                                                });
                                              }
                                            },
                                            controller: _textEditingController,
                                            focusNode: _focusNode,
                                            textInputAction:
                                                TextInputAction.send,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Use ' +
                                                    (widget.hashtag ??
                                                        '#AskAQuestion'))),
                                        trailing: loading
                                            ? CircularProgressIndicator()
                                            : IconButton(
                                                icon: Icon(Icons.send),
                                                onPressed: () async {
                                                  if (_textEditingController
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    await Firestore.instance
                                                        .collection(
                                                            'edu_courses')
                                                        .document(
                                                            widget.documentID)
                                                        .collection("comments")
                                                        .document()
                                                        .setData({
                                                      'timestamp':
                                                          Timestamp.now(),
                                                      'name': name,
                                                      'email': email,
                                                      'comment':
                                                          _textEditingController
                                                              .text,
                                                      'profile_picture':
                                                          profilePicture
                                                    }).then((value) {
                                                      _focusNode.unfocus();
                                                      setState(() {
                                                        loading = false;
                                                        isEmoji = false;
                                                        isFocus = false;
                                                        _textEditingController
                                                            .text = '';
                                                        _scrollController.animateTo(
                                                            _scrollController
                                                                .position
                                                                .minScrollExtent,
                                                            duration: Duration(
                                                                seconds: 1),
                                                            curve:
                                                                Curves.easeOut);
                                                      });
                                                    });
                                                  }
                                                })))),
                            (isEmoji && !isFocus) ? emojiKeyboard() : SizedBox()
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
