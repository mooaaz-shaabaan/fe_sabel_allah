import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/groub_model.dart';
import '../../model/member_model.dart';
import '../../model/user_model.dart'; // تأكد من استيراد الـ UserModel
import '../../shared/user_local_storage.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserName;
  StreamSubscription? _groupsSubscription;
  List<GroupModel> _groups = [];

  HomeCubit() : super(HomeInitial()) {
    currentUserName = UserLocalStorage.getUser()?.name;
    getGroups();
  }

  // ضيف دي جوه HomeCubit

  void setUser(UserModel user) {
    UserLocalStorage.saveUser(user); // حفظ في Hive
    currentUserName = user.name; // تحديث الاسم في الـ Cubit
    emit(UpdateUserNameState(name: user.name)); // إرسال حالة تحديث الاسم
    emit(HomeLoaded(groups: _groups)); // إعادة عرض المجموعات بالاسم الجديد
  }

  // --- إدارة المجموعات ---

  void getGroups() {
    final uId = UserLocalStorage.getUser()?.id ?? '';
    if (uId.isEmpty) return;
    emit(HomeLoading());
    try {
      _groupsSubscription = _firestore
          .collection('groups')
          .where('allParticipants', arrayContains: uId)
          .snapshots()
          .listen(
            (snapshot) {
              _groups = snapshot.docs
                  .map((doc) => GroupModel.fromFirestore(doc))
                  .toList();
              emit(HomeLoaded(groups: _groups));
            },
            onError: (error) {
              emit(
                HomeError(message: "فشل في تحديث المجموعات", groups: _groups),
              );
            },
          );
    } catch (e) {
      emit(HomeError(message: "فشل في تحميل المجموعات", groups: _groups));
    }
  }

  Future<void> createGroup(String groupName) async {
    if (groupName.isEmpty) {
      emit(HomeError(message: "لازم تكتب اسم للمجموعة", groups: _groups));
      return;
    }
    try {
      String groupCode = _generateRandomCode(5);
      // جلب بيانات المستخدم كاملة من Hive
      final currentUserModel = UserLocalStorage.getUser();
      final currentUserId = currentUserModel?.id ?? '';

      final newGroup = GroupModel(
        id: '',
        groupName: groupName,
        groupCode: groupCode,
        adminName: currentUserModel?.name ?? 'أدمن',
        adminId: currentUserId,
        allParticipants: [currentUserId],
        waitingList: [],
        createdAt: DateTime.now(),
      );

      final groupRef = await _firestore
          .collection('groups')
          .add(newGroup.toMap());

      // إضافة الأدمن في active_users باستخدام الـ UserModel كامل
      if (currentUserModel != null) {
        await groupRef.collection('active_users').doc(currentUserId).set({
          ...currentUserModel.toMap(), // يرفع: id, name, email, photoUrl
          'role': 'admin',
          'joinDate': FieldValue.serverTimestamp(),
        });
      }

      emit(HomeSuccess(message: "تم إنشاء المجموعة بنجاح", groups: _groups));
    } catch (e) {
      emit(HomeError(message: "فشل في إنشاء المجموعة", groups: _groups));
    }
  }

  // --- التعامل مع الأعضاء النشطين (Active Users) ---

  Future<void> joinGroup(String code) async {
    if (code.isEmpty) {
      emit(HomeError(message: "دخل كود المجموعة الأول", groups: _groups));
      return;
    }

    try {
      // تنظيف الكود وتحويله لـ UpperCase للبحث بدقة
      final formattedCode = code.trim().toUpperCase();

      var result = await _firestore
          .collection('groups')
          .where('groupCode', isEqualTo: formattedCode)
          .get();

      if (result.docs.isEmpty) {
        emit(HomeError(message: "الكود ده غلط", groups: _groups));
        return;
      }

      final groupDoc = result.docs.first;
      final String groupId = groupDoc.id;
      final currentUser = UserLocalStorage.getUser();
      final String uId = currentUser?.id ?? '';

      if (uId.isEmpty) {
        emit(HomeError(message: "خطأ في بيانات المستخدم", groups: _groups));
        return;
      }

      // التحقق مما إذا كان المستخدم موجوداً بالفعل في المجموعة أو قائمة الانتظار
      List allParticipants = groupDoc.data()['allParticipants'] ?? [];
      List waitingList = groupDoc.data()['waitingList'] ?? [];

      if (allParticipants.contains(uId) || waitingList.contains(uId)) {
        emit(
          HomeError(
            message: "أنت موجود في هذه المجموعة أو أرسلت طلباً بالفعل",
            groups: _groups,
          ),
        );
        return;
      }

      // استخدام WriteBatch لضمان تنفيذ جميع العمليات معاً أو فشلها معاً
      WriteBatch batch = _firestore.batch();

      // 1. تحديث بيانات المجموعة الأساسية
      DocumentReference groupRef = _firestore.collection('groups').doc(groupId);
      batch.update(groupRef, {
        'waitingList': FieldValue.arrayUnion([uId]),
        'allParticipants': FieldValue.arrayUnion([uId]),
      });

      // 2. إضافة طلب الانضمام في الـ Sub-collection
      DocumentReference requestRef = groupRef
          .collection('pendingRequests')
          .doc(uId);

      batch.set(requestRef, {
        ...?currentUser?.toMap(),
        'status': 'pending',
        'requestDate': FieldValue.serverTimestamp(),
      });

      // تنفيذ العمليات
      await batch.commit();

      emit(
        HomeSuccess(
          message: "تم إرسال الطلب، استنى موافقة الأدمن",
          groups: _groups,
        ),
      );
    } catch (e) {
      print("Error joining group: $e"); // للدي باجنج
      emit(
        HomeError(
          message: "حصلت مشكلة في الانضمام: ${e.toString()}",
          groups: _groups,
        ),
      );
    }
  }

  Future<void> approveRequest({
    required String groupId,
    required UserModel user, // مررنا الـ UserModel بالكامل هنا
  }) async {
    try {
      // 1. شيله من الـ waitingList
      await _firestore.collection('groups').doc(groupId).update({
        'waitingList': FieldValue.arrayRemove([user.id]),
      });

      // 2. ضيفه في active_users ببياناته الكاملة
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('active_users')
          .doc(user.id)
          .set({
            ...user.toMap(),
            'role': 'member',
            'joinDate': FieldValue.serverTimestamp(),
          });

      // 3. احذف الطلب (المعرف هنا هو user.id)
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('pendingRequests')
          .doc(user.id)
          .delete();
    } catch (e) {
      emit(HomeError(message: "فشل في قبول الطلب", groups: _groups));
    }
  }

  // --- التعامل مع الأعضاء اليدويين (Manual Members) ---

  Future<void> addManualMember({
    required String groupId,
    required MembersModel member,
  }) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('manual_members')
          .add(member.toMap());

      emit(
        HomeSuccess(message: "تم إضافة العضو يدوياً بنجاح", groups: _groups),
      );
    } catch (e) {
      emit(HomeError(message: "فشل في إضافة العضو يدوياً", groups: _groups));
    }
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    return List.generate(
      length,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }
}
