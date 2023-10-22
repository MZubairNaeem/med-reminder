import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/med_model.dart';

final medProvider = FutureProvider<List<MedModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .where('uid', isEqualTo: uid)
      .orderBy('startTimeDate', descending: true)
      .get();

  List<MedModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MedModel(
      id: snapshot.id,
      medName: data['medName'],
      medType: data['medType'],
      medCreated: data['medCreated'],
      startTimeDate: data['startTimeDate'],
      dosageQuantity: data['dosageQuantity'],
      interval: data['interval'],
      quantity: data['quantity'],
      status: data['status'],
      uid: data['uid'],
    );
  }).toList();

  return notes;
});

final takenMedProvider = FutureProvider<List<MedModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: true)
      .get();

  List<MedModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MedModel(
      id: snapshot.id,
      medName: data['medName'],
      medType: data['medType'],
      medCreated: data['medCreated'],
      startTimeDate: data['startTimeDate'],
      dosageQuantity: data['dosageQuantity'],
      interval: data['interval'],
      quantity: data['quantity'],
      status: data['status'],
      uid: data['uid'],
    );
  }).toList();

  return notes;
});
final missedMedProvider = FutureProvider<List<MedModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: false)
      .where('startTimeDate', isLessThan: Timestamp.now())
      .get();

  List<MedModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MedModel(
      id: snapshot.id,
      medName: data['medName'],
      medType: data['medType'],
      medCreated: data['medCreated'],
      startTimeDate: data['startTimeDate'],
      dosageQuantity: data['dosageQuantity'],
      interval: data['interval'],
      quantity: data['quantity'],
      status: data['status'],
      uid: data['uid'],
    );
  }).toList();

  return notes;
});
final pendingMedProvider = FutureProvider<List<MedModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: false)
      .where('startTimeDate', isGreaterThan: Timestamp.now())
      .get();

  List<MedModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MedModel(
      id: snapshot.id,
      medName: data['medName'],
      medType: data['medType'],
      medCreated: data['medCreated'],
      startTimeDate: data['startTimeDate'],
      dosageQuantity: data['dosageQuantity'],
      interval: data['interval'],
      quantity: data['quantity'],
      status: data['status'],
      uid: data['uid'],
    );
  }).toList();

  return notes;
});

final missedSubMedProvider =
    FutureProvider.family<List<MedModel>, String?>((ref, medId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .doc(medId)
      .collection('intervals')
      .where('status', isEqualTo: false)
      .where('time', isLessThanOrEqualTo: DateTime.now())
      .get();

  List<MedModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return MedModel(
      id: snapshot.id,
      medName: data['medName'],
      medType: data['medType'],
      medCreated: data['medCreated'],
      startTimeDate: data['startTimeDate'],
      dosageQuantity: data['dosageQuantity'],
      interval: data['interval'],
      quantity: data['quantity'],
      status: data['status'],
      uid: data['uid'],
    );
  }).toList();

  return notes;
});
