import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/relative_model.dart';

final patientlist = FutureProvider<List<RelativeModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('relative')
      .where('relativeUid', isEqualTo: uid)
      .get();
  List<RelativeModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return RelativeModel(
      uid: data['uid'],
      relativeUid: data['relativeUid'],
      credentials: data['credentials'],
    );
  }).toList();

  return notes;
});
