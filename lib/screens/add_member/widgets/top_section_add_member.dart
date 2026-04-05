import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';

class TopSectionAddMember extends StatelessWidget {
  const TopSectionAddMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h, left: 10.w, right: 15.w),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "إضافة عضو جديد",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5.h),
              Text(
                'ID: FD88A',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: .ltr,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.white,
                size: 25.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
