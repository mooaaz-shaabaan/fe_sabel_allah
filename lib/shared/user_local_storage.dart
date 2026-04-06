import 'package:hive_ce_flutter/hive_flutter.dart';
import '../model/user_model.dart';
import 'hive_helper.dart';

class UserLocalStorage {
  static Box<UserModel> get _box => Hive.box<UserModel>(HiveHelper.userBox);

  // ✅ حفظ اليوزر
  static Future<void> saveUser(UserModel user) async {
    await _box.put('current_user', user);
  }

  // ✅ جيب اليوزر
  static UserModel? getUser() {
    return _box.get('current_user');
  }

  // ✅ امسح اليوزر
  static Future<void> clearUser() async {
    await _box.delete('current_user');
  }
}
