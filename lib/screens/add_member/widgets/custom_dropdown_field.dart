import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.icon,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonFormField<String>(
        validator: validator,
        value: selectedValue,
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.grey, size: 22..sp),
        ),
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey[600], fontSize: 14..sp),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 24..sp),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14..sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
