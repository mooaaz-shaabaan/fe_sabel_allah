import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user_model.dart';
import '../../shared/user_local_storage.dart';
import '../user/user_cubit.dart';

part 'login_signup_state.dart';

class LoginSignupCubit extends Cubit<LoginSignupState> {
  final UserCubit userCubit;

  LoginSignupCubit({required this.userCubit}) : super(LoginSignupInitial());

  final _firestore = FirebaseFirestore.instance;

  // في إصدار 6.2.1 الـ Constructor ده شغال عادي جداً
 final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: kIsWeb 
      ? '507572063220-j88s99o8c5f7d9u3b71r7cp5q43q5nsj.apps.googleusercontent.com' 
      : null,
  serverClientId: !kIsWeb 
      ? '507572063220-j88s99o8c5f7d9u3b71r7cp5q43q5nsj.apps.googleusercontent.com' 
      : null,
);

  Future<void> _handleUser(UserCredential result) async {
    final user = UserModel.fromFirebaseUser(result.user!);
    final currentUser = FirebaseAuth.instance.currentUser!;

    await _firestore
        .collection('users')
        .doc(currentUser.email)
        .set(user.toMap(), SetOptions(merge: true));

    await userCubit.updateUser(user);
    await UserLocalStorage.saveUser(user);

    emit(LoginSuccess());
  }

  /// 🔥 Google Login
  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    try {
      // التأكد من تنظيف أي جلسة قديمة
      await _googleSignIn.signOut();

      // الميثود signIn() في الإصدار ده هتعرف عليها الـ IDE فوراً
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(LoginSignupInitial());
        return;
      }

      // الـ Getters (accessToken & idToken) هيرجعوا يشتغلوا عادي
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await _handleUser(result);
    } catch (e) {
      emit(LoginError("Google Error: ${e.toString()}"));
    }
  }

  /// 🔥 Facebook Login
  Future<void> signInWithFacebook() async {
    emit(LoginLoading());
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        try {
          // محاولة تسجيل الدخول العادية
          final UserCredential userResult = await FirebaseAuth.instance
              .signInWithCredential(credential);
          await _handleUser(userResult);
        } on FirebaseAuthException catch (e) {
          // لو الخطأ إن الحساب موجود قبل كدة بطريقة تانية
          if (e.code == 'account-exists-with-different-credential') {
            // هنا بنطلع رسالة للمستخدم يجيله تنبيه إنه مسجل بجوجل قبل كدة
            emit(
              const LoginError(
                "هذا الإيميل مسجل مسبقاً عن طريق جوجل، يرجى تسجيل الدخول بجوجل",
              ),
            );
          } else {
            emit(LoginError("Facebook Auth Error: ${e.message}"));
          }
        }
      } else if (result.status == LoginStatus.cancelled) {
        emit(LoginSignupInitial());
      } else {
        emit(LoginError("Facebook Error: ${result.message}"));
      }
    } catch (e) {
      emit(LoginError("Facebook Error: ${e.toString()}"));
    }
  }

  /// 🔥 Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await userCubit.clearUser();
      emit(LoginSignupInitial());
    } catch (e) {
      print("Logout error: $e");
    }
  }
}
