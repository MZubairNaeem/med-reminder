import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';

class HomeNotification extends StatefulWidget {
  const HomeNotification({super.key});

  @override
  State<HomeNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<HomeNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: secondary,
      ),
      body: const Center(
        child: Text('Notification'),
      ),
    );
  }
}
