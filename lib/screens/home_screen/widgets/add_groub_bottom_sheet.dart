import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../const/colors.dart';
import '../../../logic/home_screen/home_cubit.dart';
import 'create_group_tab.dart';
import 'join_group_tab.dart';

class AddGroupBottomSheet extends StatelessWidget {
  final HomeCubit homeCubit;

  const AddGroupBottomSheet({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey[400],
                  labelStyle: TextStyle(
                    fontSize: 16..sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                  tabs: const [
                    Tab(text: "إنشاء مجموعة"),
                    Tab(text: "انضمام لمجموعة"),
                  ],
                ),

                SizedBox(height: 10.h),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: const TabBarView(
                      children: [CreateGroupTab(), JoinGroupTab()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
