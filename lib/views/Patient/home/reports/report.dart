import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: secondary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.sp,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Medicine Report',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(medProvider);
                  ref.refresh(medProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Medicines',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(takenMedProvider);
                  ref.refresh(takenMedProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Taken',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(pendingMedProvider);
                  ref.refresh(pendingMedProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(missedMedProvider);
                  ref.refresh(missedMedProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Missed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              SizedBox(height: 10.h),
              Text('Doctor Appointment Report',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(appoinmentProvider);
                  ref.refresh(appoinmentProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Appointments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(upcomingAppoinmentProvider);
                  ref.refresh(upcomingAppoinmentProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Upcoming',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer(
                builder: (context, ref, _) {
                  final userResult = ref.watch(missedAppoinmentProvider);
                  ref.refresh(missedAppoinmentProvider);
                  return userResult.when(
                    data: (relatives) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Missed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${relatives.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
