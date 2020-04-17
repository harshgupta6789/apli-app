import 'package:apli/Models/user.dart';
import 'package:apli/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(
            (FirebaseUser user) => _userFromFirebaseUser(user)
    );
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user.isEmailVerified)
        return _userFromFirebaseUser(user);
      else {
        user.sendEmailVerification();
        _auth.signOut();
        return -1;
      }
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, AuthCredential credential, String name, String phone, Timestamp timestamp) async {
    try{

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user == null) return -1;
      user.linkWithCredential(credential);
      try {
        await user.sendEmailVerification();
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }
      Future.wait([
        DatabaseService(uid: user.uid).updateUserInfo(
            name, password, timestamp, 'Candidate'
        ),
      ]);
      _auth.signOut();
      return 1;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Logout
  Future signOut() async {
    try {
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future passwordReset(String email) async {
    try {
       await _auth.sendPasswordResetEmail(email: email);
       return 1;
    }catch(e){
      print(e.toString());
      return -1;
    }
  }

}