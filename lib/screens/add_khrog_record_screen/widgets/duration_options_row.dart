import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_cubit.dart';
import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_state.dart';
import 'duration_option.dart';

class DurationOptionsRow extends StatelessWidget {
  final AddKhrogState state;
  final AddKhrogCubit cubit;

  const DurationOptionsRow({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "مدة الخروج",
          style: TextStyle(
            fontSize: 18..sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Row(
          spacing: 10.w,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DurationOption(
              title: "٣ أيام",
              index: 2,
              selectedIndex: state.selectedIndex,
              onTap: () => cubit.updateIndex(2),
            ),
            DurationOption(
              title: "٤٠ يوم",
              index: 1,
              selectedIndex: state.selectedIndex,
              onTap: () => cubit.updateIndex(1),
            ),
            DurationOption(
              title: "٤ شهور",
              index: 0,
              selectedIndex: state.selectedIndex,
              onTap: () => cubit.updateIndex(0),
            ),
          ],
        ),
      ],
    );
  }
}
