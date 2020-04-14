import 'package:apli/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Shared/constants.dart';
import '../Shared/constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({ this.uid });

  final CollectionReference userInfoCollection = Firestore.instance.collection('users');

  Future updateUserInfo(
      String name, String password, Timestamp timestamp, String user_type
      ) async {
    return await userInfoCollection.document(uid).setData({
      'name' : name,
      'password' : password,
      'timestamp' : timestamp,
      'user_type' : user_type
    });
  }

  UserInfo _userInfoFromSnapshot(DocumentSnapshot snapshot) {
    return UserInfo(

      uid: uid,
      name: snapshot.data['name'],
      password: snapshot.data['password'],
      timestamp: snapshot.data['timestamp'],
      user_type: snapshot.data['user_type'],

    );
  }

  Stream<UserInfo> get userInfo {
    return userInfoCollection.document(uid).snapshots().map(_userInfoFromSnapshot);
  }

}
