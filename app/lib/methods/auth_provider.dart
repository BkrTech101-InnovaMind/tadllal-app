import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// API endpoint URL
const endpointUrl = 'http://10.0.2.2:8000/api/app';

// API endpoints
const signUpEndpoint = '/register';
const signInEndpoint = '/login';
const signOutEndpoint = '/logout';
const userProfileEndpoint = '/user';

// Initialize Dio instance for API requests
class AuthProvider {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Options _headers() {
    return Options(
      contentType: 'application/json',
      responseType: ResponseType.json,
    );
  }

// Post requests method
  Future<Response> postRequest({
    required String route,
    required Map<String, dynamic> data,
  }) async {
    String url = endpointUrl + route;
    return await _dio.post(url, data: jsonEncode(data), options: _headers());
  }

  // Save access token method
  Future<void> saveAccessToken({required String token}) async {
    String key = token;
    return await _secureStorage.write(key: 'token', value: key);
  }

  // Get access token method
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'token');
  }

  //sign up method
  Future<Response> signUp({required Map<String, dynamic> data}) async {
    Map<String, dynamic> signUpData = data;
    return await postRequest(route: signUpEndpoint, data: signUpData);
  }

  //sign in method
  Future<Response> signIn({required Map<String, dynamic> data}) async {
    Map<String, dynamic> signInData = data;
    return await postRequest(route: signInEndpoint, data: signInData);
  }

  // sign out method
  Future<void> signOut() async {
    await _secureStorage.delete(key: 'token');
    return;
  }
}
