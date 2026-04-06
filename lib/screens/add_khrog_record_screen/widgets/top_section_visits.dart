import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopSectionVisits extends StatelessWidget {
  const TopSectionVisits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h, left: 10.w, right: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "إضافة خروج جديد",
                style: TextStyle(
                  fontSize: 26..sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'ID: FD88A',
                style: TextStyle(
                  fontSize: 16..sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 24..sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
