import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_cubit.dart';
import '../../../logic/add_khrog_and_visit/add_khrog_and_visit_state.dart';
import 'icon_container.dart';
import 'simple_button.dart';

class ManualDatePickerField extends StatelessWidget {
  final AddKhrogState state;
  final AddKhrogCubit cubit;

  const ManualDatePickerField({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: state.isDateEnabled ? 1.0 : 0.5,
      child: AbsorbPointer(
        absorbing: !state.isDateEnabled,
        child: GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF1E6E73),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              cubit.updateSelectedDate(pickedDate);
            }
          },
          child: Row(
            children: [
              const IconContainer(icon: Icons.calendar_month_outlined),
              SizedBox(width: 10.w),
              Expanded(
                child: SimpleButton(
                  text: state.selectedDate == null
                      ? "تحديد تاريخ الخروج"
                      : "${state.selectedDate!.year}-${state.selectedDate!.month}-${state.selectedDate!.day}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
