import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeModel {
  String? uid;
  String? relativeUid;
  String? credentials;
  String? username;

  RelativeModel({
    this.uid,
    this.relativeUid,
    this.credentials,
    this.username,
  });

  RelativeModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    relativeUid = map['relativeUid'];
    credentials = map['credentials'];
    username = map['username'];
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'relativeUid': relativeUid,
        'credentials': credentials,
        'username': username,
      };
  static RelativeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return RelativeModel(
      uid: snapshot['uid'],
      relativeUid: snapshot['relativeUid'],
      credentials: snapshot['credentials'],
      username: snapshot['username'],
    );
  }

  toList() {}
}
