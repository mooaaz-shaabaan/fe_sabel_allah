import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DurationOption extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const DurationOption({
    super.key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF263238)
                : const Color(0xFF1E6E73),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16..sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
