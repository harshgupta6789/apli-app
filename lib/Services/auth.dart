import 'dart:convert';

import 'package:apli/Shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class AuthService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future signInWithoutAuth(String email, String password) async {
    try {
      String url = checkLogin;
      DocumentReference userIsThere =
          Firestore.instance.collection('users').document(email);
      int result;
      await userIsThere.get().then((snapshot) async {
        if (!snapshot.exists) {
          result = -10;
        } else {
          if (snapshot.data['user_type'] != 'Candidate') {
            result = -10;
          } else {
            http.Response response = await http.post(
              url,
              body: json.decode('{'
                  '"secret" : "$checkLoginSecret", '
                  '"useremail" : "$email", '
                  '"password": "$password"'
                  '}'),
            );
            if (response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if (decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["result"];
                bool isFcm = decodedData["gen_fcm"];
                if (temp == true) {
                  if (isFcm == true) {
                    _firebaseMessaging.getToken().then((token) {
                      Firestore.instance
                          .collection("users")
                          .document(email)
                          .updateData({'fcm_token': token});
                    });
                  } else if (isFcm == false) {
                    _firebaseMessaging.getToken().then((token) {
                      Firestore.instance
                          .collection("users")
                          .document(email)
                          .get()
                          .then((v) {
                        if (v.data['fcm_token'] != token) {
                          Firestore.instance
                              .collection("users")
                              .document(email)
                              .updateData({'fcm_token': token});
                        }
                      });
                    });
                  }
                  result = 1;
                } else
                  result = -1;
              } else
                result = -2;
            } else
              result = -2;
          }
        }
      });
      return result ?? -2;
    } catch (e) {
      return null;
    }
  }

  Future registerWithoutAuth(
      String fname,
      String lname,
      String email,
      String password,
      String phoneNo,
      String college,
      String course,
      String branch,
      String batch,
      String batchID) async {
    try {
      int result;
      DocumentReference emailCheck =
          Firestore.instance.collection('users').document(email);
      await emailCheck.get().then((doc) async {
        if (doc.exists) {
          result = -1;
        } else {
          try {
            await http
                .post(passHash,
                    body: json.decode('{'
                        '"secret" : "$passHashSecret", '
                        '"password": "$password"'
                        '}'))
                .then((response) async {
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.body);
                if (decodedData["secret"] == passHashSecret) {
                  String hash = decodedData["hash"];
                  Future.wait([
                    Firestore.instance
                        .collection('users')
                        .document(email)
                        .setData({
                      'name': fname + '' + lname,
                      'password': hash,
                      'timestamp': Timestamp.now(),
                      'user_type': 'Candidate'
                    }),
                    Firestore.instance
                        .collection('candidates')
                        .document(email)
                        .setData({
                      'First_name': fname,
                      'Last_name': lname,
                      'email': email,
                      'name': fname + ' ' + lname,
                      'ph_no': phoneNo,
                      'batch_id': batchID,
                    }),
                    Firestore.instance
                        .collection('rel_batch_candidates')
                        .document()
                        .setData({'batch_id': batchID, 'candidate_id': email}),
                  ]);
                  result = 1;
                } else {
                  result = -2;
                }
              } else {
                result = -2;
              }
            });
          } catch (e) {
            result = 0;
          }
        }
      });
      return result ?? -2;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {} catch (e) {}
  }

  Future updatePassword(String email, String password) async {
    int result;
    try {
      dynamic response = await passHashResponse(password);
      if (response == null) {
        result = null;
      } else if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        if (decodedData["secret"] == passHashSecret) {
          String hash = decodedData["hash"];
          await Firestore.instance
              .collection('users')
              .document(email)
              .updateData({
            'password': hash,
          });
          result = 1;
        } else {
          result = -2;
        }
      }
      return -10;
    } catch (e) {
      return null;
    }
  }

  Future passHashResponse(String password) async {
    http.Response result;
    try {
      await http
          .post(passHash,
              body: json.decode('{'
                  '"secret" : "$passHashSecret", '
                  '"password": "$password"'
                  '}'))
          .then((response) {
        result = response;
      });
      return result;
    } catch (e) {
      return null;
    }
  }
}

// NOTE: result =     1 = success
//       result =    -1 = account exists/ invalid username password
//       result =    -2 = could not connect to server
//       result =     0 = failed
//       result =   -10 = account does not exists
//       result =  null = failed
