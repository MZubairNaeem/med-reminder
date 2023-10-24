import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
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
        title: const Text('Report'),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('medSchedule')
                                .where('uid', isEqualTo: uid)
                                .where('startTimeDate',
                                    isGreaterThanOrEqualTo:
                                        Timestamp.fromDate(medStartDate!))
                                .where('startTimeDate',
                                    isLessThan: Timestamp.fromDate(medEndDate!))
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading");
                              }
                              int dcount = 0;
                              if (snapshot.data!.docs.length != 0) {
                                int total = snapshot.data!.docs.length;
                                dcount = 0;
                                for (var doc in snapshot.data!.docs) {
                                  FirebaseFirestore.instance
                                      .collection('medSchedule')
                                      .doc(doc.id)
                                      .collection('intervals')
                                      .where('status', isEqualTo: false)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    if (querySnapshot.size == 0) {
                                      dcount++;
                                    }
                                    takenCount.add(dcount);
                                    PendingCount.add(total - dcount);
                                  });
                                }
                              }

                              return Text(
                                'Total Medicines: ${snapshot.data!.docs.length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          //Display the count as taken medicine
                          StreamBuilder<int>(
                              stream: takenCount
                                  .stream, // Use the stream from the controller
                              builder: (BuildContext context, snapshot) {
                                return Text(
                                  "Taken ${snapshot.data ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                          StreamBuilder<int>(
                              stream: PendingCount
                                  .stream, // Use the stream from the controller
                              builder: (BuildContext context, snapshot) {
                                return Text(
                                  "Pending ${snapshot.data ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              })
                          // Consumer(
                          //   builder: (context, ref, _) {
                          //     final userResult = ref.watch(medProvider);
                          //     // ref.refresh(medProvider);
                          //     return userResult.when(
                          //       data: (data) {
                          //         int count = 0;
                          //         int documentCount = 0;
                          //         for (var id in data) {
                          //           final test = FirebaseFirestore.instance
                          //               .collection('medSchedule')
                          //               .doc(id.id)
                          //               .collection('intervals')
                          //               .get();
                          //           test.then((QuerySnapshot querySnapshot) {
                          //             documentCount = querySnapshot.size;
                          //             count = count + documentCount;
                          //             print(
                          //                 "Total Document Count: $documentCount");
                          //           });
                          //         }
                          //         return Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               'Total Dosages $documentCount.',
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             const SizedBox(width: 10),
                          //             //   Consumer(
                          //             //     builder: (context, ref, _) {
                          //             //       final userResult =
                          //             //           ref.watch(medProvider);
                          //             //       // ref.refresh(medProvider);
                          //             //       return userResult.when(
                          //             //         data: (data) {
                          //             //           return Text(
                          //             //             data.toString(),
                          //             //             style: TextStyle(
                          //             //               fontSize: 20,
                          //             //               fontWeight: FontWeight.bold,
                          //             //             ),
                          //             //           );
                          //             //         },
                          //             //         loading: () => const Text("..."),
                          //             //         error: (error, stackTrace) =>
                          //             //             Text('Error: $error'),
                          //             //       );
                          //             //     },
                          //             //   ),
                          //           ],
                          //         );
                          //       },
                          //       loading: () => const Text("..."),
                          //       error: (error, stackTrace) =>
                          //           Text('Error: $error'),
                          //     );
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // Consumer(
                          //   builder: (context, ref, _) {
                          //     final userResult = ref.watch(takenMedProvider);
                          //     ref.refresh(takenMedProvider);
                          //     return userResult.when(
                          //       data: (relatives) {
                          //         return Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             const Text(
                          //               'Taken',
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             const SizedBox(width: 10),
                          //             Text(
                          //               '${relatives.length}',
                          //               style: const TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //       loading: () => const Text("..."),
                          //       error: (error, stackTrace) =>
                          //           Text('Error: $error'),
                          //     );
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // Consumer(
                          //   builder: (context, ref, _) {
                          //     final userResult = ref.watch(pendingMedProvider);
                          //     ref.refresh(pendingMedProvider);
                          //     return userResult.when(
                          //       data: (relatives) {
                          //         return Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             const Text(
                          //               'Pending',
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             const SizedBox(width: 10),
                          //             Text(
                          //               '${relatives.length}',
                          //               style: const TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //       loading: () => const Text("..."),
                          //       error: (error, stackTrace) =>
                          //           Text('Error: $error'),
                          //     );
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // Consumer(
                          //   builder: (context, ref, _) {
                          //     final userResult = ref.watch(missedMedProvider);
                          //     ref.refresh(missedMedProvider);
                          //     return userResult.when(
                          //       data: (relatives) {
                          //         return Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             const Text(
                          //               'Missed',
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             const SizedBox(width: 10),
                          //             Text(
                          //               '${relatives.length}',
                          //               style: const TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //       loading: () => const Text("..."),
                          //       error: (error, stackTrace) =>
                          //           Text('Error: $error'),
                          //     );
                          //   },
                          // ),
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
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
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
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
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
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
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
                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
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
