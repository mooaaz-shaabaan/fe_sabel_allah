import 'package:fe_sabel_allah/model/groub_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../const/images.dart';
import '../../../logic/details_groub/details_groub_cubit.dart';
import '../../../model/member_model.dart';
import 'details_members.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({
    super.key,
    required this.onTap,
    required this.membersData,
    required this.editFuncation,
    required this.deleteFuncation,
    required this.currentRoute,
    required this.detailsGroubCubit,
    required this.groupModel,
  });

  final Function() onTap;
  final Function() editFuncation;
  final Function() deleteFuncation;
  final MembersModel membersData;
  final String? currentRoute;
  final DetailsGroubCubit detailsGroubCubit;
  final GroupModel groupModel;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  late Future<int> _lastVisitFuture;

  @override
  void initState() {
    super.initState();
    _lastVisitFuture = widget.detailsGroubCubit.calculateDaysSinceLastVisit(
      groupId: widget.groupModel.id,
      memberId: widget.membersData.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          MemberDetailsBottomSheet.show(context, widget.membersData);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == 'edit') {
                        widget.editFuncation();
                      } else if (value == 'delete') {
                        widget.deleteFuncation();
                      } else if (value == 'allVisits') {
                        _showAllVisitsDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'allVisits',
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar_badge_plus,
                              size: 20.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8.w),
                            const Text('تاريخ الزيارات'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.pencil,
                              size: 20.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8.w),
                            const Text('تعديل'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              size: 20.sp,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8.w),
                            const Text('حذف'),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(
                      CupertinoIcons.ellipsis,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.membersData.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        '${widget.membersData.age} سنة',
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          // ✅ بيستخدم الـ future المحفوظ
                          FutureBuilder<int>(
                            future: _lastVisitFuture,
                            builder: (context, snapshot) {
                              String daysText = '...';

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  daysText = 'غير معروف';
                                } else {
                                  int days = snapshot.data ?? -1;
                                  if (days == -1) {
                                    daysText = 'لا يوجد زيارات';
                                  } else if (days == 0) {
                                    daysText = 'اليوم';
                                  } else if (days == 1) {
                                    daysText = 'يوم واحد';
                                  } else if (days == 2) {
                                    daysText = 'يومين';
                                  } else if (days >= 3 && days <= 10) {
                                    daysText = '$days أيام';
                                  } else {
                                    daysText = '$days يوم';
                                  }
                                }
                              }
                              return Text(
                                'اخر تاريخ زيارة منذ : $daysText',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13.sp,
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 5.w),
                          Icon(
                            CupertinoIcons.info_circle,
                            size: 14.sp,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30.r,
                    backgroundImage: AssetImage(widget.membersData.photo),
                  ),
                ],
              ),
              Divider(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                          widget.membersData.isStudent
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 14.sp,
                          color: widget.membersData.isStudent
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => widget.detailsGroubCubit.openWhatsApp(
                          widget.membersData.phone,
                        ),
                        child: Image.asset(AppImages.whatsappLogo, width: 20.w),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () => widget.detailsGroubCubit.makePhoneCall(
                          widget.membersData.phone,
                        ),
                        child: Image.asset(AppImages.phoneCall, width: 20.w),
                      ),
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

  void _showAllVisitsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── أيقونة ──
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 48.sp,
                  color: Colors.red.shade400,
                ),
              ),

              SizedBox(height: 20.h),

              // ── العنوان ──
              Text(
                'لا يوجد اتصال بالإنترنت',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 10.h),

              // ── الوصف ──
              Text(
                'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),

              SizedBox(height: 28.h),

              // ── زرار حسناً ──
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
