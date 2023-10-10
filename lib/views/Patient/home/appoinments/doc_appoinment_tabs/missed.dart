import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/services/doc_appointment_controller.dart';
import 'package:medreminder/views/Patient/home/appoinments/edit_appointment.dart';
import 'package:medreminder/widgets/appointment_list_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class MissedAppoinments extends StatefulWidget {
  const MissedAppoinments({super.key});

  @override
  State<MissedAppoinments> createState() => _MissedAppoinmentsState();
}

class _MissedAppoinmentsState extends State<MissedAppoinments> {
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              right: 4.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '<== Swipe left for more options',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(missedAppoinmentProvider);

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
                                hospitalName:
                                    appoinments[index].hospitalName!,
                                taskCompleted: appoinments[index].status!,
                                time: formattedTime,
                                date: formattedDate,
                                note: appoinments[index].note!,
                                onChanged: (value) async {
                                  //change status of task to completed
                                  await Appointments().changeStatus(
                                    context,
                                    appoinments[index].id!,
                                    appoinments[index].status! ? false : true,
                                  );
                                   ref.refresh(appoinmentProvider);
                                  ref.refresh(missedAppoinmentProvider);
                                  ref.refresh(upcomingAppoinmentProvider);
                                },
                                deleteFunction: (context) async {
                                  await Appointments().deleteAppointments(
                                    context,
                                    appoinments[index].id!,
                                  );
                                   ref.refresh(appoinmentProvider);
                                  ref.refresh(missedAppoinmentProvider);
                                  ref.refresh(upcomingAppoinmentProvider);
                                },
                                editFunction: (context) {
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
                                        appointmentDateTime:
                                            appoinments[index]
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
        ],
      ),
    );
  }
}
