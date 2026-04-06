import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/colors.dart';

Future<bool> checkConnection(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true; // ✅ في نت
    }
  } catch (_) {}

  // ❌ مفيش نت — بنظهر الـ dialog
  if (context.mounted) _showNoConnectionDialog(context);
  return false;
}

void _showNoConnectionDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
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
                size: 48..sp,
                color: Colors.red.shade400,
              ),
            ),

            SizedBox(height: 20.h),

            // ── العنوان ──
            Text(
              'لا يوجد اتصال بالإنترنت',
              style: TextStyle(
                fontSize: 18..sp,
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








/*
  // قبل أي عملية تحتاج نت
  onPressed: () async {
  final hasConnection = await checkConnection(context);
  if (!hasConnection) return;

  // كملي شغلك هنا
  await cubit.addMember();
},
*/