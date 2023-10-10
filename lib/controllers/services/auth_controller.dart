import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/views/Patient/auth/number_verification.dart';
import 'package:medreminder/views/Patient/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static sendCode(BuildContext context, String phoneNo) async {
    try {
      //remove recaptcha verifier
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo.toString(),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar(
            'Error',
            e.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NumberVerification(
                  verificationId: verificationId.toString(),
                  phoneNo: phoneNo.toString(),
                  token: resendToken!),
            ),
          );
          Get.snackbar(
            'Code Sent',
            'Code sent to $phoneNo',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Get.snackbar(
            'Error',
            'Time out',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
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

  static verifyCode(BuildContext context, String phoneNo, String verificationId,
      String pinController) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: pinController);
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    print(phoneAuthCredential);
    print(FirebaseAuth.instance.currentUser!.uid);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    //create user in firestore with uid
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('users').doc(uid).set({
      'uid': uid,
      'credential': phoneNo,
      'userType': 'patient',
    });
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('uid', uid);
    sharedPreferences.setString('userType', 'patient');
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));
    Get.snackbar(
      'Success',
      'Logged in successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    try {} catch (e) {
      if (context.mounted) {
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
}
