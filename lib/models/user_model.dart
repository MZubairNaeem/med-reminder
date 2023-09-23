import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? phone;
  String? userType;

  UserModel({
    this.uid,
    this.userType,
    this.phone,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    userType = map['userType'];
    phone = map['phone'];
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'phone': phone,
      };
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      userType: snapshot['userType'],
      phone: snapshot['phone'],
    );
  }

  toList() {}
}

