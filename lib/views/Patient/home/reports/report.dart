import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
    // start = DateTime.now().subtract(const Duration(days: 7));
    // sevenDays = DateTime.now().add(const Duration(days: 7));
    uid = FirebaseAuth.instance.currentUser?.uid;
    super.initState();
  }

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  DateTime? medStartDate = DateTime.now();
  DateTime? medEndDate = DateTime.now();
  String? uid;
  bool load = true;
  bool report1 = false;
  bool report2 = false;
  bool med1 = false;
  bool med2 = false;
  StreamController<int> takenCount = StreamController<int>.broadcast();
  StreamController<int> PendingCount = StreamController<int>.broadcast();

  //dispose the controller
  @override
  void dispose() {
    takenCount.close();
    PendingCount.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report', style: TextStyle(color: white)),
        backgroundColor: secondary,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !load,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.sp,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Medicine Report',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _medSelectStartDate(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                    fontSize: 16.sp),
                              ),
                              const Icon(Icons.calendar_month_outlined)
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            _medSelectEndDate(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                    fontSize: 16.sp),
                              ),
                              const Icon(Icons.calendar_month_outlined)
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: med1 && med2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Meds',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('medSchedule')
                                    .where('uid', isEqualTo: uid)
                                    .where('time',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(medStartDate!))
                                    .where('time',
                                        isLessThan:
                                            Timestamp.fromDate(medEndDate!))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Taken',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('medSchedule')
                                    .where('uid', isEqualTo: uid)
                                    .where('time',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(medStartDate!))
                                    .where('time',
                                        isLessThan:
                                            Timestamp.fromDate(medEndDate!))
                                    .where('status', isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('medSchedule')
                                    .where('uid', isEqualTo: uid)
                                    .where('status', isEqualTo: false)
                                    .where('time',
                                        isGreaterThanOrEqualTo: Timestamp.now())
                                    .where('time',
                                        isLessThan:
                                            Timestamp.fromDate(medEndDate!))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Missed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('medSchedule')
                                    .where('uid', isEqualTo: uid)
                                    .where('status', isEqualTo: false)
                                    .where('time',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(medStartDate!))
                                    .where('time', isLessThan: Timestamp.now())
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Doctor Appointment Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _selectStartDate(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                    fontSize: 16.sp),
                              ),
                              const Icon(Icons.calendar_month_outlined)
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            _selectEndDate(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                    fontSize: 16.sp),
                              ),
                              const Icon(Icons.calendar_month_outlined)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: report1 && report2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Appointments',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('appointments')
                                    .where('uid', isEqualTo: uid)
                                    .where('appointmentDateTime',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(startDate!))
                                    .where('appointmentDateTime',
                                        isLessThan:
                                            Timestamp.fromDate(endDate!))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Attended',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('appointments')
                                    .where('uid', isEqualTo: uid)
                                    .where('appointmentDateTime',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(startDate!))
                                    .where('appointmentDateTime',
                                        isLessThan:
                                            Timestamp.fromDate(endDate!))
                                    .where('status', isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Upcoming',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('appointments')
                                    .where('uid', isEqualTo: uid)
                                    .where('status', isEqualTo: false)
                                    .where('appointmentDateTime',
                                        isGreaterThanOrEqualTo: Timestamp.now())
                                    .where('appointmentDateTime',
                                        isLessThan:
                                            Timestamp.fromDate(endDate!))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Missed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 1.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('appointments')
                                    .where('uid', isEqualTo: uid)
                                    .where('status', isEqualTo: false)
                                    .where('appointmentDateTime',
                                        isGreaterThanOrEqualTo:
                                            Timestamp.fromDate(startDate!))
                                    .where('appointmentDateTime',
                                        isLessThan: Timestamp.now())
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Show a progress indicator while data is loading
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Data has been loaded successfully, display the count
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: load,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? selectedDate;
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now(), // Initial date or current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        startDate = picked;
        report1 = true;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now(), // Initial date or current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        endDate = picked;
        report2 = true;
      });
    }
  }

  Future<void> _medSelectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now(), // Initial date or current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        medStartDate = picked;
        med1 = true;
      });
    }
  }

  Future<void> _medSelectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now(), // Initial date or current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        medEndDate = picked;
        med2 = true;
      });
    }
  }
}
