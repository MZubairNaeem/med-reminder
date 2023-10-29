import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/doc_appointment_model.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:medreminder/models/relative_model.dart';

final relativelist = FutureProvider<List<RelativeModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc =
      await firestore.collection('relative').where('uid', isEqualTo: uid).get();

  List<RelativeModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return RelativeModel(
      uid: data['uid'],
      relativeUid: data['relativeUid'],
      phone: data['phone'],
    );
  }).toList();

  return notes;
});

final missedRelativeAppoinmentProvider =
    FutureProvider.family<List<AppointmentModel>,String>((ref,uid) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('appointments')
      .where('uid', isEqualTo: uid)
      .where('appointmentDateTime', isLessThan: Timestamp.now())
      .where('status', isEqualTo: false)
      .orderBy('appointmentDateTime', descending: false)
      .get();

  List<AppointmentModel> appointments = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return AppointmentModel(
      doctorName: data['doctorName'],
      hospitalName: data['hospitalName'],
      appointmentDateTime: data['appointmentDateTime'],
      visitReason: data['visitReason'],
      // prescription: data['prescription'],
      note: data['note'],
      uid: data['uid'],
      id: data['id'],
      status: data['status'],
    );
  }).toList();

  return appointments;
});

final missedRelativeMedProvider = FutureProvider.family<List<MedModel>,String>((ref,uid) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('medSchedule')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: false)
      .where('time', isLessThan: Timestamp.now())
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
      time: data['time'],
    );
  }).toList();

  return notes;
});