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
                  print("successfull");
                  if (isFcm == true) {
                    _firebaseMessaging.getToken().then((token) {
                      print(token);
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

  Future signOut() async {
    try {

    } catch (e) {
      print(e.toString());
    }
  }
}
