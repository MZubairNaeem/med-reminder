import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/services/doc_appointment_controller.dart';
import 'package:medreminder/widgets/regex_validations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AppoinmentsAdd extends StatefulWidget {
  const AppoinmentsAdd({super.key});

  @override
  State<AppoinmentsAdd> createState() => _AppoinmentsAddState();
}

class _AppoinmentsAddState extends State<AppoinmentsAdd> {
  dynamic refresh;
  final doctorName = TextEditingController();

  final hospitalName = TextEditingController();

  final note = TextEditingController();

  final visitReason = TextEditingController();
  Timestamp? _selectedDateTime;
  //form key
  final _formKey = GlobalKey<FormState>();

  bool load = false;
  bool val = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            const Text('Doctor Appointments', style: TextStyle(color: white)),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      } else if (!letterOnlyRegex.hasMatch(val)) {
                        return 'Medicine name should only contain letters (a-zA-Z)';
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
                    validator: (val) {
                      if (!letterOnlyRegex.hasMatch(val!) && val.isNotEmpty) {
                        return 'Doctor name should only contain letters (a-zA-Z)';
                      }
                      return null;
                    },
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
                    validator: (val) {
                      if (!letterOnlyRegex.hasMatch(val!) && val.isNotEmpty) {
                        return 'Hospital name should only contain letters (a-zA-Z)';
                      }
                      return null;
                    },
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
                    validator: (val) {
                      if (!letterOnlyRegex.hasMatch(val!) && val.isNotEmpty) {
                        return 'Note should only contain letters (a-zA-Z)';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note',
                      hintText: 'Add any note...',
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // maximumSize: Size(size.width * 0.1, size.height * 0.04),
                      foregroundColor: white,
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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
                    child: const Text(
                      'Tap to Select Appointment Date and Time',
                      style: TextStyle(color: white),
                    ),
                  ),
                  val
                      ? Text(
                          'Please select date and time',
                          style: TextStyle(fontSize: 14.sp, color: Colors.red),
                        )
                      : Container(),
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
                    setState(() {
                      load = true;
                    });
                    if (!_formKey.currentState!.validate()) {
                      setState(() {
                        load = false;
                      });
                      return;
                    }
                    if (_selectedDateTime == null) {
                      setState(() {
                        val = true;
                        load = false;
                      });
                      return;
                    }

                    await Appointments().addAppointments(
                      context,
                      doctorName.text.trim(),
                      hospitalName.text.trim(),
                      _selectedDateTime,
                      note.text.trim(),
                      visitReason.text.trim(),
                      // Timestamp.now(),
                    );
                    //unfocus keyboard
                    // ignore: use_build_context_synchronously
                    FocusScope.of(context).unfocus();
                    doctorName.clear();
                    hospitalName.clear();
                    note.clear();
                    visitReason.clear();
                    _selectedDateTime = null;

                    setState(() {
                      load = false;
                    });
                    refresh;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: white,
                    backgroundColor: secondary,
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
                                return const Text('Add');
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
