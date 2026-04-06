import 'package:equatable/equatable.dart';
import '../../model/member_model.dart';
import '../../model/user_model.dart';

class DetailsGroubState extends Equatable {
  final int currentIndex;
  final List<MembersModel> members;
  final String gender;
  final bool isStudent;
  final String? selectedLevel;
  final String? navigateTo;
  final bool isLoading;
  final String? errorMessage;
  final List<UserModel> pendingRequests;

  const DetailsGroubState({
    this.currentIndex = 0,
    this.members = const [],
    this.gender = 'ذكر',
    this.isStudent = true,
    this.selectedLevel,
    this.navigateTo,
    this.isLoading = false,
    this.errorMessage,
    this.pendingRequests = const [], // ✅ صح
  });

  DetailsGroubState copyWith({
    int? currentIndex,
    List<MembersModel>? members,
    String? gender,
    bool? isStudent,
    String? selectedLevel,
    String? navigateTo,
    bool? isLoading,
    String? errorMessage,
    List<UserModel>? pendingRequests, // ✅ محتاج تضيفها هنا
  }) {
    return DetailsGroubState(
      currentIndex: currentIndex ?? this.currentIndex,
      members: members ?? this.members,
      gender: gender ?? this.gender,
      isStudent: isStudent ?? this.isStudent,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      navigateTo: navigateTo,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingRequests:
          pendingRequests ?? this.pendingRequests, // ✅ محتاج تضيفها هنا
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
    isLoading,
    errorMessage,
    pendingRequests,
  ];
}
