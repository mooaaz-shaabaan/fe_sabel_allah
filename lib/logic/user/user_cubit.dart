import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/user_model.dart';
import '../../shared/user_local_storage.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final _firestore = FirebaseFirestore.instance;

  // ✅ جيب اليوزر من Local أولاً، لو مش موجود جيبه من Firestore
  Future<void> loadUser(String uid) async {
    try {
      // جرب Local الأول
      final localUser = UserLocalStorage.getUser();
      if (localUser != null) {
        emit(UserLoaded(localUser));
        return;
      }

      // لو مش موجود Local، جيبه من Firestore
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(UserError("User not found"));
        return;
      }

      final user = UserModel.fromMap(doc.data()!);
      await UserLocalStorage.saveUser(user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ✅ أبدّل اليوزر (لو اتعدل البروفايل مثلاً)
  Future<void> updateUser(UserModel user) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      await _firestore.collection('users').doc(currentUser.email).update({
        'name': user.name,
      });

      await UserLocalStorage.saveUser(user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ✅ امسح اليوزر عند الـ logout
  Future<void> clearUser() async {
    await UserLocalStorage.clearUser();
    emit(UserInitial());
  }
}
