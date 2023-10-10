import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditMedicineSchedule extends StatefulWidget {
  final String medicineName;
  final String dosage;
  final String medicineType;
  final String medicineInterval;
  final String id;

  const EditMedicineSchedule({
    super.key,
    required this.medicineName,
    required this.dosage,
    required this.medicineType,
    required this.medicineInterval,
    required this.id,
  });

  @override
  EditMedicineScheduleState createState() => EditMedicineScheduleState();
}

class EditMedicineScheduleState extends State<EditMedicineSchedule> {
  dynamic refresh;
  bool load = false;
  //med text editing controller
  final med = TextEditingController();
  final dosage = TextEditingController();

  String selectedMedicineType = 'Syrup'; // Initialize with a default value
  String? selectedInterval; // Declare selectedInterval as nullable
  bool showHint = true;
  final _formKey = GlobalKey<FormState>();
  final List<String> intervals = [
    '6 hours',
    '8 hours',
    '12 hours',
    '24 hours',
  ];
  TimeOfDay? selectedTime = TimeOfDay.now(); // Update the type to TimeOfDay?
  @override
  void initState() {
    super.initState();
    med.text = widget.medicineName;
    dosage.text = widget.dosage;
    selectedMedicineType = widget.medicineType;
    selectedInterval = widget.medicineInterval;
  }

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondary,
          centerTitle: true,
          title: const Text("Edit Medminder"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Form(
              key: _formKey,
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
                  TextField(
                    controller: med,
                    decoration: const InputDecoration(
                      hintText: "Enter Medicine Name",
                      border: OutlineInputBorder(),
                    ),
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
                      medicineType('lib/constants/assets/pills.png', 'Pill'),
                      medicineType(
                          'lib/constants/assets/syringe.png', 'Syringe'),
                      medicineType(
                          'lib/constants/assets/tablets.png', 'Tablet'),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Dosage",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: dosage,
                    decoration: InputDecoration(
                      hintText: getHintText(
                          selectedMedicineType), // Get the hint text dynamically
                      border: const OutlineInputBorder(),
                    ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Remind me every',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(width: 1.5.w),
                      DropdownButton<String>(
                        value: selectedInterval,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedInterval = newValue;
                          });
                        },
                        items: intervals.map((String interval) {
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
                  SizedBox(height: 3.h),
                  Center(
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
                        await Med().updateMed(
                          context,
                          widget.id,
                          med.text,
                          dosage.text,
                          selectedMedicineType,
                          selectedInterval!,
                        );
                        setState(() {
                          load = false;
                        });
                        med.clear();
                        dosage.clear();
                        refresh;
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary, // Primary background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.sp),
                        child: load
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Consumer(
                                builder: (context, ref, _) {
                                  final userResult = ref.watch(medProvider);
                                  refresh = ref.refresh(medProvider);
                                  ref.refresh(missedMedProvider);
                                  ref.refresh(takenMedProvider);
                                  ref.refresh(pendingMedProvider);
                                  return userResult.when(
                                    data: (notes) {
                                      return Text(
                                        'Update',
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                        ),
                                      );
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
                ],
              ),
            ),
          ),
        ),
      ),
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
      case 'Bottle':
        return 'Qty of Spoon';
      case 'Pill':
        return 'Qty of Pills';
      case 'Syringe':
        return 'Qty of Syringes';
      case 'Tablet':
        return 'Qty of Tablets';
      default:
        return 'Enter Quantity';
    }
  }
}
