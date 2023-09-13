import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class MedicineCard extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String medicineType;
  final String medicineInterval;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  MedicineCard({
    super.key,
    required this.medicineName,
    required this.dosage,
    required this.medicineType,
    required this.medicineInterval,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            label: 'Edit',
            backgroundColor: primary,
            onPressed: editFunction,
            icon: Icons.edit_rounded,
            foregroundColor: white,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          SlidableAction(
            label: 'Remove',
            backgroundColor: Color.fromARGB(255, 221, 44, 31),
            onPressed: deleteFunction,
            icon: Icons.delete_forever_rounded,
            foregroundColor: white,
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ]),
        child: Container(
          padding: EdgeInsets.all(16.sp),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(color: Color.fromARGB(207, 121, 180, 227)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 3,
            //     blurRadius: 5,
            //     offset: Offset(2, 3),
            //   ),
            // ],
            color: Color.fromARGB(150, 169, 205, 235),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Medicine Name:",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    medicineName,
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
