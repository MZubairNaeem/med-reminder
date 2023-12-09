import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? credentials;
  String? username;
  String? userType;
  String? fcm;

  UserModel({
    this.uid,
    this.userType,
    this.credentials,
    this.username,
    this.fcm,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    userType = map['userType'];
    credentials = map['credentials'];
    username = map['username'];
    fcm = map['fcm'];
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'credentials': credentials,
        'username': username,
        'fcm': fcm,
      };
      
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      userType: snapshot['userType'],
      credentials: snapshot['credentials'],
      username: snapshot['username'],
      fcm: snapshot['fcm'],
    );
  }

  toList() {}
}

