import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initBackgroundServices() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopSerive').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: 'Minder Alert',
          content: 'Minder is running in background',
        );
      }
      final firestore = FirebaseFirestore.instance;
      final snapshot = firestore
          .collection('appoinments')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'false')
          .where('appointmentDateTime', isEqualTo: DateTime.now());
      final data = await snapshot.get();
      if (data.docs.isNotEmpty) {
        //add into notification table
        final notification = await firestore.collection('notifications').add({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'title': 'Minder Alert',
          'content': 'You have an appointment',
          'createdDateTime': DateTime.now().add(data
              .docs.first['appointmentDateTime']
              .toDate()
              .difference(DateTime.now())),
        });
        service.setForegroundNotificationInfo(
          title: 'Minder Alert',
          content: 'You have an appointment',
        );
      }

      print('isForegroundService: ${await service.isForegroundService()}');
      service.invoke('update');
    }
  });
}

@pragma('vm:entry-point')
FutureOr<bool> onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
