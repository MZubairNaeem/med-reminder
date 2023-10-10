import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: secondary,
      ),
      body: const Center(
        child: Text('No reports yet'),
      ),
    );
  }
}
