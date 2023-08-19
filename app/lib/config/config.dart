import 'dart:convert';

import 'package:tadllal/model/api_molels/user.dart';
import 'package:tadllal/services/storage_service.dart';

class Config {
  static var configContainer = StorageService().getHiveBox('config');

  bool get isLoggedIn => configContainer.get(
        'isLoggedIn',
        defaultValue: false,
      );
  bool get starterHasShown => configContainer.get(
        'starterHasShown',
        defaultValue: false,
      );

  // Map<String,dynamic> get user =>configContainer.get('user' ,defaultValue: <String,dynamic>{});
  User get user {
    User user = User.fromJson(
        json.decode(configContainer.get('user', defaultValue: "")));
    return user;
  }

  String get token => configContainer.get('token', defaultValue: "") ?? "";
  String get userImage => configContainer.get('user_image', defaultValue: "");

  String? get baseUrl => configContainer.get('baseUrl');

  Uri? get uri {
    if (baseUrl == null) return null;
    return Uri.parse(baseUrl!);
  }

  static Future set(String k, dynamic v) async {
    configContainer.put(k, v);
  }

  static Future clear() async {
    configContainer.clear();
  }

  static Future remove(String k) async {
    configContainer.delete(k);
    configContainer.deleteFromDisk();
  }

  static Future deleteAll() async {
    configContainer.deleteFromDisk();
  }
}
