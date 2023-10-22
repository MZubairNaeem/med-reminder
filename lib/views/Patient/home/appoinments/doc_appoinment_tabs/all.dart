import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/services/doc_appointment_controller.dart';
import 'package:medreminder/views/Patient/home/appoinments/edit_appointment.dart';
import 'package:medreminder/widgets/appointment_list_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AllAppoinments extends StatefulWidget {
  const AllAppoinments({super.key});

  @override
  State<AllAppoinments> createState() => _AllAppoinmentsState();
}

class _AllAppoinmentsState extends State<AllAppoinments> {
  final doctorName = TextEditingController();

  final hospitalName = TextEditingController();

  final note = TextEditingController();

  final visitReason = TextEditingController();

  bool load = true;
  bool val = false;
  bool select = false;
  List<String> selectedAppoinments = [];
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(appoinmentProvider);

                return userResult.when(
                  data: (appoinments) {
                    return appoinments.isEmpty
                        ? Center(
                            child: Text(
                              '-- You have no appointments yet --',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: appoinments.length,
                            itemBuilder: (context, index) {
                              DateTime time = appoinments[index]
                                  .appointmentDateTime!
                                  .toDate();
                              String formattedTime =
                                  DateFormat.jm().format(time);
                              String formattedDate =
                                  DateFormat('MMMM dd, yyyy').format(time);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AppoinmentsEdit(
                                        doctorName:
                                            appoinments[index].doctorName!,
                                        hospitalName:
                                            appoinments[index].hospitalName!,
                                        note: appoinments[index].note!,
                                        visitReason:
                                            appoinments[index].visitReason!,
                                        appointmentDateTime: appoinments[index]
                                            .appointmentDateTime!,
                                        id: appoinments[index].id!,
                                        status: appoinments[index].status!,
                                        uid: appoinments[index].uid!,
                                      ),
                                    ),
                                  );
                                  ref.refresh(appoinmentProvider);
                                  ref.refresh(missedAppoinmentProvider);
                                  ref.refresh(upcomingAppoinmentProvider);
                                  ref.refresh(completedAppoinmentProvider);
                                },
                                onLongPress: () {
                                  HapticFeedback.heavyImpact();
                                  setState(() {
                                    select = true;
                                  });
                                },
                                child: AppointmentListTile(
                                  index: index + 1,
                                  reason: appoinments[index].visitReason!,
                                  doctorName: appoinments[index].doctorName!,
                                  hospitalName:
                                      appoinments[index].hospitalName!,
                                  taskCompleted: appoinments[index].status!,
                                  time: formattedTime,
                                  date: formattedDate,
                                  note: appoinments[index].note!,
                                  checklist: //checkList,
                                      selectedAppoinments
                                              .contains(appoinments[index].id!)
                                          ? true
                                          : false,
                                  select: select,
                                  onSelect: (c) async {
                                    if (c!) {
                                      selectedAppoinments
                                          .add(appoinments[index].id!);
                                    } else {
                                      selectedAppoinments.removeWhere(
                                          (element) =>
                                              element ==
                                              appoinments[index].id!);
                                    }
                                    //empty the list
                                    setState(() {});
                                  },
                                  onChanged: (value) async {
                                    //change status of task to completed
                                    Appointments().changeStatus(
                                      context,
                                      appoinments[index].id!,
                                      appoinments[index].status! ? false : true,
                                    );
                                    ref.refresh(appoinmentProvider);
                                    ref.refresh(missedAppoinmentProvider);
                                    ref.refresh(upcomingAppoinmentProvider);
                                  ref.refresh(completedAppoinmentProvider);
                                  },
                                  deleteFunction: (context) async {
                                    await Appointments().deleteAppointments(
                                      context,
                                      appoinments[index].id!,
                                    );
                                    ref.refresh(appoinmentProvider);
                                    ref.refresh(missedAppoinmentProvider);
                                    ref.refresh(upcomingAppoinmentProvider);
                                  ref.refresh(completedAppoinmentProvider);
                                  },
                                  editFunction: (context) {},
                                ),
                              );
                            });
                  },
                  loading: () => const Text("..."),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    select = false;
                  });
                },
                child: const Icon(
                    Icons.clear), // You can change the icon as needed
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 221, 42, 30),
                onPressed: () {
                  if (selectedAppoinments.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'No Appoinment selected',
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete ${selectedAppoinments.length} appoinments?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete these appoinments?',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.watch(appoinmentProvider);
                              // ref.refresh(notesProvider);
                              return userResult.when(
                                  data: (notes) {
                                    return TextButton(
                                      onPressed: () async {
                                        await Appointments()
                                            .deleteMultipleAppoinments(
                                          context,
                                          selectedAppoinments,
                                        );
                                        setState(() {
                                          select = false;
                                        });
                                        ref.refresh(appoinmentProvider);
                                        ref.refresh(missedAppoinmentProvider);
                                        ref.refresh(upcomingAppoinmentProvider);
                                  ref.refresh(completedAppoinmentProvider);
                                        selectedAppoinments.clear();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () => const Text("..."),
                                  error: (error, stackTrace) {
                                    print('Error: $error');
                                    return Text('Error: $error');
                                  });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.delete_rounded,
                ), // You can change the icon as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
