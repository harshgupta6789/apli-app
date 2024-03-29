import 'dart:convert';

import 'package:apli/Shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future signInWithoutAuth(String email, String password) async {
    //THIS IS THE METHOD WHERE ME MAKE A CALL TO THE LOGIN API BY A POST METHOD AS U CAN SEE BELOW //
    // WE ALSO FETCH THE USERS'S COURSE WHICH IS USED AS A TOPIC NAME FOR FIREBASE PUSH NOTIFICATIONS //
    // WE SEPARATE CASES LIKE NETWORK LOST , PASSWORD INCORRECT ETC BY RETURNING RESULT BACK AS -1 , -2 , 0  IF UNSUCCESSFULL//
    // THE LOGIN API ALSO RETURNS A BOOLEAN CALLED gen_fcm AS U CAN SEE BELOW...THE FCM TOKEN IF NOT PRESENT IS THEN  STORED IN USERS COLLECTION //

    try {
      //email = email.toLowerCase();
      String url = checkLogin;
      DocumentReference userIsThere =
          Firestore.instance.collection('users').document(email);
      int result;
      await SharedPreferences.getInstance().then((prefs) async {
        await userIsThere.get().then((snapshot) async {
          if (!snapshot.exists) {
            result = -10;
          } else {
            if (snapshot.data['user_type'] != 'Candidate') {
              result = -100;
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
                    String batchId;
                    String course;
                    await Firestore.instance
                        .collection('candidates')
                        .document(email)
                        .get()
                        .then((s) {
                      batchId = s.data['batch_id'];
                      if (batchId != null) {
                        var details = Firestore.instance
                            .collection('batches')
                            .where('batch_id', isEqualTo: batchId)
                            .limit(1);
                        details.getDocuments().then((data) {
                          course = data.documents[0].data['course'];

                          course = course.replaceAll(" ", "_");
                          prefs.setString("course", course);
                          _firebaseMessaging
                              .subscribeToTopic(course)
                              .then((value) {
                            print("f0");
                          });
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
                        });
                        result = 1;
                      } else {
                        result = -1;
                      }
                    });
                  } else
                    result = -1;
                } else
                  result = -2;
              } else
                result = -2;
            }
          }
        });
      });
      return result ?? -2;
    } catch (e) {
      return null;
    }
  }

  Future registerWithoutAuth(

      //THIS IS THE METHOD WHERE WE USE SIMPLE FIREBASSE READ AND WRITE TO CREATE A NEW USER.... AS U CAN SEE BELOW //

      String fname,
      String lname,
      String email,
      String password,
      String phoneNo,
      String college,
      String year,
      String course,
      String branch,
      String batch,
      String batchID) async {
    Timestamp t = Timestamp.now();
    try {
      email = email.toLowerCase();
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
                      'timestamp': t,
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
                      'timestamp': t,
                      'profile_status': 0
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
    //THIS IS THE METHOD WHERE WE AGAIN USE FIREBASE FIRESTORE TO UPDATE THE CURRENT PASSWORD
    // (TRIGGERED WHEN USER FORGETS HIS PASSWORD AND HE HAS VERIFIED HIS OTP IN FORGOT PASSWORD SCREEN) //
    int result;
    //email = email.toLowerCase();
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
      return result;
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
