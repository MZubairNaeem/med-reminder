// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/user_model.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';

class RegisterController {
  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String userType,
    String? phone,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        UserModel userModel = UserModel(
          username: username,
          email: email,
          phone: phone,
          uid: userCredential.user!.uid,
          userType: userType,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
              userModel.toJson(),
            );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EmailLogin()),
            (route) => false);
        Get.snackbar('Success', 'Account created successfully');
      } else {
        Get.snackbar('Failed', 'Account creation failed');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Failed', e.toString());
    }
  }
}
