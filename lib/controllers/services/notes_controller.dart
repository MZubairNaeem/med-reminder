import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class Notes {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String noteId = const Uuid().v4();
  Future<void> addNote(
      BuildContext context, String title, String description) async {
    try {
      NotesModel note = NotesModel(
        title: title,
        description: description,
        timestamp: Timestamp.now(),
        uid: uid,
        id: noteId,
        status: false,
      );
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(noteId)
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

  Future<void> deleteNote(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(id).delete();
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

  Future<void> updateNote(
      BuildContext context, String id, String title, String description) async {
    try {
      NotesModel note = NotesModel(
        title: title,
        description: description,
        timestamp: Timestamp.now(),
        uid: uid,
      );
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(id)
          .update(note.toJson());
      Get.snackbar(
        'Success',
        'Note updated successfully',
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
          .collection('notes')
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
