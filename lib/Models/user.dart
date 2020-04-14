class User {
  final String uid;
  User({ this.uid });
}

class UserInfo {

  final String uid;
  final String name;
  final String password;
  final String timestamp;
  final String user_type;

  UserInfo({
    this.uid,
    this.name,
    this.password,
    this.timestamp,
    this.user_type,
  });

}

