import 'package:apli/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final String email;

  DatabaseService({ this.uid, this.email });

  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Future updateUserInfo(
      String name, String password, Timestamp timestamp, String user_type
      ) async {
    return await usersCollection.document(email).setData({
      'name' : name,
      'password' : password,
      'timestamp' : timestamp,
      'user_type' : user_type
    });
  }

  UserInfo _usersFromSnapshot(DocumentSnapshot snapshot) {
    return UserInfo(

      uid: uid,
      email: snapshot.documentID,
      name: snapshot.data['name'],
      password: snapshot.data['password'],
      timestamp: snapshot.data['timestamp'],
      user_type: snapshot.data['user_type'],

    );
  }

  Stream<UserInfo> get userInfo {
    return usersCollection.document(email).snapshots().map(_usersFromSnapshot);
  }

}
