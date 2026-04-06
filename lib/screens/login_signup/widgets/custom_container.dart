import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
    required this.image,
  });
  final String text;
  final String image;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: borderColor, width: 3),
        ),
        child: Row(
          mainAxisAlignment: .spaceAround,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18..sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Image.asset(image),
            ),
          ],
        ),
      ),
    );
  }
}
