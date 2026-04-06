import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../model/member_model.dart';

class MemberDetailsBottomSheet extends StatelessWidget {
  const MemberDetailsBottomSheet({super.key, required this.member});

  final MembersModel member;

  static void show(BuildContext context, MembersModel member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MemberDetailsBottomSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 0.75.sh, // استخدام .sh لنسبة ارتفاع الشاشة
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              height: 5.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: member.photo.isNotEmpty
                              ? AssetImage(member.photo)
                              : null,
                          child: member.photo.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 40.sp,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${member.age} سنة',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        _StatusBadge(text: 'طالب', isActive: member.isStudent),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: const Divider(),
                    ),
                    const _SectionTitle(
                      title: 'معلومات التواصل',
                      icon: Icons.contact_phone_outlined,
                    ),
                    SizedBox(height: 10.h),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.phone_android,
                          title: 'رقم الموبايل',
                          value: member.phone,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    if (member.faculty != null &&
                        member.university != null &&
                        member.level != null) ...[
                      const _SectionTitle(
                        title: 'البيانات الدراسية',
                        icon: Icons.school_outlined,
                      ),
                      SizedBox(height: 10.h),
                      _InfoCard(
                        children: [
                          _InfoRow(
                            icon: Icons.account_balance,
                            title: 'الجامعة',
                            value: member.university ?? 'غير محدد',
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: const Divider(),
                          ),
                          _InfoRow(
                            icon: Icons.menu_book,
                            title: 'الكلية',
                            value: member.faculty ?? 'غير محدد',
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: const Divider(),
                          ),
                          _InfoRow(
                            icon: Icons.stairs,
                            title: 'المستوى',
                            value: member.level ?? 'غير محدد',
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 20.h),
                    const _SectionTitle(
                      title: 'نشاط العضو',
                      icon: Icons.history,
                    ),
                    SizedBox(height: 10.h),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.access_time,
                          title: 'آخر زيارة',
                          value: member.lastVisted ?? 'غير معروف',
                          valueColor: AppColors.secondary,
                        ),
                        if (member.lastKhroug != null) ...[
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: const Divider(),
                          ),
                          _InfoRow(
                            icon: Icons.time_to_leave,
                            title: 'آخر خروج',
                            value: member.lastKhroug!,
                          ),
                        ],
                      ],
                    ),
                    if (member.notes.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      const _SectionTitle(title: 'ملاحظات', icon: Icons.notes),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          member.notes,
                          style: TextStyle(fontSize: 14.sp, height: 1.5),
                        ),
                      ),
                    ],
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E888A), size: 22.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E888A),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.isActive});

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 16.sp,
            color: isActive ? Colors.green : Colors.red,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
