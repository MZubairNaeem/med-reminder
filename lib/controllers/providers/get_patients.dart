import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/models/relative_model.dart';
import 'package:medreminder/models/user_model.dart';

final patientlistforrelative = FutureProvider<List<UserModel>>((ref) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> doc = await firestore
      .collection('relative')
      .where('relativeUid', isEqualTo: uid)
      .get();
  List<UserModel> userList = [];

  // Create a list of Futures for the user queries
  final userFutures = doc.docs.map((element) async {
    final users = await firestore
        .collection('users')
        .where('uid', isEqualTo: element['uid'])
        .get();
    return users.docs.map((snapshot) {
      Map<String, dynamic> data = snapshot.data();
      return UserModel(
        uid: data['uid'],
        username: data['username'],
        userType: data['userType'],
        credentials: data['credentials'],
      );
    }).toList();
  });

  // Wait for all the user queries to complete
  final userLists = await Future.wait(userFutures);

  // Flatten the list of user lists into a single userList
  userList = userLists.expand((userList) => userList).toList();

  return userList;
});
