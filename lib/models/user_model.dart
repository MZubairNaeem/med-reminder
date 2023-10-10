import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? phone;
  String? email;
  String? username;
  String? userType;

  UserModel({
    this.uid,
    this.userType,
    this.phone,
    this.email,
    this.username,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    userType = map['userType'];
    phone = map['phone'];
    email = map['email'];
    username = map['username'];
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'phone': phone,
        'email': email,
        'username': username,
      };
      
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      userType: snapshot['userType'],
      phone: snapshot['phone'],
      email: snapshot['email'],
      username: snapshot['username'],
    );
  }

  toList() {}
}

