import 'dart:convert';

import 'package:apli/Models/user.dart';
import 'package:apli/Services/database.dart';
import 'package:apli/Services/mailer.dart';
import 'package:apli/Shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in with email and password
  Future passwordResetMail(String email) async {
    Map<String, String> data = {
      'email' : email,
      'OTP' : '123456',
      'time' : DateTime.now().toString()
    };
    try {
      MailerService(username: apliEmailID, password: apliPassword, data: data);
    }
    catch(e) {
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

  Future registerOldWithEmailAndPassword(
      String email,
      String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null) return -1;
//      try {
//        await user.sendEmailVerification();
//      } catch (e) {
//        print("An error occured while trying to send email verification");
//        print(e.message);
//      }
      else return _userFromFirebaseUser(user);
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
      if(user == null) return null;
//      if (user.isEmailVerified)
      else return _userFromFirebaseUser(user);
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
      String url = "https://staging.apli.ai/accounts/checkLogin";
      DocumentReference userIsThere = Firestore.instance.collection('users').document(email);
      int result;
      await userIsThere.get().then((snapshot) async {
        if(!snapshot.exists) {
          result = null;
        } else {
          if(snapshot.data['user_type'] != 'Candidate') {
            result = null;
          } else {
            http.Response response = await http.post(
              url,
              body: json.decode('{'
                  '"secret" : "j&R\$estgIKur657%3st4", '
                  '"useremail" : "$email", '
                  '"password": "$password"'
                  '}'),);
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              print(decodedData['secret']);
              if(decodedData["secret"] == "j&R\$estgIKur657%3st4") {
                bool temp = decodedData["result"];
                if(temp == true) {
                  print("successfull");
                  result = 1;
                }
              } else result =  -1;
            } else result = -2;
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
