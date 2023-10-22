import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String medicineType;
  final String medicineInterval;
  String? qty;
  bool? select;
  bool? checkList;
  Function(bool?)? onSelect;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  MedicineCard({
    super.key,
    required this.medicineName,
    required this.dosage,
    required this.medicineType,
    required this.medicineInterval,
    this.qty,
    this.select,
    this.checkList,
    required this.onSelect,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Card(
        color: blueGray,
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medicine Name:",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  SizedBox(
                    width: 30.w,
                    child: Text(
                      medicineName,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: select!,
                    child: Checkbox(
                      value: checkList,
                      onChanged: onSelect,
                      activeColor: const Color.fromARGB(255, 221, 44, 31),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    'Dosage:',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    dosage,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    'Quantity:',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    qty!,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    "Medicine Type:",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    medicineType,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    "Medicine Interval:",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    medicineInterval,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
