import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class ToDoList extends StatelessWidget {
  ToDoList({
    Key? key,
    required this.taskName,
    required this.description,
    required this.deleteFunction,
    required this.editFunction,
    required this.taskCompleted,
    required this.time,
    this.select,
    this.checkList,
    required this.onSelect,
    required this.onChanged,
  }) : super(key: key);

  final String taskName;
  final String description;
  final bool taskCompleted;
  final String time;
  bool? select;
  bool? checkList;
  Function(bool?)? onSelect;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.1.h,
      ),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            taskName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 17.sp,
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: taskCompleted ? gray2 : primary,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // popup menu

                  SizedBox(height: 1.h),
                  SizedBox(
                    width: 65.w,
                    height: 4.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 15.sp,
                          color: taskCompleted ? gray2 : gray,
                        ),
                      ),
                    ),
                  ),
                ],
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
        ),
      ),
    );
  }
}
