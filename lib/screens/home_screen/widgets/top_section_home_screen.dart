import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';
import '../../../logic/home_screen/home_cubit.dart';
import '../../../logic/home_screen/home_state.dart';
import '../../../logic/login_signup/login_signup_cubit.dart';
import '../../../shared/check_connection.dart';
import '../../../shared/user_local_storage.dart';
import '../../login_signup/login_screen.dart' show LoginScreen;

class TopSectionHomeScreen extends StatelessWidget {
  const TopSectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        // منطق جلب الاسم
        String name = '';
        final cubit = context.read<HomeCubit>();

        if (state is UpdateUserNameState) {
          name = state.name ?? '';
        } else if (cubit.currentUserName != null &&
            cubit.currentUserName!.isNotEmpty) {
          name = cubit.currentUserName!;
        } else {
          name = UserLocalStorage.getUser()?.name ?? '';
        }

        return Padding(
          padding: EdgeInsets.only(top: 70.h, left: 15.w, right: 15.w),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  CupertinoIcons.line_horizontal_3,
                  color: AppColors.white,
                ),
              ),
              Expanded(
                child: Text(
                  'مرحبا , $name!',
                  style: TextStyle(
                    fontSize: 24..sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // تم إزالة الـ Spacer لأن الـ Expanded يقوم بالواجب ويوزع المساحة
              IconButton(
                onPressed: () async {
                  final hasConnection = await checkConnection(context);
                  if (!hasConnection) return;

                  // إظهار مؤشر تحميل بسيط عند تسجيل الخروج إذا لزم الأمر
                  await context.read<LoginSignupCubit>().logout();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (c) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(
                  CupertinoIcons.square_arrow_left,
                  color: AppColors.white,
                  size: 32..sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
