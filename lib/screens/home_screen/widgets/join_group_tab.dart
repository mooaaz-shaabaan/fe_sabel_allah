// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../logic/home_screen/home_cubit.dart';
// import '../../../logic/home_screen/home_state.dart';
// import 'custom_group_text_field.dart';
// import 'custom_group_action_button.dart';

// class JoinGroupTab extends StatefulWidget {
//   const JoinGroupTab({super.key});

//   @override
//   State<JoinGroupTab> createState() => _JoinGroupTabState();
// }

// class _JoinGroupTabState extends State<JoinGroupTab> {
//   final TextEditingController _groupCodeController = TextEditingController();

//   @override
//   void dispose() {
//     _groupCodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeState>(
//       // الـ listener بيسمع للتغييرات عشان ينفذ أمر (قفل الشاشة)
//       listener: (context, state) {
//         if (state is HomeSuccess) {
//           // لو الحالة نجاح، بنقفل الـ Bottom Sheet
//           Navigator.pop(context);
//         }
//       },
//       // الـ builder بيتحكم في شكل الـ UI (إظهار الخطأ)
//       builder: (context, state) {
//         String? errorMessage;
//         if (state is HomeError) {
//           errorMessage = state.message;
//         }

//         return Column(
//           children: [
//             SizedBox(height: 15.h),
//             CustomGroupTextField(
//               controller: _groupCodeController,
//               hint: "أدخل كود المجموعة (مثلاً: FD88A)",
//               icon: Icons.qr_code_scanner_rounded,
//               errorText: errorMessage,
//             ),
//             const Spacer(),
//             CustomGroupActionButton(
//               text: "انضمام الآن",
//               onPressed: () {
//                 final code = _groupCodeController.text.trim();
//                 if (code.isNotEmpty) {
//                   context.read<HomeCubit>().joinGroup(code);
//                 } else {
//                   // لو الكود فاضي ممكن تطلع رسالة فورية هنا برضه
//                 }
//               },
//             ),
//             SizedBox(height: 20.h),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/home_screen/home_cubit.dart';
import '../../../logic/home_screen/home_state.dart';
import 'custom_group_text_field.dart';
import 'custom_group_action_button.dart';

class JoinGroupTab extends StatefulWidget {
  const JoinGroupTab({super.key});

  @override
  State<JoinGroupTab> createState() => _JoinGroupTabState();
}

class _JoinGroupTabState extends State<JoinGroupTab> {
  final TextEditingController _groupCodeController = TextEditingController();

  @override
  void dispose() {
    _groupCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeSuccess) {
          Navigator.pop(context); // يقفل الـ Sheet لو نجح
        }
      },
      builder: (context, state) {
        String? errorMessage;
        if (state is HomeError) {
          errorMessage = state.message;
        }

        return Column(
          children: [
            SizedBox(height: 15.h),
            CustomGroupTextField(
              controller: _groupCodeController,
              hint: "أدخل كود المجموعة (مثلاً: FD88A)",
              icon: Icons.qr_code_scanner_rounded,
              errorText: errorMessage,
            ),
            const Spacer(),
            CustomGroupActionButton(
              text: "انضمام الآن",
              onPressed: () {
                final code = _groupCodeController.text.trim();
                if (code.isNotEmpty) {
                  context.read<HomeCubit>().joinGroup(code);
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
