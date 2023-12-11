import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medreminder/views/Caretaker/auth/OTP.dart';
import 'package:medreminder/views/Caretaker/home/Home..dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_ {
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
              builder: (context) => OTPVerification(
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
          'Error',
          e.toString(),
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
    //check if user exists
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('users').doc(uid).get();
    print(doc.exists);
    if (doc.exists) {
      print('user exists');
      Map<String, dynamic> data = doc.data()!;
      //user exists
      //get user data
      //save user data in shared preferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', uid);
      sharedPreferences.setString('userType', 'caretaker');
      // ignore: use_build_context_synchronously
      Get.offAll(() => const Caretaker_Home());
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      //user does not exist
      //create user
      firestore.collection('users').doc(uid).set({
        'uid': uid,
        'credentials': phoneNo,
        'userType': 'caretaker',
        'username': '@username',
      });
      //save user data in shared preferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', uid);
      sharedPreferences.setString('userType', 'caretaker');
      // ignore: use_build_context_synchronously
      Get.offAll(() => const Caretaker_Home());
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('uid', uid);
    sharedPreferences.setString('userType', 'caretaker');
    // ignore: use_build_context_synchronously
    Get.offAll(() => const Caretaker_Home());
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
          'Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
