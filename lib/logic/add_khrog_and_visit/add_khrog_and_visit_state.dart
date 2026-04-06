import 'package:equatable/equatable.dart';

import '../../model/member_model.dart';

class AddKhrogState extends Equatable {
  final int selectedIndex;
  final int? selectedMemberIndex;
  final MembersModel? selectedMember;
  final String? selctedModa;
  final bool isDateEnabled;
  final List<MembersModel> members;
  final String gender;
  final bool isStudent;
  final String? selectedLevel;
  final String? navigateTo;
  final DateTime? selectedDate;
  final int durationDays; // ✅ جديد
  final String? errorMessage; // ✅ جديد
  final bool isLoading;

  const AddKhrogState({
    this.selectedIndex = 1,
    this.selectedMemberIndex,
    this.selectedMember,
    this.isDateEnabled = true,
    this.members = const [],
    this.gender = 'ذكر',
    this.isStudent = true,
    this.selectedLevel,
    this.navigateTo,
    this.selectedDate,
    this.selctedModa,
    this.durationDays = 40, // ✅ default: 40 يوم
    this.errorMessage, // ✅ جديد
    this.isLoading = false,
  });

  AddKhrogState copyWith({
    int? selectedIndex,
    int? selectedMemberIndex,
    MembersModel? selectedMember,
    bool? isDateEnabled,
    List<MembersModel>? members,
    String? gender,
    bool? isStudent,
    String? selectedLevel,
    String? navigateTo,
    DateTime? selectedDate,
    String? selctedModa,
    int? durationDays, // ✅ جديد
    String? errorMessage, // ✅ جديد
    bool? isLoading,
  }) {
    return AddKhrogState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      selectedMember: selectedMember ?? this.selectedMember,
      isDateEnabled: isDateEnabled ?? this.isDateEnabled,
      members: members ?? this.members,
      gender: gender ?? this.gender,
      isStudent: isStudent ?? this.isStudent,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      navigateTo: navigateTo,
      selectedDate: selectedDate ?? this.selectedDate,
      selctedModa: selctedModa ?? this.selctedModa,
      durationDays: durationDays ?? this.durationDays, // ✅ جديد
      errorMessage: errorMessage, // ✅ مش بنستخدم ?? عشان نقدر نمسحها
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    selectedMemberIndex,
    selectedMember,
    isDateEnabled,
    members,
    gender,
    isStudent,
    selectedLevel,
    navigateTo,
    selectedDate,
    selctedModa,
    durationDays, // ✅ جديد
    errorMessage, // ✅ جديد
    isLoading,
  ];
}
