import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String groupName;
  final String groupCode;
  final String adminName;
  final String adminId;
  final int? memberCount;
  final DateTime? createdAt;

  // الحقول للتحكم في حالة الـ Pending والظهور في الـ Home
  final List<String> allParticipants;
  final List<String> waitingList;

  const GroupModel({
    required this.id,
    required this.groupName,
    required this.groupCode,
    required this.adminName,
    required this.adminId,
    required this.allParticipants,
    required this.waitingList,
    this.memberCount,
    this.createdAt,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // استخراج القوائم في متغيرات جانبية أولاً لضمان إمكانية الوصول للـ length
    final List<String> participants = List<String>.from(
      data['allParticipants'] ?? [],
    );
    final List<String> waiting = List<String>.from(data['waitingList'] ?? []);
    
    return GroupModel(
      id: doc.id,
      groupName: data['groupName'] ?? '',
      groupCode: data['groupCode'] ?? '',
      adminName: data['adminName'] ?? '',
      adminId: data['adminId'] ?? '',
      // حساب العدد مباشرة من طول القائمة المستخرجة
      memberCount: participants.length,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      allParticipants: participants,
      waitingList: waiting,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'groupCode': groupCode,
      'adminName': adminName,
      'adminId': adminId,
      // دايماً بنرفع طول اللستة الحالي لضمان دقة البيانات في Firestore
      'memberCount': allParticipants.length,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'allParticipants': allParticipants,
      'waitingList': waitingList,
    };
  }
}
