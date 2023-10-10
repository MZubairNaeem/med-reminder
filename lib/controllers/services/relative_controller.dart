import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/relative_model.dart';

class Relative {
  addRelative(BuildContext context, String credentials, String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('relative')
          .where('credentials', isEqualTo: credentials)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Error',
          'Relative Already Added',
          backgroundColor: Colors.amber,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      RelativeModel relativeModel = RelativeModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        phone: credentials,
        relativeUid: uid,
      );
      await FirebaseFirestore.instance
          .collection('relative')
          .add(relativeModel.toJson());
      Get.snackbar(
        'Success',
        'Relative Added Successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    //check if the user is already added
  }

  //delete relative
  deleteRelative(BuildContext context, String credentials) async {
    try {
      //remove the relative from the list
      await FirebaseFirestore.instance
          .collection('relative')
          .where('credentials', isEqualTo: credentials)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
      });
      Get.snackbar(
        'Success',
        'Removed Successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    //check if the user is already added
  }
}
