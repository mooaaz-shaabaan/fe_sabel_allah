import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../logic/details_groub/details_groub_cubit.dart';
import '../../../model/member_model.dart';
import '../../add_member/add_member_screen.dart';
import 'member_item_card.dart';

class MembersHorizontalList extends StatelessWidget {
  final List<MembersModel> members;
  final int? selectedMemberIndex;
  final Function(int) onMemberTap;

  const MembersHorizontalList({
    super.key,
    required this.members,
    required this.selectedMemberIndex,
    required this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: members.length + 1,
        itemBuilder: (context, index) {
          // ✅ آخر عنصر = زر الإضافة
          if (index == members.length) {
            return _buildAddMemberButton(context);
          }

          // ✅ الأعضاء بدون تعديل على الـ index
          final bool isSelected = selectedMemberIndex == index;
          return MemberItemCard(
            member: members[index],
            isSelected: isSelected,
            onTap: () => onMemberTap(index),
          );
        },
      ),
    );
  }

  // ✅ تم فصل زر الإضافة لترتيب الكود وتسهيل قراءته
  Widget _buildAddMemberButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => AddMemberScreen(
              detailsGroubCubit: context.read<DetailsGroubCubit>(),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 10.h),
        child: Container(
          width: 130.w,
          margin: EdgeInsets.only(right: 8.w),
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
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person_badge_plus,
                color: AppColors.primary,
                size: 35.sp,
              ),
              SizedBox(height: 5.h),
              Text(
                'اضافة عضو جديد',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
