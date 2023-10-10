// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/models/user_model.dart';
import 'package:medreminder/views/Caretaker/home/Home..dart';
import 'package:medreminder/views/Patient/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
            'Success', 'Please check your email to verify your account',
            snackPosition: SnackPosition.BOTTOM);
      } else if (user != null && user.emailVerified) {
        //check user type
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot docSnap) async {
          UserModel userModel =
              UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userType', userModel.userType!);
          prefs.setString('uid', userModel.uid!);
          if (docSnap.exists) {
            //if userType is patient
            if (userModel.userType == 'patient') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            } else if (userModel.userType == 'caretaker') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Caretaker_Home()),
                  (route) => false);
            }
          }
        });
        Get.snackbar(
          'Success',
          'Logged in successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          'Login failed',
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
