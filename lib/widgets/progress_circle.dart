import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';

// ignore: must_be_immutable
class OnboardingArrowWithCircle extends StatelessWidget {
  final double? progress;
  void Function()? onTap;

  OnboardingArrowWithCircle({super.key, this.onTap, this.progress});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw the arrow or any visual you want
          Icon(
            Icons.arrow_forward,
            size: size.width * 0.06,
            color: gray,
          ),
          // Draw the circle representing progress
          Container(
            width: size.width * 0.2,
            height: size.width * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gray3, width: 1),
            ),
            child: CircularProgressIndicator(
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(secondary),
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
