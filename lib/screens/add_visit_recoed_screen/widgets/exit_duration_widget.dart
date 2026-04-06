import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_cubit.dart';
import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_state.dart';
import 'confirm_exit_button.dart';
import 'manual_date_picker_field.dart';

class ExitDurationWidget extends StatelessWidget {
  const ExitDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddKhrogCubit, AddKhrogState>(
      builder: (context, state) {
        final cubit = context.read<AddKhrogCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 15.h),
            ManualDatePickerField(state: state, cubit: cubit),
            SizedBox(height: 40.h),
            ConfirmExitButton(state: state),
          ],
        );
      },
    );
  }
}
