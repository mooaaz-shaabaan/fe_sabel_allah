import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../const/images.dart';
import '../../logic/home_screen/home_cubit.dart';
import '../../logic/login_signup/login_signup_cubit.dart';
import '../../logic/user/user_cubit.dart';
import '../../shared/check_connection.dart';
import '../home_screen/home_screen.dart';
import 'widgets/custom_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نعرف إذا كان الجهاز في وضع Landscape (زي التابلت في صورتك)
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocProvider(
      create: (context) =>
          LoginSignupCubit(userCubit: context.read<UserCubit>()),
      child: BlocConsumer<LoginSignupCubit, LoginSignupState>(
        listenWhen: (previous, current) =>
            current is LoginSuccess || current is LoginError,
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => HomeCubit()..getGroups(),
                  child: const HomeScreen(),
                ),
              ),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginSignupCubit>();
          return Scaffold(
            backgroundColor: AppColors.primary,
            // شلنا السكرول تماماً عشان نمنع الحركة المستفزة
            body: SafeArea(
              child: Column(
                children: [
                  // الجزء العلوي: اللوجو
                  Expanded(
                    flex: isLandscape ? 3 : 5, // بنصغر مساحة اللوجو في التابلت
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Image.asset(
                          AppImages.logo,
                          // بنصغر حجم اللوجو جداً في التابلت عشان ميزقش اللي تحته
                          height: isLandscape ? 100.h : 200.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isLandscape ? 4 : 4,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is LoginLoading)
                            const CircularProgressIndicator()
                          else ...[
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400.w),
                              child: Column(
                                children: [
                                  CustomContainer(
                                    text: 'تسجيل الدخول باستخدام جوجل',
                                    image: AppImages.googleLogo,
                                    textColor: Colors.black,
                                    backgroundColor: AppColors.white,
                                    borderColor: AppColors.containerBorder,
                                    onTap: () async {
                                      if (await checkConnection(context)) {
                                        cubit.signInWithGoogle();
                                      }
                                    },
                                  ),
                                  SizedBox(height: 15.h),
                                  CustomContainer(
                                    text: 'تسجيل الدخول باستخدام فيسبوك',
                                    image: AppImages.facebookLogo,
                                    textColor: Colors.white,
                                    backgroundColor: const Color(0xff006EC9),
                                    borderColor: AppColors.containerBorder,
                                    onTap: () async {
                                      if (await checkConnection(context)) {
                                        cubit.signInWithFacebook();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
