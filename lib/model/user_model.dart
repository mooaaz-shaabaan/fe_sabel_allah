import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive_ce.dart'; // ✅ صلح الـ import

part 'user_model.g.dart'; // ✅ زود السطر ده

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      name: 'بالأحباب',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }
}
