import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:uuid/uuid.dart';

class Med {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String medId = const Uuid().v4();
  Future<void> addMed(
      BuildContext context, String medName, String medType, String dosageQuantity, String interval) async {
    try {
      MedModel note = MedModel(
        medName: medName,
        medType: medType,
        medCreated: Timestamp.now(),
        startTimeDate: Timestamp.now(),
        dosageQuantity: dosageQuantity,
        interval: interval,
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
        'Note added successfully',
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
      await FirebaseFirestore.instance.collection('medSchedule').doc(id).delete();
      Get.snackbar(
        'Success',
        'Note deleted successfully',
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

  // Future<void> updateNote(
  //     BuildContext context, String id, String title, String description) async {
  //   try {
  //     NotesModel note = NotesModel(
  //       title: title,
  //       description: description,
  //       timestamp: Timestamp.now(),
  //       uid: uid,
  //     );
  //     await FirebaseFirestore.instance
  //         .collection('notes')
  //         .doc(id)
  //         .update(note.toJson());
  //     Get.snackbar(
  //       'Success',
  //       'Note updated successfully',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } on FirebaseException catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       e.message.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

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
        'Task status changed successfully',
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