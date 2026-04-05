import 'package:fe_sabel_allah/screens/Home%20Screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../const/images.dart';
import 'widgets/custom_container.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 160.h),
            child: Image.asset(AppImages.logo, width: 250.w),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                CustomContainer(
                  text: 'تسجيل الدخول بأستخدام جوجل',
                  image: AppImages.googleLogo,
                  textColor: Colors.black,
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.containerBorder,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => Homescreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                CustomContainer(
                  text: 'تسجيل الدخول بأستخدام فيسبوك',
                  image: AppImages.facebookLogo,
                  textColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 0, 110, 201),
                  borderColor: AppColors.containerBorder,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
