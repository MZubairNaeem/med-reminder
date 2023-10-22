import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/services/doc_appointment_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AppoinmentsEdit extends StatefulWidget {
  String hospitalName;
  String doctorName;
  Timestamp appointmentDateTime;
  String note;
  String visitReason;
  // String? prescription;
  bool status;
  String id;
  String uid;

  AppoinmentsEdit({
    super.key,
    required this.hospitalName,
    required this.doctorName,
    required this.appointmentDateTime,
    required this.note,
    required this.visitReason,
    // this.prescription,
    required this.status,
    required this.id,
    required this.uid,
  });
  @override
  _AppoinmentsEdit createState() => _AppoinmentsEdit();
}

class _AppoinmentsEdit extends State<AppoinmentsEdit> {
  dynamic refresh;
  final doctorName = TextEditingController();
  final hospitalName = TextEditingController();
  final note = TextEditingController();
  final visitReason = TextEditingController();
  Timestamp? _selectedDateTime;
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  bool val = false;

  @override
  void initState() {
    super.initState();

    // Set the initial values of text fields using the widget's parameters
    visitReason.text = widget.visitReason;
    doctorName.text = widget.doctorName;
    hospitalName.text = widget.hospitalName;
    note.text = widget.note;

    // Initialize _selectedDateTime with the provided initial value
    _selectedDateTime = widget.appointmentDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Edit Doctor Appointments'),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLength: 25,
                    controller: visitReason,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter visit reasone';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(), // Use OutlineInputBorder to make it rectangular
                      labelText: 'Visit Reason',
                      hintText: 'Reasone for visit...',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    //number of characters
                    maxLength: 25,
                    controller: doctorName,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(), // Use OutlineInputBorder to make it rectangular
                      labelText: 'Doctor Name',
                      hintText: 'Enter your doctor name...',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    maxLength: 25,
                    controller: hospitalName,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(), // Use OutlineInputBorder to make it rectangular
                      labelText: 'Hospital Name',
                      hintText: 'Enter your hospital name...',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    maxLength: 100,
                    maxLines: 3,
                    controller: note,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(), // Use OutlineInputBorder to make it rectangular
                      labelText: 'Note',
                      hintText: 'Add any note...',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDateTime != null) {
                        // ignore: use_build_context_synchronously
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          selectedDateTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          setState(() {
                            _selectedDateTime =
                                Timestamp.fromDate(selectedDateTime!);
                            val = false;
                          });
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          'Tap to Select Appointment Date and Time',
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        val
                            ? Text(
                                'Please select date and time',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.red),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_selectedDateTime != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selected Date and Time: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat.yMd()
                              .add_jm()
                              .format(_selectedDateTime!.toDate()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 100.w,
                height: 12.w,
                child: ElevatedButton(
                  onPressed: () async {
                    String formattedDateTime = _selectedDateTime != null
                        ? DateFormat('yyyy-MM-dd HH:mm')
                            .format(_selectedDateTime!.toDate())
                        : "";
                    setState(() {
                      load = true;
                    });
                    if (!_formKey.currentState!.validate()) {
                      setState(() {
                        load = false;
                      });
                      return;
                    }
                    await Appointments().updateAppointments(
                      context,
                      widget.id,
                      doctorName.text,
                      hospitalName.text,
                      _selectedDateTime,
                      note.text,
                      visitReason.text,
                      widget.status,
                    );
                    setState(() {
                      load = false;
                    });
                    await refresh;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: load
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: white,
                        ))
                      : Consumer(
                          builder: (context, ref, _) {
                            final userResult = ref.watch(appoinmentProvider);
                            refresh = ref.refresh(appoinmentProvider);
                            ref.refresh(completedAppoinmentProvider);
                            ref.refresh(missedAppoinmentProvider);
                            ref.refresh(upcomingAppoinmentProvider);
                            return userResult.when(
                              data: (notes) {
                                return const Text('Update');
                              },
                              loading: () => const Text("..."),
                              error: (error, stackTrace) =>
                                  Text('Error: $error'),
                            );
                          },
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
