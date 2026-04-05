import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'بحث عن شخص بالاسم أو رقم الموبيل ...',
                      hintStyle: TextStyle(fontSize: 15.sp),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
