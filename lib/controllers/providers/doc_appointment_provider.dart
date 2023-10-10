import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/doc_appointment_model.dart';

final appoinmentProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('appointments')
      .where('uid', isEqualTo: uid)
      // .orderBy('appointmentDateTime', descending: true)
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

//create a provider for upcoming appointments where scheduled date is greater than today's date
final upcomingAppoinmentProvider =
    FutureProvider<List<AppointmentModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('appointments')
      .where('uid', isEqualTo: uid)
      .orderBy('appointmentDateTime', descending: false)
      .where('appointmentDateTime', isGreaterThan: Timestamp.now())
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

//create a provider for missed appointments where scheduled date is less than today's date
final missedAppoinmentProvider =
    FutureProvider<List<AppointmentModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
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
