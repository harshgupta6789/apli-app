import 'dart:convert';

import 'package:apli/Models/user.dart';
import 'package:apli/Services/mailer.dart';
import 'package:apli/Shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in with email and password
  Future passwordResetMail(String email) async {
    Map<String, String> data = {
      'email': email,
      'OTP': '123456',
      'time': DateTime.now().toString()
    };
    try {
      MailerService(username: apliEmailID, password: apliPassword, data: data);
    } catch (e) {
      print(e.toString());
    }
//    try {
//      await _auth.sendPasswordResetEmail(email: email);
//      return 1;
//    } catch (e) {
//      print(e.toString());
//      return -1;
//    }
  }

  Future registerOldWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null)
        return -1;
//      try {
//        await user.sendEmailVerification();
//      } catch (e) {
//        print("An error occured while trying to send email verification");
//        print(e.message);
//      }
      else
        return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null)
        return null;
//      if (user.isEmailVerified)
      else
        return _userFromFirebaseUser(user);
//      else {
//        user.sendEmailVerification();
//        _auth.signOut();
//        return -1;
//      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
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
      return result;
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
}
