import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicineSchedule extends StatefulWidget {
  const MedicineSchedule({super.key});

  @override
  State<MedicineSchedule> createState() => _MedicineScheduleState();
}

class _MedicineScheduleState extends State<MedicineSchedule> {
  String selectedMedicineType = 'Bottle'; // Initialize with a default value
  String? selectedInterval; // Declare selectedInterval as nullable
  bool showHint = true;
  final List<String> intervals = [
    '6 hours',
    '8 hours',
    '12 hours',
    '24 hours',
  ];
  TimeOfDay? selectedTime = TimeOfDay.now(); // Update the type to TimeOfDay?

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
          centerTitle: true,
          title: Text("Add New Medminder"),
        ),
        body: SingleChildScrollView(
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
                TextField(
                  decoration: InputDecoration(
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
                    medicineType('lib/constants/assets/bottles.png', 'Bottle'),
                    medicineType('lib/constants/assets/pills.png', 'Pill'),
                    medicineType('lib/constants/assets/syringe.png', 'Syringe'),
                    medicineType('lib/constants/assets/tablets.png', 'Tablet'),
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
                  decoration: InputDecoration(
                    hintText: getHintText(
                        selectedMedicineType), // Get the hint text dynamically
                    border: OutlineInputBorder(),
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
                      value: showHint ? null : selectedInterval,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedInterval = newValue;
                          showHint =
                              false; // Hide the hint once an item is selected
                        });
                      },
                      hint: Text(
                        'Select an interval',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ), // Set the hint text
                      //underline: Container(),
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
                      primary: primary, // Primary background color
                      onPrimary: Colors.white, // Text color
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: primary, // Primary background color
                            onPrimary: Colors.white, // Text color
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.sp),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
