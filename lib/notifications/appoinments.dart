// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> scheduleNotificationsFromFirestore() async {
//   // Query Firestore to get tasks with reminder times.
//   QuerySnapshot snapshot =  FirebaseFirestore.instance.collection('tasks').get();

//   for (QueryDocumentSnapshot document in snapshot.docs) {
//     // Extract reminder time from Firestore data (adjust field name as needed).
//     Timestamp timestamp = document.data()?['reminderTime'];
//     DateTime reminderTime = timestamp.toDate();

//     // Schedule notifications using reminderTime.
//      scheduleNotification(reminderTime);
//   }
// }

// Future<void> scheduleNotification(DateTime reminderTime) async {
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: false,
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );

//    flutterLocalNotificationsPlugin.schedule(
//     0,
//     'Reminder Title',
//     'Reminder Body',
//     reminderTime,
//     platformChannelSpecifics,
//     payload: 'custom_data',
//   );
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('logo');
  void initializeNotifications() {
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, String body) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    print("NOTIFICATION DETAILS$androidNotificationDetails");
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    flutterLocalNotificationsPlugin.show(
      88,
      title,
      body,
      notificationDetails,
    );
  }

  void scheduleNotification(String title, String body) {
    try {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      flutterLocalNotificationsPlugin.periodicallyShow(
        2,
        title,
        body,
        RepeatInterval.everyMinute,
        notificationDetails,
        androidAllowWhileIdle: true,
        payload: 'custom_data',
      );
    } catch (e) {
      print("ERROR$e");
      Get.snackbar(
        'ERROR',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.errorColor,
      );
    }
  }
}
