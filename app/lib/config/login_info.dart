import 'dart:convert';

import 'package:tadllal/config/global.dart';
import 'package:tadllal/services/storage_service.dart';


class LoginInfo{

  static var loginInfoContainer = StorageService().getHiveBox('login_info');


  String? get login_info => loginInfoContainer.get(LOGIN_INFO_KEY_NAME ,defaultValue:json.encode({USERNAME:"",PASSWORD:""}) );

  int? get version => loginInfoContainer.get(APP_VERSION_KEY_NAME,defaultValue: 0);


  static Future set_USERNAME_PASSWORD({ required String user_name, required String password}) async {

    Map<String,String> login_info={USERNAME:user_name,PASSWORD:password};

    loginInfoContainer.put(LOGIN_INFO_KEY_NAME, json.encode(login_info));
  }
  static Future set(String k, dynamic v) async {
    loginInfoContainer.put(k, v);
  }
  static Future clear() async {
    loginInfoContainer.clear();
  }
}