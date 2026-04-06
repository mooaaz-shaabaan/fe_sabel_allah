import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Center(
              child: Text(
                "مرحب بالأحباب",
                style: TextStyle(color: Colors.white, fontSize: 30..sp),
              ),
            ),
          ),
          ListTile(title: Text("الملف الشخصي"), onTap: () {}),
          // أضف بقية العناصر هنا
        ],
      ),
    );
  }
}
