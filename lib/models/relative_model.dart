import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeModel {
  String? uid;
  String? relativeUid;
  String? phone;

  RelativeModel({
    this.uid,
    this.relativeUid,
    this.phone,
  });

  RelativeModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    relativeUid = map['relativeUid'];
    phone = map['phone'];
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'relativeUid': relativeUid,
        'phone': phone,
      };
  static RelativeModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return RelativeModel(
      uid: snapshot['uid'],
      relativeUid: snapshot['relativeUid'],
      phone: snapshot['phone'],
    );
  }

  toList() {}
}
