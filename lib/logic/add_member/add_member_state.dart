import 'package:equatable/equatable.dart';
import '../../model/member_model.dart';


class AddMemberState extends Equatable {
  final int currentIndex;
  final List<MembersModel> members;
  final String gender;
  final bool isStudent;
  final String? selectedLevel;
  final String? navigateTo;

  const AddMemberState({
    this.currentIndex = 0,
    this.members = const [],
    this.gender = 'ذكر',
    this.isStudent = true,
    this.selectedLevel,
    this.navigateTo,
  });

  AddMemberState copyWith({
    int? currentIndex,
    List<MembersModel>? members,
    String? gender,
    bool? isStudent,
    String? selectedLevel,
    String? navigateTo,
  }) {
    return AddMemberState(
      currentIndex: currentIndex ?? this.currentIndex,
      members: members ?? this.members,
      gender: gender ?? this.gender,
      isStudent: isStudent ?? this.isStudent,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      navigateTo: navigateTo,
    );
  }

  @override
  List<Object?> get props => [
    currentIndex,
    members,
    gender,
    isStudent,
    selectedLevel,
    navigateTo,
  ];
}


