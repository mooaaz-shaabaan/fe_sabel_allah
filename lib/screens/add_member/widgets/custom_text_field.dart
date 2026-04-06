import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType keyboardType; // إضافة نوع الكيبورد
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator, // الافتراضي نص
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Icon(icon, color: Colors.grey, size: 22..sp),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator, // لازم تمرر الـ validator هنا
              maxLines: maxLines,
              keyboardType: keyboardType, // ربط نوع الكيبورد
              style: TextStyle(color: Colors.black, fontSize: 14..sp),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14..sp, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
