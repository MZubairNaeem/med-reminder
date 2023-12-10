import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:medreminder/widgets/regex_validations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicineSchedule extends StatefulWidget {
  const MedicineSchedule({super.key});

  @override
  State<MedicineSchedule> createState() => _MedicineScheduleState();
}

class _MedicineScheduleState extends State<MedicineSchedule> {
  final med = TextEditingController();
  final dosage = TextEditingController();
  final qty = TextEditingController();
  dynamic refresh;
  bool intervalCheck = false;

  String selectedMedicineType = 'Syrup'; // Initialize with a default value
  String? selectedInterval; // Declare selectedInterval as nullable
  bool showHint = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final List<String> intervalsDays = [
    '1 Day',
    '2 Days',
    '3 Days',
    '4 Days',
    '5 Days',
    '6 Days',
    '1 Week',
    '2 Weeks',
    '3 Weeks',
    '1 Month',
  ];
  final List<String> intervalsHours = [
    '6 hours',
    '8 hours',
    '12 hours',
    '24 hours',
  ];
  TimeOfDay? selectedTime = TimeOfDay.now(); // Update the type to TimeOfDay?
  int intervalHours = 0;

  // Function to show the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        centerTitle: true,
        title: const Text("Add New Medicine", style: TextStyle(color: white)),
      ),
      body: Builder(builder: (BuildContext scaffoldContext) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medicine Name",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: med,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "Enter Medicine Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Medicine name is required';
                      } else if (value.length > 25) {
                        return 'Medicine name should be at most 25 characters';
                      } else if (!letterOnlyRegex.hasMatch(value)) {
                        return 'Medicine name should only contain letters (a-zA-Z)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Medicine Type",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      medicineType('lib/constants/assets/bottles.png', 'Syrup'),
                      medicineType('lib/constants/assets/pills.png', 'Capsule'),
                      medicineType(
                          'lib/constants/assets/syringe.png', 'Syringe'),
                      medicineType(
                          'lib/constants/assets/tablets.png', 'Tablet'),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  TextFormField(
                    controller: qty,
                    decoration: const InputDecoration(
                      hintText: 'Total no of dosages',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Total no of dosages are required';
                      } else if (value.length > 5) {
                        return 'Total no of dosages should be at most 4 characters';
                      } else if (!numberOnlyRegex.hasMatch(value)) {
                        return 'Please enter only numeric digits (0-9)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: dosage,
                    decoration: InputDecoration(
                      hintText: getHintText(selectedMedicineType),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Dosage is required';
                      } else if (value.length > 25) {
                        return 'Dosage should be at most 25 characters';
                      } else if (!numberOnlyRegex.hasMatch(value)) {
                        return 'Please enter only numeric digits (0-9)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  Text(
                    "Interval Selection",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Remind me every',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      DropdownButton<String>(
                        value: showHint ? null : selectedInterval,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedInterval = newValue;
                            showHint =
                                false; // Hide the hint once an item is selected
                            intervalHours = int.parse(newValue!.split(' ')[0]);
                          });
                        },
                        hint: Text(
                          'Select an interval',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                        ), // Set the hint text
                        //underline: Container(),
                        items: intervalCheck
                            ? intervalsDays.map((String interval) {
                                return DropdownMenuItem<String>(
                                  value: interval,
                                  child: Text(
                                    interval,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                );
                              }).toList()
                            : intervalsHours.map((String interval) {
                                return DropdownMenuItem<String>(
                                  value: interval,
                                  child: Text(
                                    interval,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                      Column(
                        children: [
                          Text(
                            'Hours/Day',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                              value: intervalCheck,
                              onChanged: (value) {
                                selectedInterval = null;
                                setState(() {
                                  intervalCheck = value!;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Starting Time",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(
                            context); // Call the time picker when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary, // Primary background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.sp),
                        child: Text(
                          'Pick Time',
                          style: TextStyle(
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Text(
                      selectedTime == null
                          ? 'No time selected'
                          : 'Selected time: ${selectedTime!.format(context)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.watch(medProvider);
                              // ref.refresh(medProvider);
                              return userResult.when(
                                  data: (medicine) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        print(intervalHours);
                                        print(selectedTime);
                                        // Get.snackbar(
                                        //   selectedTime.toString(),
                                        //   intervalHours.toString(),
                                        //   snackPosition: SnackPosition.BOTTOM,
                                        // );
                                        if (_formKey.currentState!.validate()) {
                                          if (selectedInterval == null) {
                                            ScaffoldMessenger.of(
                                                    scaffoldContext)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please select an interval.'),
                                                duration: Duration(
                                                    seconds:
                                                        2), // Adjust the duration as needed
                                              ),
                                            );
                                            return;
                                          }

                                          setState(() {
                                            loading = true;
                                          });
                                          await Med().addMed(
                                            context,
                                            med.text.trim(),
                                            selectedMedicineType,
                                            dosage.text.trim(),
                                            selectedInterval.toString(),
                                            qty.text.trim(),
                                            intervalHours,
                                            selectedTime!,
                                          );

                                          // ignore: unused_result
                                          ref.refresh(medProvider);
                                          ref.refresh(missedMedProvider);
                                          ref.refresh(takenMedProvider);
                                          ref.refresh(pendingMedProvider);

                                          setState(() {
                                            med.clear();
                                            dosage.clear();
                                            qty.clear();
                                            selectedInterval = null;
                                            selectedTime = null;
                                            loading = false;
                                          });
                                          refresh;
                                          // setState(() {
                                          //   loading = false;
                                          // });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            primary, // Primary background color
                                        foregroundColor:
                                            Colors.white, // Text color
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(14.sp),
                                        child: loading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Consumer(
                                                builder: (context, ref, _) {
                                                  final userResult =
                                                      ref.watch(medProvider);
                                                  refresh =
                                                      ref.refresh(medProvider);
                                                  return userResult.when(
                                                    data: (notes) {
                                                      return Text(
                                                        'Add',
                                                        style: TextStyle(
                                                          fontSize: 17.sp,
                                                        ),
                                                      );
                                                    },
                                                    loading: () =>
                                                        const Text("..."),
                                                    error: (error,
                                                            stackTrace) =>
                                                        Text('Error: $error'),
                                                  );
                                                },
                                              ),
                                      ),
                                    );
                                  },
                                  loading: () => const Text("..."),
                                  error: (error, stackTrace) {
                                    return Text('Error: $error');
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget medicineType(String img, String title) {
    bool isSelected = selectedMedicineType == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMedicineType = title;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.sp),
            decoration: BoxDecoration(
              color: isSelected ? primary : Colors.white,
              border: Border.all(
                color: isSelected
                    ? primary
                    : Colors.grey, // Add border for clarity
              ),
            ),
            child: Image.asset(
              img,
              height: 10.h,
              width: 15.w,
              color: isSelected ? Colors.white : primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? primary : Colors.grey,
              fontSize: 16.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String getHintText(String medicineType) {
    switch (medicineType) {
      case 'Syrup':
        return 'Spoons per dosage';
      case 'Capsule':
        return 'Capsule per dosage';
      case 'Syringe':
        return 'Syringes per dosage';
      case 'Tablet':
        return 'Tablets per dosage';
      default:
        return 'Enter Quantity';
    }
  }
}
