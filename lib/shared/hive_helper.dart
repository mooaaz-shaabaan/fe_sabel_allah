import 'package:hive_ce_flutter/hive_ce_flutter.dart'; // ✅ بدل hive_ce

import '../model/user_model.dart';

class HiveHelper {
  static const String userBox = 'userBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>(userBox);
  }
}
