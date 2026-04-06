import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/home_screen/home_cubit.dart';
import 'custom_group_text_field.dart';
import 'custom_group_action_button.dart';

class CreateGroupTab extends StatefulWidget {
  const CreateGroupTab({super.key});

  @override
  State<CreateGroupTab> createState() => _CreateGroupTabState();
}

class _CreateGroupTabState extends State<CreateGroupTab> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        CustomGroupTextField(
          controller: _groupNameController,
          hint: "اسم المجموعة",
          icon: Icons.edit_note_rounded,
        ),
        const Spacer(),
        CustomGroupActionButton(
          text: "إنشاء المجموعة الآن",
          onPressed: () {
            context.read<HomeCubit>().createGroup(_groupNameController.text);
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
