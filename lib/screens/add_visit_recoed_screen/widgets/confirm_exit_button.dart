import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_cubit.dart';
import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_state.dart';

class ConfirmExitButton extends StatelessWidget {
  final AddKhrogState state;

  const ConfirmExitButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // استخدمنا cubit بشكل مباشر لضمان الوصول لأحدث حالة
    final cubit = context.read<AddKhrogCubit>();

    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        // التعطيل هنا ضروري جداً لمنع الـ Double Click
        onPressed: state.isLoading
            ? null
            : () async {
                // تنفيذ العملية
                bool success = await cubit.confirmVisit();

                if (success) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  if (context.mounted) {
                    final String message =
                        cubit.state.errorMessage ?? 'حدث خطأ ما';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            message,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18..sp),
                          ),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E6E73),
          disabledBackgroundColor: const Color(0xFF1E6E73).withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: state.isLoading
            ? SizedBox(
                height: 25.h,
                width: 25.h,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3.w,
                ),
              )
            : Text(
                "تأكيد تسجيل الزيارة",
                style: TextStyle(
                  fontSize: 18..sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
