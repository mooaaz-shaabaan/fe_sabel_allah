import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../details_groub/details_groub_cubit.dart';
import 'add_khrog_and_visit_state.dart';

class AddKhrogCubit extends Cubit<AddKhrogState> {
  final DetailsGroubCubit? detailsGroubCubit;
  StreamSubscription? _detailsSubscription;

  AddKhrogCubit({this.detailsGroubCubit})
    : super(AddKhrogState(members: detailsGroubCubit?.state.members ?? [])) {
    _detailsSubscription = detailsGroubCubit?.stream.listen((detailsState) {
      if (!isClosed) {
        emit(state.copyWith(members: detailsState.members));
      }
    });
  }

  bool _isProcessing = false; // ✅ Flag مستقل - بيتغير فوراً مش زي الـ State

  void selectMember(int index) {
    if (index >= 0 && index < state.members.length) {
      emit(
        state.copyWith(
          selectedMemberIndex: index,
          selectedMember: state.members[index],
          errorMessage: null,
        ),
      );
    }
  }

  void searchMember(String query) {
    detailsGroubCubit?.searchMember(query);
  }

  void enableDate(bool value) {
    emit(state.copyWith(isDateEnabled: value, selectedDate: null));
  }

  void updateIndex(int index) {
    const durations = {0: 120, 1: 40, 2: 3};
    const labels = {0: '٤ شهور', 1: '٤٠ يوم', 2: '٣ أيام'};

    emit(
      state.copyWith(
        selectedIndex: index,
        selctedModa: labels[index],
        durationDays: durations[index],
      ),
    );
  }

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<bool> confirmKhroug() async {
    if (_isProcessing) return false;
    _isProcessing = true;

    try {
      if (state.selectedMember == null) {
        emit(state.copyWith(errorMessage: 'من فضلك اختار عضو أولاً'));
        return false;
      }

      if (state.isDateEnabled && state.selectedDate == null) {
        emit(state.copyWith(errorMessage: 'برجاء تحديد تاريخ الخروج'));
        return false;
      }

      final DateTime startDateTime = state.selectedDate ?? DateTime.now();
      final String startDate =
          '${startDateTime.day}/${startDateTime.month}/${startDateTime.year}';

      if (state.selectedMember!.allTimeKhroug != null &&
          state.selectedMember!.allTimeKhroug!.contains(startDate)) {
        emit(
          state.copyWith(
            errorMessage: 'هذا التاريخ تم تسجيل خروج فيه من قبل لهذا العضو',
          ),
        );
        return false;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null));

      await detailsGroubCubit?.addKhroug(
        // ✅ addKhroug مش addVisit
        member: state.selectedMember!,
        startDate: startDate, // ✅ المتغير الصح
        durationDays: state.durationDays,
      );

      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'حدث خطأ أثناء التسجيل، حاول مرة أخرى',
        ),
      );
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> confirmVisit() async {
    if (_isProcessing) return false;
    _isProcessing = true;

    try {
      if (state.selectedMember == null) {
        emit(state.copyWith(errorMessage: 'من فضلك اختار عضو أولاً'));
        return false;
      }

      if (state.isDateEnabled && state.selectedDate == null) {
        emit(state.copyWith(errorMessage: 'برجاء تحديد تاريخ الزيارة'));
        return false;
      }

      final DateTime visitDateTime = state.selectedDate ?? DateTime.now();
      final String visitDateString =
          '${visitDateTime.day}/${visitDateTime.month}/${visitDateTime.year}';

      if (state.selectedMember!.allTimeVisted != null &&
          state.selectedMember!.allTimeVisted!.contains(visitDateString)) {
        emit(
          state.copyWith(
            errorMessage: 'هذا التاريخ تم تسجيل زيارة فيه من قبل لهذا العضو',
          ),
        );
        return false;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null));

      await detailsGroubCubit?.addVisit(
        // ✅ بيبعت العضو الأصلي بس
        member: state.selectedMember!,
        visitDate: visitDateString,
      );

      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'حدث خطأ أثناء تسجيل الزيارة، حاول مرة أخرى',
        ),
      );
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Future<void> close() {
    _detailsSubscription?.cancel();
    return super.close();
  }
}
