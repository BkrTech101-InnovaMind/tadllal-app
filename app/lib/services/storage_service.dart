import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Box getHiveBox(String name) {
    return Hive.box(name);
  }

  Future<Box> initHiveBox(String name) {
    return Hive.openBox(name);
  }

  Future initHiveStorage() {
    return Hive.initFlutter();
  }

  putSharedPrefBoolValue(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> getSharedPrefBoolValue(String key) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getBool(key);
  }
}
