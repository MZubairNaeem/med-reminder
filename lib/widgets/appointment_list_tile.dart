import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AppointmentListTile extends StatelessWidget {
  AppointmentListTile({
    Key? key,
    required this.doctorName,
    required this.reason,
    required this.hospitalName,
    required this.deleteFunction,
    required this.editFunction,
    required this.taskCompleted,
    required this.time,
    this.checklist,
    required this.note,
    required this.date,
    required this.onChanged,
    required this.index,
    this.onSelect,
    this.select,
  }) : super(key: key);

  final String doctorName;
  final String hospitalName;
  final bool taskCompleted;
  final String reason;
  final String note;
  final String time;
  final String date;
  bool? checklist;
  final int index;
  bool? select;
  Function(bool?)? onChanged;
  Function(bool?)? onSelect;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      child: Center(
        child: SizedBox(
          width: 90.w,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appointment #$index',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: taskCompleted ? gray2 : primary,
                          decoration: taskCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Visibility(
                        visible: select!,
                        child: Checkbox(
                          value: checklist,
                          onChanged: onSelect,
                          activeColor: const Color.fromARGB(255, 221, 44, 31),
                        ),
                      ),
                      // Visibility(
                      //   visible: !select!,
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       Container(
                      //         width: 20.sp,
                      //         height: 20.sp,
                      //         decoration: const BoxDecoration(
                      //           color: Colors.red,
                      //           shape: BoxShape.circle,
                      //         ),
                      //       ),
                      //       Container(
                      //         width: 18.sp,
                      //         height: 18.sp,
                      //         decoration: const BoxDecoration(
                      //           color: Colors.white,
                      //           shape: BoxShape.circle,
                      //         ),
                      //       ),
                      //       Container(
                      //         width: 15.sp,
                      //         height: 15.sp,
                      //         decoration: const BoxDecoration(
                      //           color: Color.fromARGB(255, 221, 44, 31),
                      //           shape: BoxShape.circle,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: primary.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        'Doctor: ',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Hospital: ',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        hospitalName,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: taskCompleted,
                        onChanged: onChanged,
                        activeColor: secondary,
                      ),
                      Text(
                        'Appointment Scheduled',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time: ',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: lightBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Note: ',
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: lightBlue,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
