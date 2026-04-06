import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import '../../logic/add_member/add_member_state.dart';
import '../../logic/add_member/add_member_cubit.dart';
import '../../logic/details_groub/details_groub_cubit.dart';
import '../../model/member_model.dart';
import '../../shared/check_connection.dart';
import 'widgets/custom_dropdown_field.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/gender_button.dart';
import 'widgets/section_title.dart';
import 'widgets/top_section_add_member.dart';

class AddMemberScreen extends StatelessWidget {
  AddMemberScreen({super.key, required this.detailsGroubCubit, this.member});

  final DetailsGroubCubit detailsGroubCubit;
  final MembersModel? member;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => member != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMemberCubit(
        detailsGroubCubit: detailsGroubCubit,
        name: member?.name,
        phone: member?.phone,
        age: member?.age,
        faculty: member?.faculty,
        university: member?.university,
        notes: member?.notes,
        gender: member?.gender,
        isStudent: member?.isStudent,
        selectedLevel: member?.level,
      ),
      child: BlocListener<AddMemberCubit, AddMemberState>(
        listenWhen: (prev, curr) => curr.navigateTo == 'back',
        listener: (context, state) => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Column(
            children: [
               TopSectionAddMember(isEditing: isEditing,),
              SizedBox(height: 10.h),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 30.h,
                      ),
                      child: BlocBuilder<AddMemberCubit, AddMemberState>(
                        builder: (context, state) {
                          final obj = context.read<AddMemberCubit>();

                          // 2. تغليف الـ Column بـ Form
                          return Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitle(title: "البيانات الأساسية"),
                                SizedBox(height: 15.h),

                                CustomTextField(
                                  hint: "الاسم الثلاثي",
                                  icon: CupertinoIcons.person,
                                  controller: obj.nameController,
                                  // إضافة الـ validator
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال الاسم';
                                    }
                                    return null;
                                  },
                                ),

                                CustomTextField(
                                  hint: "رقم التليفون",
                                  icon: CupertinoIcons.phone,
                                  controller: obj.phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال رقم التليفون';
                                    } else if (value.length < 11) {
                                      return 'رقم التليفون غير صحيح';
                                    }
                                    return null;
                                  },
                                ),

                                CustomTextField(
                                  hint: "العمر",
                                  icon: CupertinoIcons.number,
                                  controller: obj.ageController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال العمر';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 15.h),

                                Row(
                                  children: [
                                    GenderButton(
                                      label: "ذكر",
                                      isSelected: state.gender == "ذكر",
                                      onTap: () => obj.selectGender('ذكر'),
                                    ),
                                    SizedBox(width: 10.w),
                                    GenderButton(
                                      label: "أنثى",
                                      isSelected: state.gender == "أنثى",
                                      onTap: () => obj.selectGender('أنثى'),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 30.h),
                                const SectionTitle(title: "تفاصيل الدراسة"),
                                SizedBox(height: 15.h),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "هل هو طالب؟",
                                      style: TextStyle(
                                        fontSize: 20..sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Switch(
                                      value: state.isStudent,
                                      onChanged: (val) => obj.checkStudent(val),
                                      activeColor: const Color(0xFF138086),
                                    ),
                                  ],
                                ),

                                if (state.isStudent) ...[
                                  CustomTextField(
                                    hint: "الكلية",
                                    icon: Icons.school_outlined,
                                    controller: obj.facultyController,
                                    validator: (value) {
                                      if (state.isStudent &&
                                          (value == null || value.isEmpty)) {
                                        return 'يرجى إدخال الكلية';
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomTextField(
                                    hint: "الجامعة",
                                    icon: Icons.school_outlined,
                                    controller: obj.universityController,
                                    validator: (value) {
                                      if (state.isStudent &&
                                          (value == null || value.isEmpty)) {
                                        return 'يرجى إدخال الجامعة';
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomDropdownField(
                                    hint: "الفرقة الدراسية",
                                    icon: Icons.person_add_alt,
                                    items: obj.levels,
                                    selectedValue: state.selectedLevel,
                                    onChanged: (val) => obj.selectLevel(val!),
                                    // إضافة الـ validator هنا
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى اختيار الفرقة الدراسية';
                                      }
                                      return null;
                                    },
                                  ),
                                ],

                                const SectionTitle(title: "ملاحظات"),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  hint: "ملاحظات إضافية...",
                                  icon: CupertinoIcons.doc_text,
                                  maxLines: 5,
                                  controller: obj.notesController,
                                ),

                                SizedBox(height: 30.h),

                                SizedBox(
                                  width: double.infinity,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final hasConnection =
                                          await checkConnection(context);
                                      if (!hasConnection) return;
                                      if (_formKey.currentState!.validate()) {
                                        final cubit = context
                                            .read<AddMemberCubit>();
                                        if (isEditing) {
                                          cubit.editMember(
                                            memberId: member!.id!,
                                          );
                                        } else {
                                          cubit.addMember(); // ✅ Add
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF138086),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      isEditing ? "تعديل العضو" : "حفظ العضو",
                                      style: TextStyle(
                                        fontSize: 18..sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
