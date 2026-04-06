import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';

class CustomGroupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? errorText; // ضفنا المتغير ده هنا

  const CustomGroupTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.errorText, // اختياري
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.black),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary, size: 22..sp),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14..sp),
        errorText: errorText, // هنا بيظهر الخطأ تحت الـ TextField
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: Colors.grey[100]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // شكل الحواف لما يكون فيه خطأ وانت ضاغط عليه
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          // شكل الحواف لما يكون فيه خطأ
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
