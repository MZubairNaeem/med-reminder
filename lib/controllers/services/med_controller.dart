import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:uuid/uuid.dart';

class Med {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addMed(
    BuildContext context,
    String medName,
    String medType,
    String dosageQuantity,
    String interval,
    String qty,
    int intervelHours,
    TimeOfDay startTimeDate,
  ) async {
    try {
      // int intervalHours =

      double totalDays = double.parse(qty) / double.parse(dosageQuantity);
      int loop;
      if (totalDays % 1 != 0) {
        // If it's not a whole number, round up to the nearest integer
        loop = totalDays.toInt() + 1;
      } else {
        // It's already a whole number
        loop = totalDays.toInt();
      }

      DateTime time = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        startTimeDate.hour,
        startTimeDate.minute,
      );
      //convert interval to hours

      // create a subcollection for each med according to the quantity
      for (int i = 0; i < loop; i++) {
        // MedModel med = MedModel(
        //   medName: medName,
        //   medType: medType,
        //   medCreated: Timestamp.now(),
        //   startTimeDate: Timestamp.fromDate(DateTime(
        //       DateTime.now().year,
        //       DateTime.now().month,
        //       DateTime.now().day,
        //       startTimeDate.hour,
        //       startTimeDate.minute)),
        //   dosageQuantity: dosageQuantity,
        //   interval: intervelHours.toString(),
        //   quantity: qty,
        //   status: false,
        //   id: medId,
        //   uid: uid,
        //   time: time.add(Duration(hours: intervelHours * i)),
        // );
        String medId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('medSchedule')
            .doc(medId)
            .set({
          'medName': medName,
          'medType': medType,
          'medCreated': Timestamp.now(),
          'startTimeDate': Timestamp.fromDate(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              startTimeDate.hour,
              startTimeDate.minute,
            ),
          ),
          'dosageQuantity': dosageQuantity,
          'interval': intervelHours.toString(),
          'quantity': qty,
          'status': false,
          'id': medId,
          'uid': uid,
          'time': time.add(Duration(hours: intervelHours * i)),
        });
        //   await FirebaseFirestore.instance
        //       .collection('medSchedule')
        //       .doc(medId)
        //       .collection('intervals')
        //       .doc(i.toString())
        //       .set(
        //     {
        //       'time': time.add(Duration(hours: intervelHours * i)),
        //       'status': false,
        //       'id': const Uuid().v4(),
        //       'uid': uid,
        //       'interval': intervelHours.toString(),
        //     },
        //   );
      }
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

  Future<void> deleteMultipleMeds(
      BuildContext context, List<String> ids) async {
    try {
      for (var id in ids) {
        await FirebaseFirestore.instance
            .collection('medSchedule')
            .doc(id)
            .delete();
      }
      Get.snackbar(
        'Success',
        'Meds deleted successfully',
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
    TimeOfDay startTimeDate,
    String dosageQuantity,
    int intervelHours,
    String qty,
    Timestamp time,
  ) async {
    try {
      MedModel med = MedModel(
        medName: medName,
        medType: medType,
        medCreated: Timestamp.now(),
        startTimeDate: Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            startTimeDate.hour,
            startTimeDate.minute,
          ),
        ),
        dosageQuantity: dosageQuantity,
        interval: intervelHours.toString(),
        quantity: qty,
        status: false,
        id: id,
        uid: uid,
        time: time,
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
  Future<void> changeStatus(BuildContext context, String id, bool status,
      String qty, String dosage) async {
    try {
      await FirebaseFirestore.instance
          .collection('medSchedule')
          .doc(id)
          .update({
        'status': status,
      });
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
