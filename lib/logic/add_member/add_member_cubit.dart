import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const/images.dart';
import '../../model/member_model.dart';
import '../details_groub/details_groub_cubit.dart';
import 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  final DetailsGroubCubit detailsGroubCubit;

  final String? name;
  final String? phone;
  final String? age;
  final String? faculty;
  final String? university;
  final String? notes;

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController ageController;
  late final TextEditingController facultyController;
  late final TextEditingController universityController;
  late final TextEditingController notesController;

  final _random = Random();

  AddMemberCubit({
    required this.detailsGroubCubit,
    this.name,
    this.phone,
    this.age,
    this.faculty,
    this.university,
    this.notes,
    String? gender, // ✅ جديد
    bool? isStudent, // ✅ جديد
    String? selectedLevel, // ✅ جديد
  }) : super(
         AddMemberState(
           members: detailsGroubCubit.state.members,
           gender: gender ?? 'ذكر', // ✅
           isStudent: isStudent ?? true, // ✅
           selectedLevel: selectedLevel, // ✅
         ),
       ) {
    nameController = TextEditingController(text: name);
    phoneController = TextEditingController(text: phone);
    ageController = TextEditingController(text: age);
    facultyController = TextEditingController(text: faculty);
    universityController = TextEditingController(text: university);
    notesController = TextEditingController(text: notes);
  }

  final List<String> levels = [
    'الفرقة الأولى',
    'الفرقة الثانية',
    'الفرقة الثالثة',
    'الفرقة الرابعة',
    'الفرقة الخامسة',
    'الفرقة السادسة',
    'الفرقة السابعة',
  ];

  final List<String> profilePhotos = [
    IslamicAvatar.avatar1,
    IslamicAvatar.avatar2,
    IslamicAvatar.avatar3,
    IslamicAvatar.avatar4,
    IslamicAvatar.avatar5,
    IslamicAvatar.avatar6,
    IslamicAvatar.avatar7,
    IslamicAvatar.avatar8,
    IslamicAvatar.avatar9,
    IslamicAvatar.avatar10,
    IslamicAvatar.avatar11,
    IslamicAvatar.avatar12,
    IslamicAvatar.avatar13,
    IslamicAvatar.avatar14,
    IslamicAvatar.avatar15,
  ];

  // دالة بتجيب صورة عشوائية كل ما تتنادى
  String getRandomPhoto() {
    return profilePhotos[_random.nextInt(profilePhotos.length)];
  }

  void selectGender(String value) => emit(state.copyWith(gender: value));
  void checkStudent(bool val) => emit(state.copyWith(isStudent: val));
  void selectLevel(String value) => emit(state.copyWith(selectedLevel: value));

  // ─── إضافة عضو جديد ──────────────────────────────────────────
  Future<void> addMember() async {
    try {
      final member = MembersModel(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        age: ageController.text.trim(),
        faculty: facultyController.text.trim(),
        university: universityController.text.trim(),
        notes: notesController.text.trim(),
        gender: state.gender,
        isStudent: state.isStudent,
        level: state.isStudent ? state.selectedLevel : null,
        photo: getRandomPhoto(), // ✅ موجود
        khareg: false, // ✅ ناقص — العضو الجديد مش خارج
      );

      await detailsGroubCubit.membersCollection.add(member.toMap());

      emit(state.copyWith(navigateTo: 'back'));
    } catch (e) {
      debugPrint("Error adding member: $e");
    }
  }

  // ─── تعديل عضو موجود ─────────────────────────────────────────
  Future<void> editMember({required String memberId}) async {
    try {
      await detailsGroubCubit.membersCollection.doc(memberId).update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'age': ageController.text.trim(),
        'faculty': facultyController.text.trim(),
        'university': universityController.text.trim(),
        'notes': notesController.text.trim(),
        'gender': state.gender,
        'isStudent': state.isStudent,
        'level': state.isStudent ? state.selectedLevel : null,
      });

      emit(state.copyWith(navigateTo: 'back'));
    } catch (e) {
      debugPrint("Error editing member: $e");
    }
  }

  // ─── حذف عضو ─────────────────────────────────────────────────
  Future<void> removeMember(String memberId) async {
    try {
      await detailsGroubCubit.membersCollection.doc(memberId).delete();
      emit(state.copyWith(navigateTo: 'back'));
    } catch (e) {
      debugPrint("Error removing member: $e");
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    facultyController.dispose();
    universityController.dispose();
    notesController.dispose();
    return super.close();
  }
}
