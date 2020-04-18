import 'package:apli/Models/user.dart';
import 'package:apli/Services/auth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget customDrawer(BuildContext context) {
  final AuthService _auth = AuthService();
  final user = Provider.of<User>(context);
  String name, profilePic, jobs;

  CandidateInfo _candidateInfoFromSnapshot(DocumentSnapshot snapshot) {
    return CandidateInfo(
        email: snapshot.data['email'],
        name: snapshot.data['name'],
        phoneNo: snapshot.data['ph_no'],
        profilePic: snapshot.data['profile_picture']);
  }

  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.75,
    color: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('candidates')
                  .document(user.email)
                  .snapshots()
                  .map(_candidateInfoFromSnapshot),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  name = snapshot.data.name;
                  profilePic = snapshot.data.profilePic;
                  print(name);
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          minRadius: 30,
                          maxRadius: 35,
                          backgroundImage: profilePic != null
                              ? NetworkImage(profilePic)
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                name != null ? name : 'No Name',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total Applied Jobs : 15"),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Edit Account Info"),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  );
                } else
                  return Loading();
              }),
        ),
        ListTile(
            title: Text("Notifications"),
            trailing: Switch.adaptive(
              activeTrackColor: basicColor,
              value: true,
              onChanged: null,
              activeColor: basicColor,
            ),
            onTap: () => null),
        Divider(
          thickness: 1,
        ),
        ListTile(
            title: Text("Rate Your Experience"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.netflix.mediaclient';
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
            title: Text("Refer A Friend"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url = 'https://t.me/deathmate123';
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
            title: Text("Report"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              const url =
                  'mailto:ojask2002@gmail.com?subject=Regarding Apli App';
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
            title: Text("Log Out"),
            trailing: IconButton(
                icon: Icon(EvaIcons.arrowIosForward), onPressed: null),
            onTap: () async {
              dynamic result = await _auth.signOut();
              if (result == null) {}
            }),
        Divider(
          thickness: 1,
        ),
        Padding(padding: EdgeInsets.all(20.0), child: Text(copyright))
      ],
    ),
  );
}
