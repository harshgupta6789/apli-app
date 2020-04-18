class User {
  final String uid, email;
  User({this.uid, this.email});
}

class UserInfo {
  final String uid;
  final String email;
  final String name;
  final String password;
  final String timestamp;
  final String user_type;

  UserInfo({
    this.uid,
    this.email,
    this.name,
    this.password,
    this.timestamp,
    this.user_type,
  });
}

class CandidateInfo {
  final String email;
  final String name;
  final String profilePic;
  final String phoneNo;

  CandidateInfo({
    this.email,
    this.name,
    this.profilePic,
    this.phoneNo,
  });
}
