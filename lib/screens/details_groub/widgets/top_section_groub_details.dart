import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../logic/details_groub/details_groub_cubit.dart';
import '../../../logic/details_groub/details_groub_state.dart';
import '../../../model/groub_model.dart';
import '../../../model/user_model.dart';
import '../../../shared/check_connection.dart';
import '../../../shared/user_local_storage.dart';

class TopSectionGroubDetails extends StatelessWidget {
  const TopSectionGroubDetails({super.key, required this.groupDetails});
  final GroupModel groupDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h, left: 10.w, right: 15.w),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupDetails.groupName,
                style: TextStyle(fontSize: 30..sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5.h),
              Text(
                'ID: ${groupDetails.groupCode}',
                style: TextStyle(
                  fontSize: 18..sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          groupDetails.adminId == UserLocalStorage.getUser()?.id
              ? BlocBuilder<DetailsGroubCubit, DetailsGroubState>(
                  builder: (context, state) {
                    final count = state.pendingRequests.length;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.primary,
                          child: IconButton(
                            onPressed: () async {
                              final hasConnection = await checkConnection(
                                context,
                              );
                              if (!hasConnection) return;
                              if (context.mounted) {
                                // ✅ جيب البيانات الأول، وبعدين افتح الـ sheet
                                await context
                                    .read<DetailsGroubCubit>()
                                    .getPendingRequests();
                                if (context.mounted)
                                  bottomSheet(context: context);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.person_badge_plus,
                              color: AppColors.white,
                              size: 25..sp,
                            ),
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            top: -4,
                            left: -4,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10..sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                )
              : const SizedBox(),
          const SizedBox(),
          SizedBox(width: 10.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.white,
                size: 25..sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void bottomSheet({required BuildContext context}) {
    final cubit = context.read<DetailsGroubCubit>();

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<DetailsGroubCubit, DetailsGroubState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    if (state.pendingRequests.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          "لا يوجد طلبات انضمام الآن",
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.pendingRequests.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final UserModel user = state.pendingRequests[index];
                        return MemberRequestCard(
                          name: user.name ?? '',
                          avatarUrl: user.photoUrl,
                          onAccept: () async {
                            await context
                                .read<DetailsGroubCubit>()
                                .approveRequest(user: user);
                          },
                          onReject: () async {
                            await context
                                .read<DetailsGroubCubit>()
                                .rejectRequest(user: user);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MemberRequestCard extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const MemberRequestCard({
    super.key,
    required this.name,
    this.avatarUrl =
        'https://lh3.googleusercontent.com/a/ACg8ocKT4YeZmVRUI-RksBtcGI7ylifGSedfvhdlDk7uzSYN1PmWVPVX=s96-c',
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: const Color(0xFFE8F0F7),
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? Icon(Icons.person, size: 30.sp, color: Color(0xFF6B8CAE))
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15..sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionButton(
                        label: 'Reject',
                        icon: Icons.close,
                        color: const Color(0xFFE53935),
                        onTap: onReject,
                      ),
                      SizedBox(width: 8.w),
                      _ActionButton(
                        label: 'Accept',
                        icon: Icons.check,
                        color: const Color(0xFF43A047),
                        onTap: onAccept,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14..sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13..sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
