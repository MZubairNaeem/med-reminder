import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/notes_model.dart';

final notesProvider = FutureProvider<List<NotesModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('notes')
      .where('uid', isEqualTo: uid)
      .orderBy('timestamp', descending: true)
      .get();

  List<NotesModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return NotesModel(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      timestamp: data['timestamp'],
      uid: data['uid'],
      status: data['status'],
    );
  }).toList();

  return notes;
});

final completedNotesProvider = FutureProvider<List<NotesModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('notes')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: true)
      .get();

  List<NotesModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return NotesModel(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      timestamp: data['timestamp'],
      uid: data['uid'],
      status: data['status'],
    );
  }).toList();

  return notes;
});
final pendingNotesProvider = FutureProvider<List<NotesModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('notes')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: false)
      .get();

  List<NotesModel> notes = doc.docs.map((snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return NotesModel(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      timestamp: data['timestamp'],
      uid: data['uid'],
      status: data['status'],
    );
  }).toList();

  return notes;
});
