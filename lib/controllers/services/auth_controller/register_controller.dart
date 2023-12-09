// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/user_model.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController {
  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String userType,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        
        UserModel userModel = UserModel(
          username: username,
          credentials: email,
          uid: userCredential.user!.uid,
          userType: userType,
          fcm: prefs.getString('fcm'),
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
        Get.snackbar(
          'Success',
          'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          'Account creation failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Failed',
        e.toString().replaceAll('FirebaseAuthException', '').trim(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
