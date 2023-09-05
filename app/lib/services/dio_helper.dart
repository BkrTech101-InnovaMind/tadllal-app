import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tedllal/config/config.dart';

class DioHelper {
  static Dio? dio;
  static String? cookies;

  static Future init(String baseUrl) async {
    var cookieJar = await getCookiePath();
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api/app",
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )..interceptors.add(
        CookieManager(cookieJar),
      );
  }

  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath));
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    if (Config().uri != null) {
      var cookies = await cookieJar.loadForRequest(Config().uri!);

      var cookie = CookieManager.getCookies(cookies);
      return cookie;
    } else {
      return null;
    }
  }

  static Map<String, dynamic>? getAuthorizationHeader() {
    Map<String, dynamic> headers = {};
    String accessToken = Config().token;
    if (accessToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $accessToken";
    }

    return headers;
  }

  static Map<String, dynamic>? getRegesterHeader() {
    Map<String, dynamic> headers = {};

    headers["Content-Type"] = "application/vnd.api+json";

    // headers["Accept"]= "*/*";
    headers["Accept"] = "application/vnd.api+json";

    return headers;
  }
}
