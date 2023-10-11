import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:uuid/uuid.dart';

class Med {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String medId = const Uuid().v4();
  Future<void> addMed(BuildContext context, String medName, String medType,
      String dosageQuantity, String interval,String qty) async {
    try {
      MedModel note = MedModel(
        medName: medName,
        medType: medType,
        medCreated: Timestamp.now(),
        startTimeDate: Timestamp.now(),
        dosageQuantity: dosageQuantity,
        interval: interval,
        quantity: qty,
        status: false,
        id: medId,
        uid: uid,
      );
      await FirebaseFirestore.instance
          .collection('medSchedule')
          .doc(medId)
          .set(note.toJson());
      Get.snackbar(
        'Success',
        'Med added successfully',
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

  Future<void> deleteMed(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('medSchedule')
          .doc(id)
          .delete();
      Get.snackbar(
        'Success',
        'Med deleted successfully',
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

  Future<void> updateMed(
    BuildContext context,
    String id,
    String medName,
    String medType,
    String dosageQuantity,
    String interval,
  ) async {
    try {
      MedModel med = MedModel(
        medName: medName,
        medType: medType,
        medCreated: Timestamp.now(),
        startTimeDate: Timestamp.now(),
        dosageQuantity: dosageQuantity,
        interval: interval,
        status: false,
        id: id,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
      await FirebaseFirestore.instance
          .collection('medSchedule')
          .doc(id)
          .update(med.toJson());
      Get.snackbar(
        'Success',
        'Med updated successfully',
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
          .collection('medSchedule')
          .doc(id)
          .update({'status': status});
      Get.snackbar(
        'Success',
        'Med status changed successfully',
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
