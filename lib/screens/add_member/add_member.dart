import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors.dart';
import 'widgets/custom_dropdown_field.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/gender_button.dart';
import 'widgets/section_title.dart';
import 'widgets/top_section_add_member.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  AddMemberScreenState createState() => AddMemberScreenState();
}

class AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool isStudent = true;
  String gender = 'ذكر';
  String? selectedLevel;

  final List<String> levels = [
    'الفرقة الأولى',
    'الفرقة الثانية',
    'الفرقة الثالثة',
    'الفرقة الرابعة',
    'الفرقة الخامسة',
    'الفرقة السادسة',
    'الفرقة السابعة',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _facultyController.dispose();
    _universityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          const TopSectionAddMember(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: "البيانات الأساسية"),
                      SizedBox(height: 15.h),
                      CustomTextField(
                        hint: "الاسم الثلاثي",
                        icon: CupertinoIcons.person,
                        controller: _nameController,
                      ),
                      CustomTextField(
                        hint: "رقم التليفون",
                        icon: CupertinoIcons.phone,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      CustomTextField(
                        hint: "العمر",
                        icon: CupertinoIcons.number,
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          GenderButton(
                            label: "ذكر",
                            isSelected: gender == "ذكر",
                            onTap: () => setState(() => gender = "ذكر"),
                          ),
                          SizedBox(width: 10.w),
                          GenderButton(
                            label: "أنثى",
                            isSelected: gender == "أنثى",
                            onTap: () => setState(() => gender = "أنثى"),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),
                      const SectionTitle(title: "تفاصيل الدراسة"),
                      SizedBox(height: 15.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "هل هو طالب؟",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          Switch(
                            value: isStudent,
                            onChanged: (val) => setState(() => isStudent = val),
                            activeColor: const Color(0xFF138086),
                          ),
                        ],
                      ),

                      if (isStudent) ...[
                        CustomTextField(
                          hint: "الكلية",
                          icon: Icons.school_outlined,
                          controller: _facultyController,
                        ),
                        CustomTextField(
                          hint: "الجامعة",
                          icon: Icons.school_outlined,
                          controller: _universityController,
                        ),
                        CustomDropdownField(
                          hint: "الفرقة الدراسية",
                          icon: Icons.person_add_alt,
                          items: levels,
                          selectedValue: selectedLevel,
                          onChanged: (val) =>
                              setState(() => selectedLevel = val),
                        ),
                      ],

                      const SectionTitle(title: "ملاحظات"),
                      SizedBox(height: 15.h),
                      CustomTextField(
                        hint: "ملاحظات إضافية...",
                        icon: CupertinoIcons.doc_text,
                        maxLines: 5,
                        controller: _notesController,
                      ),

                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () {
                            print("Name: ${_nameController.text}");
                            print("Level: $selectedLevel");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF138086),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Text(
                            "حفظ العضو",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
