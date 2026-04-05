import 'package:equatable/equatable.dart';
import '../../model/card_model.dart';

abstract class DetailsGroubState extends Equatable {
  final int currentIndex;
  final List<MembersModel> members;

  const DetailsGroubState({required this.currentIndex, required this.members});

  @override
  // ضفنا الـ members هنا عشان الـ Bloc يعرف يعيد بناء الـ UI لما تتغير
  List<Object> get props => [currentIndex, members];
}

// الحالة العادية (تغيير التاب أو تحديث البيانات)
class DetailsGroubInitial extends DetailsGroubState {
  const DetailsGroubInitial({
    required super.currentIndex,
    required super.members,
  });
}

// حالات الـ Navigation
// بنمرر فيها الـ members دايماً عشان الشاشة متفقدش بياناتها أثناء التنقل
class NavigateToAddMemberState extends DetailsGroubState {
  const NavigateToAddMemberState({
    required super.currentIndex,
    required super.members,
  });
}

class NavigateToAddVisitState extends DetailsGroubState {
  const NavigateToAddVisitState({
    required super.currentIndex,
    required super.members,
  });
}

class NavigateToAddKhrojState extends DetailsGroubState {
  const NavigateToAddKhrojState({
    required super.currentIndex,
    required super.members,
  });
}




