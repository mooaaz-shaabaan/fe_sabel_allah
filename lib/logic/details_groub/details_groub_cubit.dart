import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/member_model.dart';
import '../../model/user_model.dart';
import 'details_groub_state.dart';

class DetailsGroubCubit extends Cubit<DetailsGroubState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String groupId;

  List<MembersModel> _allMembers = [];
  StreamSubscription? _membersSubscription;
  final TextEditingController searchController = TextEditingController();

  DetailsGroubCubit({required this.groupId})
    : super(const DetailsGroubState(members: [])) {
    getMembers();
  }

  // ─── getter مركزي للـ collection — غيّر الاسم هنا بس لو احتجت ──
  CollectionReference get _membersCollection =>
      _firestore.collection('groups').doc(groupId).collection('manual_user');

  CollectionReference get membersCollection => _membersCollection;

  // ─── جلب الأعضاء عبر Stream ────────────────────────────────────────────────
  void getMembers() {
    _membersSubscription = _membersCollection.snapshots().listen((snapshot) {
      _allMembers = snapshot.docs.map((doc) {
        return MembersModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // تحقق تلقائي من انتهاء مدة الخروج عند كل تحديث
      for (final member in _allMembers) {
        _checkAndAutoResetKhroug(member);
      }

      _applySearchAndEmit();
    });
  }

  // ─── تبديل حالة "خارج" يدوياً ─────────────────────────────────────────────
  Future<void> toggleKhareg(MembersModel member) async {
    try {
      await _membersCollection.doc(member.id).update({
        'khareg': !member.khareg,
      });
    } catch (e) {
      debugPrint("Error toggling khareg: $e");
    }
  }

  // ─── تسجيل خروج جديد ──────────────────────────────────────────────────────
  Future<void> addKhroug({
    required MembersModel member,
    required String startDate,
    required int durationDays,
  }) async {
    try {
      final DateTime endDate = DateTime.now().add(Duration(days: durationDays));

      final updatedList = List<String>.from(member.allTimeKhroug ?? [])
        ..add(startDate);

      await _membersCollection.doc(member.id).update({
        'khareg': true,
        'lastKhroug': startDate,
        'allTimeKhroug': updatedList,
        'khrougEndDate': Timestamp.fromDate(endDate),
      });
    } catch (e) {
      debugPrint("Error adding khroug: $e");
    }
  }

  // ─── تسجيل زيارة جديدة ────────────────────────────────────────────────────
  Future<void> addVisit({
    required MembersModel member,
    required String visitDate,
  }) async {
    try {
      final updatedList = List<String>.from(member.allTimeVisted ?? [])
        ..add(visitDate);

      await _membersCollection.doc(member.id).update({
        'lastVisted': visitDate,
        'allTimeVisted': updatedList,
      });
    } catch (e) {
      debugPrint("Error adding visit: $e");
    }
  }

  // ─── reset تلقائي لو انتهت مدة الخروج ────────────────────────────────────
  Future<void> _checkAndAutoResetKhroug(MembersModel member) async {
    if (member.khareg &&
        member.khrougEndDate != null &&
        DateTime.now().isAfter(member.khrougEndDate!)) {
      await _membersCollection.doc(member.id).update({'khareg': false});
    }
  }

  // ─── منطق البحث ───────────────────────────────────────────────────────────
  void searchMember(String query) {
    _applySearchAndEmit(query: query);
  }

  void _applySearchAndEmit({String? query}) {
    final searchQuery = query ?? searchController.text;

    final filtered = searchQuery.isEmpty
        ? List<MembersModel>.from(_allMembers)
        : _allMembers.where((member) {
            final name = member.name.toLowerCase();
            final phone = member.phone;
            final q = searchQuery.toLowerCase();
            return name.contains(q) || phone.contains(q);
          }).toList();

    emit(state.copyWith(members: filtered));
  }

  // ─── التحكم في التبويبات والتنقل ─────────────────────────────────────────
  void updateIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void actionFAB() {
    final routes = {0: 'addMember', 1: 'addVisit', 2: 'addKhroj'};
    final route = routes[state.currentIndex];
    if (route != null) {
      emit(state.copyWith(navigateTo: route));
    }
  }

  void clearNavigation() {
    emit(state.copyWith(navigateTo: null));
  }

  // ─── خدمات الاتصال ─────────────────────────────────────────────────────────
  Future<void> openWhatsApp(String phoneNumber) async {
    final url =
        'https://wa.me/2$phoneNumber?text=${Uri.encodeComponent("السلام عليكم ورحمة الله وبركاته")}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ─── جلب طلبات الأنضمام ────────────────────────────────────────────────────
  Future<void> getPendingRequests() async {
    try {
      emit(state.copyWith(isLoading: true));

      final snapshot = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('pendingRequests')
          .get();

      final pendingUsers = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      emit(state.copyWith(isLoading: false, pendingRequests: pendingUsers));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: "فشل في جلب الطلبات"),
      );
    }
  }

  // ─── قبول طلب الانضمام ─────────────────────────────────────────────────────
  Future<void> approveRequest({required UserModel user}) async {
    try {
      WriteBatch batch = _firestore.batch();

      final groupRef = _firestore.collection('groups').doc(groupId);

      // 1. شيله من waitingList وضيفه في allParticipants
      batch.update(groupRef, {
        'waitingList': FieldValue.arrayRemove([user.id]),
        'allParticipants': FieldValue.arrayUnion([user.id]),
      });

      // 2. ضيفه في active_users
      batch.set(groupRef.collection('active_users').doc(user.id), {
        ...user.toMap(),
        'role': 'member',
        'joinDate': FieldValue.serverTimestamp(),
      });

      // 3. احذف الطلب من pendingRequests
      batch.delete(groupRef.collection('pendingRequests').doc(user.id));

      await batch.commit();

      // رفرش الـ pending list بعد القبول
      await getPendingRequests();
    } catch (e) {
      emit(state.copyWith(errorMessage: "فشل في قبول الطلب"));
    }
  }

  // ─── رفض طلب الانضمام ──────────────────────────────────────────────────────
  Future<void> rejectRequest({required UserModel user}) async {
    try {
      WriteBatch batch = _firestore.batch();

      final groupRef = _firestore.collection('groups').doc(groupId);

      // 1. شيله من waitingList
      batch.update(groupRef, {
        'allParticipants': FieldValue.arrayRemove([user.id]),
        'waitingList': FieldValue.arrayRemove([user.id]),
      });

      // 2. احذف الطلب من pendingRequests
      batch.delete(groupRef.collection('pendingRequests').doc(user.id));

      await batch.commit();

      // رفرش الـ pending list بعد الرفض
      await getPendingRequests();
    } catch (e) {
      emit(state.copyWith(errorMessage: "فشل في رفض الطلب"));
    }
  }

  // دالة مخصصة للـ Refresh Indicator
  Future<void> fetchMembers() async {
    try {
      // بما أنك تستخدم Stream، يمكنك ببساطة إعادة استدعاء getMembers
      // أو جلب البيانات لمرة واحدة (Future) لضمان انتهاء علامة التحميل
      final snapshot = await _membersCollection.get();
      _allMembers = snapshot.docs.map((doc) {
        return MembersModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      for (final member in _allMembers) {
        _checkAndAutoResetKhroug(member);
      }

      _applySearchAndEmit();
    } catch (e) {
      debugPrint("Error fetching members: $e");
    }
  }

  // ─── حساب اخر زيارة ───────────────────────────────────────────────────────
  Future<int> calculateDaysSinceLastVisit({
    required String groupId,
    required String memberId,
  }) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('manual_user')
          .doc(memberId)
          .get();

      // لو مفيش document أو مفيش data
      if (!doc.exists || doc.data() == null) return -1;

      var data = doc.data() as Map<String, dynamic>;

      // لو مفيش حقل lastVisted أو فاضي
      if (data['lastVisted'] == null || data['lastVisted'].toString().isEmpty)
        return -1;

      var lastVisitedData = data['lastVisted'];
      DateTime lastVisitDate;

      if (lastVisitedData is Timestamp) {
        lastVisitDate = lastVisitedData.toDate();
      } else if (lastVisitedData is String) {
        try {
          lastVisitDate = DateTime.parse(lastVisitedData);
        } catch (e) {
          List<String> dateParts = lastVisitedData.split('/');
          if (dateParts.length == 3) {
            lastVisitDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
          } else {
            return -1;
          }
        }
      } else {
        return -1;
      }

      DateTime today = DateTime.now();

      DateTime normalizedLastVisit = DateTime(
        lastVisitDate.year,
        lastVisitDate.month,
        lastVisitDate.day,
      );
      DateTime normalizedToday = DateTime(today.year, today.month, today.day);

      return normalizedToday.difference(normalizedLastVisit).inDays;
    } catch (e) {
      debugPrint("Error calculating days: $e");
      return -1;
    }
  }

  // ─── تنظيف الموارد ───────────────────────────────────────────
  @override
  Future<void> close() {
    _membersSubscription?.cancel();
    searchController.dispose();
    return super.close();
  }
}
