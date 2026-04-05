import 'package:fe_sabel_allah/screens/Details%20Groub/details_groub_screen.dart';
import 'package:fe_sabel_allah/screens/Home%20Screen/widgets/top_section_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import 'widgets/custom_card_groubs.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          TopSectionHomeScreen(),
          SizedBox(height: 30.h),
          CustomCardGroubs(
            name: 'شباب الهداية',
            id: 'FD88A',
            memberCount: 15,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => DetailsGroubScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
/*

 */