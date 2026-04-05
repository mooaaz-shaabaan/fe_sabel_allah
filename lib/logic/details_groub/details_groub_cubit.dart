import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/card_model.dart';
import 'details_groub_state.dart';

class DetailsGroubCubit extends Cubit<DetailsGroubState> {
  // بنمرر القائمة في أول حالة (Initial)
  DetailsGroubCubit()
    : super(DetailsGroubInitial(currentIndex: 0, members: _initialMembers));

  // خلي اللستة static أو كمتغير داخلي عشان تحافظ على البيانات
  static final List<MembersModel> _initialMembers = [
    MembersModel(
      name: 'محمد عبد الجميل',
      age: '22',
      isStudent: true,
      photo: 'assets/islamic_avatar/6.png',
      phone: '01271134724',
      notes: '',
      khareg: false,
    ),
  ];

  void toggleKhareg(int index) {
    // 1. بناخد نسخة جديدة من الليستة عشان نعدل فيها
    List<MembersModel> updatedMembers = List.from(state.members);

    // 2. بنستبدل العنصر اللي اتعدل بـ Object جديد تماماً ببيانات متغيرة
    updatedMembers[index] = updatedMembers[index].copyWith(
      khareg: !updatedMembers[index].khareg,
    );

    // 3. بنعمل emit للـ State باللستة اللي فيها الـ Object الجديد
    emit(
      DetailsGroubInitial(
        currentIndex: state.currentIndex,
        members: updatedMembers,
      ),
    );
  }

  // تحديث الـ Index مع الحفاظ على القائمة
  void updateIndex(int index) {
    emit(
      DetailsGroubInitial(
        currentIndex: index,
        members: state.members, // لازم نبعت الـ members عشان متختفيش
      ),
    );
  }

  void acctionFAB({required int currentIndex}) {
    // في كل الحالات بنبعت الـ members الحالية عشان الـ UI ميفضاش
    if (currentIndex == 0) {
      emit(
        NavigateToAddMemberState(
          currentIndex: currentIndex,
          members: state.members,
        ),
      );
      emit(
        DetailsGroubInitial(currentIndex: currentIndex, members: state.members),
      );
    } else if (currentIndex == 1) {
      emit(
        NavigateToAddVisitState(
          currentIndex: currentIndex,
          members: state.members,
        ),
      );
      emit(
        DetailsGroubInitial(currentIndex: currentIndex, members: state.members),
      );
    } else if (currentIndex == 2) {
      emit(
        NavigateToAddKhrojState(
          currentIndex: currentIndex,
          members: state.members,
        ),
      );
      emit(
        DetailsGroubInitial(currentIndex: currentIndex, members: state.members),
      );
    }
  }
}
