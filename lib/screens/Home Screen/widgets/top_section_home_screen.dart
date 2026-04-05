import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';

class TopSectionHomeScreen extends StatelessWidget {
  const TopSectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h, left: 15.w, right: 15.w),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            'مرحبا , احمد!',
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: AppColors.white,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }
}
