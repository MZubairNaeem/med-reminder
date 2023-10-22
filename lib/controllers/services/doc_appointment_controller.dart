import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/doc_appointment_model.dart';
import 'package:uuid/uuid.dart';

class Appointments {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String appointmentsId = const Uuid().v4();
  Future<void> addAppointments(
      BuildContext context,
      String? doctorName,
      String? hospitalName,
      Timestamp? appoinmentDateTime,
      String? note,
      String? visitReason) async {
    try {
      AppointmentModel appointmentModel = AppointmentModel(
        doctorName: doctorName,
        hospitalName: hospitalName,
        appointmentDateTime: appoinmentDateTime,
        note: note,
        visitReason: visitReason,
        uid: uid,
        id: appointmentsId,
        status: false,
      );
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentsId)
          .set(appointmentModel.toJson());
      Get.snackbar(
        'Success',
        'Appointment added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteAppointments(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .delete();
      Get.snackbar(
        'Success',
        'Appointment deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateAppointments(
    BuildContext context,
    String id,
    String? doctorName,
    String? hospitalName,
    Timestamp? appoinmentDateTime,
    String? note,
    String? visitReason,
    bool? status,
  ) async {
    try {
      AppointmentModel appointmentModel = AppointmentModel(
        doctorName: doctorName,
        hospitalName: hospitalName,
        appointmentDateTime: appoinmentDateTime,
        note: note,
        visitReason: visitReason,
        uid: uid,
        id: id,
        status: status,
      );
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .update(appointmentModel.toJson());
      Get.snackbar(
        'Success',
        'Appoinment updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //change status of task to completed
  Future<void> changeStatus(
      BuildContext context, String id, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .update({'status': status});
      Get.snackbar(
        'Success',
        'Appointment status changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> deleteMultipleAppoinments(
      BuildContext context, List<String> ids) async {
    try {
      for (var id in ids) {
        await FirebaseFirestore.instance.collection('appointments').doc(id).delete();
      }
      Get.snackbar(
        'Success',
        'Appoinments deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
