import 'package:cloud_firestore/cloud_firestore.dart';

class MembersModel {
  String? id;
  String name;
  String age;
  String phone;
  bool isStudent;
  bool khareg;
  String photo;
  String notes;
  String gender;
  String? level;
  String? faculty; // ✅ جديد
  String? university; // ✅ جديد

  String? lastVisted;
  List<String>? allTimeVisted;
  String? lastKhroug;
  List<String>? allTimeKhroug;
  DateTime? khrougEndDate;

  // ✅ sentinel لحل مشكلة copyWith مع null
  static const Object _undefined = Object();

  MembersModel({
    this.id,
    required this.name,
    required this.age,
    required this.isStudent,
    required this.photo,
    required this.phone,
    required this.notes,
    required this.khareg,
    required this.gender,
    this.level,
    this.faculty,
    this.university,
    this.lastVisted,
    this.allTimeVisted,
    this.lastKhroug,
    this.allTimeKhroug,
    this.khrougEndDate,
  });

  factory MembersModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MembersModel(
      id: documentId,
      name: map['name'] ?? '',
      age: map['age'] ?? '',
      phone: map['phone'] ?? '',
      isStudent: map['isStudent'] ?? true,
      khareg: map['khareg'] ?? false,
      photo: map['photo'] ?? '',
      notes: map['notes'] ?? '',
      gender: map['gender'] ?? 'ذكر',
      level: map['level'],
      faculty: map['faculty'], // ✅
      university: map['university'], // ✅
      lastVisted: map['lastVisted'],
      allTimeVisted: List<String>.from(map['allTimeVisted'] ?? []),
      lastKhroug: map['lastKhroug'],
      allTimeKhroug: List<String>.from(map['allTimeKhroug'] ?? []),
      khrougEndDate: map['khrougEndDate'] != null
          ? (map['khrougEndDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'phone': phone,
      'isStudent': isStudent,
      'khareg': khareg,
      'photo': photo,
      'notes': notes,
      'gender': gender,
      'level': level,
      'faculty': faculty, // ✅
      'university': university, // ✅
      'lastVisted': lastVisted,
      'allTimeVisted': allTimeVisted,
      'lastKhroug': lastKhroug,
      'allTimeKhroug': allTimeKhroug,
      'khrougEndDate': khrougEndDate != null
          ? Timestamp.fromDate(khrougEndDate!)
          : null,
    };
  }

  MembersModel copyWith({
    String? id,
    String? name,
    String? age,
    String? phone,
    bool? isStudent,
    bool? khareg,
    String? photo,
    String? notes,
    String? gender,
    Object? level = _undefined, // ✅ يقبل null حقيقي
    Object? faculty = _undefined, // ✅
    Object? university = _undefined, // ✅
    String? lastVisted,
    List<String>? allTimeVisted,
    String? lastKhroug,
    List<String>? allTimeKhroug,
    DateTime? khrougEndDate,
  }) {
    return MembersModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      isStudent: isStudent ?? this.isStudent,
      khareg: khareg ?? this.khareg,
      photo: photo ?? this.photo,
      notes: notes ?? this.notes,
      gender: gender ?? this.gender,
      level: level == _undefined ? this.level : level as String?, // ✅
      faculty: faculty == _undefined ? this.faculty : faculty as String?, // ✅
      university: university == _undefined
          ? this.university
          : university as String?, // ✅
      lastVisted: lastVisted ?? this.lastVisted,
      allTimeVisted: allTimeVisted ?? this.allTimeVisted,
      lastKhroug: lastKhroug ?? this.lastKhroug,
      allTimeKhroug: allTimeKhroug ?? this.allTimeKhroug,
      khrougEndDate: khrougEndDate ?? this.khrougEndDate,
    );
  }
}
 