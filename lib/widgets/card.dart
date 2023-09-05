import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  String text;
  void Function() onTap;
  double height;
  double width;
  CustomCard(
      {super.key,
      required this.text,
      required this.onTap,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(3.w),
        elevation: 2,
        shadowColor: secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
