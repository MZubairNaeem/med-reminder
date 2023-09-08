import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/services/doc_appointment_controller.dart';
import 'package:medreminder/views/home/appoinments/doc_appointments_add.dart';
import 'package:medreminder/widgets/appointment_list_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AppoinmentsList extends StatefulWidget {
  const AppoinmentsList({super.key});

  @override
  State<AppoinmentsList> createState() => _AppoinmentsListState();
}

class _AppoinmentsListState extends State<AppoinmentsList> {
  final doctorName = TextEditingController();

  final hospitalName = TextEditingController();

  final note = TextEditingController();

  final visitReason = TextEditingController();

  bool load = true;
  bool val = false;

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
      appBar: AppBar(
        title: const Text('Doctor Appointments'),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !load,
            child: Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(appoinmentProvider);
                // ref.refresh(appoinmentProvider);
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
                              return AppointmentListTile(
                                index: index + 1,
                                reason: appoinments[index].visitReason!,
                                doctorName: appoinments[index].doctorName!,
                                hospitalName: appoinments[index].hospitalName!,
                                taskCompleted: appoinments[index].status!,
                                time: formattedTime,
                                date: formattedDate,
                                note: appoinments[index].note!,
                                onChanged: (value) {
                                  //change status of task to completed
                                  Appointments().changeStatus(
                                    context,
                                    appoinments[index].id!,
                                    appoinments[index].status! ? false : true,
                                  );
                                },
                                deleteFunction: (context) {
                                  Appointments().deleteAppointments(
                                    context,
                                    appoinments[index].id!,
                                  );
                                },
                              );
                            });
                  },
                  loading: () => const Text("..."),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            ),
          ),
          Visibility(
            visible: load,
            child: const Center(
              child: CircularProgressIndicator(
                color: tertiary,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !load,
        child: FloatingActionButton.extended(
          backgroundColor: secondary,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppoinmentsAdd()));
          },
          label: const Text('Schedule Appoinment'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
