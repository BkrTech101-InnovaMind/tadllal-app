import 'dart:convert';

import 'package:tedllal/config/global.dart';
import 'package:tedllal/services/storage_service.dart';

class LoginInfo {
  static var loginInfoContainer = StorageService().getHiveBox('loginInfo');

  String? get loginInfo => loginInfoContainer.get(logInInfoKeyName,
      defaultValue: json.encode({userName: "", password: ""}));

  int? get version =>
      loginInfoContainer.get(appVersionKeyName, defaultValue: 0);

  static Future setUserNamePassword(
      {required String userName, required String password}) async {
    Map<String, String> loginInfo = {userName: userName, password: password};

    loginInfoContainer.put(logInInfoKeyName, json.encode(loginInfo));
  }

  static Future set(String k, dynamic v) async {
    loginInfoContainer.put(k, v);
  }

  static Future clear() async {
    loginInfoContainer.clear();
  }
}
