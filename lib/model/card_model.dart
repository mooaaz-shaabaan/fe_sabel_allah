class MembersModel {
  final String name;
  final String age;
  final String phone;
  final bool isStudent;
  final bool khareg; // خليناها final عشان نضمن الـ Immutability
  final String photo;
  final String notes;

  MembersModel({
    required this.name,
    required this.age,
    required this.isStudent,
    required this.photo,
    required this.phone,
    required this.notes,
    required this.khareg,
  });

  // الميثود دي هي اللي هتحل المشكلة
  MembersModel copyWith({
    String? name,
    String? age,
    String? phone,
    bool? isStudent,
    bool? khareg,
    String? photo,
    String? notes,
  }) {
    return MembersModel(
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      isStudent: isStudent ?? this.isStudent,
      khareg: khareg ?? this.khareg,
      photo: photo ?? this.photo,
      notes: notes ?? this.notes,
    );
  }
}