import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchFieldAddVisit extends StatelessWidget {
  const CustomSearchFieldAddVisit({
    super.key,
    required this.searchController,
    required this.onChanged,
  });
  final TextEditingController searchController;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: searchController,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'بحث عن شخص بالاسم أو رقم الموبيل ...',
          hintStyle: TextStyle(fontSize: 13..sp, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
