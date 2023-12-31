// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';

class ForgotPasswordController {
  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const EmailLogin()),
          (route) => false);
      Get.snackbar(
        'Success',
        'Password reset link sent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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
