import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medreminder/views/Caretaker/home/Home..dart';
import 'package:medreminder/views/Patient/home/home.dart';
import 'package:medreminder/views/onBoarding/onBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uuid;
  String? userType;
  Future getValidationKey() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString('uid');
    var type = sharedPreferences.getString('userType');
    setState(() {
      print(uid);
      print(type);
      uuid = uid;
      userType = type;
    });
  }

  @override
  void initState() {
    getValidationKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => uuid == null
              ? const OBScreen1()
              : (userType == 'patient' ? const Home() : const Caretaker_Home()),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('lib/constants/assets/logo.png'),
        ));
  }
}
