import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../model/member_model.dart';

class MemberItemCard extends StatelessWidget {
  final MembersModel member; // تغيير dynamic لـ MembersModel
  final bool isSelected;
  final VoidCallback onTap;

  const MemberItemCard({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 12.w, bottom: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 130.w,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              width: 1.5.w,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage(member.photo),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  member.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14..sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
