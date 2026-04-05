import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/images.dart';
import '../../../model/card_model.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.onTap, required this.membersData});

  final Function() onTap;
  final MembersModel membersData;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: .ltr,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.more_horiz, color: Colors.grey), // النقاط الثلاث
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        membersData.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${membersData.age} سنة',
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                      Text(
                        'طالب',
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  // الصورة الشخصية مع أيقونة الجنس
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 30.r,
                        backgroundImage: AssetImage(membersData.photo),
                      ),
                    
                    ],
                  ),
                ],
              ),
              Divider(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // التاج (طالب / خروج للدعوة)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F2E7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          membersData.isStudent
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 14.sp,
                          color: membersData.isStudent
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'طالب',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // آخر زيارة
                  Row(
                    children: [
                      Image.asset(AppImages.whatsappLogo, width: 20.sp),
                      SizedBox(width: 20.w),
                      Image.asset(AppImages.phoneCall, width: 20.sp),
                      SizedBox(width: 5.w),
                      Text(
                        ' : للتواصل',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




