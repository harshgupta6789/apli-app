import 'package:apli/Screens/HomeLoginWrapper.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Widget customDrawer(BuildContext context) {
  Future<List<String>> userInit() async {
    String email;
    List<String> userData = [];
    SharedPreferences prefs;

    await SharedPreferences.getInstance().then((value) => prefs = value);

    email = prefs.getString('email');
    userData.add(email);

    await Firestore.instance
        .collection('candidates')
        .document(email)
        .get()
        .then((snapshot) {
      userData.add(snapshot.data['name']);
      userData.add(snapshot.data['ph_no'].toString());
      userData.add((snapshot.data['profile_picture']));
      userData.add((snapshot.data['Last_name']));
    });

    return userData;
  }

  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
    height: MediaQuery.of(context).size.height * 0.7,
    color: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: userInit(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CircleAvatar(
                          minRadius: 30,
                          maxRadius: 35,
                          backgroundImage: snapshot.data[3] != null
                              ? NetworkImage(snapshot.data[3])
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: AutoSizeText(
                                  snapshot.data[1] != null &&
                                          snapshot.data[4] != null
                                      ? snapshot.data[1]
                                              .split(' ')[0][0]
                                              .toUpperCase() +
                                          snapshot.data[1]
                                              .split(' ')[0]
                                              .substring(1) +
                                          " " +
                                          snapshot.data[4]
                                      : 'No Name',
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text('Error, please try again later'),
                  );
                } else {
                  return Loading();
                }
              }),
        ),
        ListTile(
            dense: true,
            title: Text("Notifications"),
            onTap: () {
              AppSettings.openAppSettings();
            }),
        Divider(
          thickness: 1,
        ),
        ListTile(
            dense: true,
            title: Text("Rate Your Experience"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.example.apliauth';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }),
        Divider(
          thickness: 1,
        ),
        ListTile(
            dense: true,
            title: Text("Refer A Friend"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.example.apliauth';
              Share.share(url);
            }),
        Divider(
          thickness: 1,
        ),
        ListTile(
            dense: true,
            title: Text("Report"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url = 'mailto:info@apli.ai?subject=Regarding Apli App';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }),
        Divider(
          thickness: 1,
        ),
        ListTile(
            dense: true,
            title: Text("Log Out"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (Route<dynamic> route) => false);
            }),
        Divider(
          thickness: 1,
        ),
        Padding(padding: EdgeInsets.all(10.0), child: Text(copyright))
      ],
    ),
  );
}
