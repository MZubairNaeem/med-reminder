import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    required this.onChanged,
    required this.onSelect,
  }) : super(key: key);

  final String taskName;
  final String description;
  final bool taskCompleted;
  final String time;
  bool? select;
  bool? checkList;
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
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            label: 'Edit',
            backgroundColor: secondary,
            onPressed: editFunction,
            icon: Icons.edit_rounded,
            foregroundColor: white,
            borderRadius: BorderRadius.circular(6),
          ),
          SlidableAction(
            label: 'Remove',
            backgroundColor: const Color.fromARGB(255, 221, 44, 31),
            onPressed: deleteFunction,
            icon: Icons.delete_forever_rounded,
            foregroundColor: white,
            borderRadius: BorderRadius.circular(6),
          )
        ]),
        child: Card(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Visibility(
                      visible: select!,
                      child: Checkbox(
                        value: checkList,
                        onChanged: onSelect,
                        activeColor: const Color.fromARGB(255, 221, 44, 31),
                      ),
                    ),
                    Visibility(
                      visible: !select!,
                      child: Checkbox(
                        value: taskCompleted,
                        onChanged: onChanged,
                        activeColor: secondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 75.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            taskName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 17.sp,
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: taskCompleted ? gray2 : primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: gray2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    SizedBox(
                      width: 75.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          description,
                          overflow: TextOverflow.clip,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
