// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// // Define the API endpoint URL
// const apiBaseUrl = 'http://127.0.0.1:8000/api/app'; //Laravel API host

// // Define the API endpoints
// const signUpEndpoint = '/register';
// const signInEndpoint = '/login';
// const signOutEndpoint = '/logout';
// const userProfileEndpoint = '/user';

// // Key for storing the access token in flutter_secure_storage
// const accessTokenKey = 'access_token';

// // Dio instance for API requests
// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio();
//   dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//   return dio;
// });

// // FlutterSecureStorage instance
// final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
//   return const FlutterSecureStorage();
// });

// // Auth Provider
// final authProvider = Provider<AuthenticationProvider>((ref) {
//   final dio = ref.read(dioProvider);
//   final secureStorage = ref.read(secureStorageProvider);
//   return AuthenticationProvider(dio, secureStorage);
// });

// class AuthenticationProvider {
//   final Dio dio;
//   final FlutterSecureStorage secureStorage;

//   AuthenticationProvider(this.dio, this.secureStorage);

//   // Helper method to get the access token
//   Future<String?> getAccessToken() async {
//     return await secureStorage.read(key: accessTokenKey);
//   }

//   // Helper method to save the access token
//   Future<void> saveAccessToken(String token) async {
//     await secureStorage.write(key: accessTokenKey, value: token);
//   }

//   // Sign up method
//   Future<bool> signUp(Map form) async {
//     try {
//       final response = await dio.post('$apiBaseUrl$signUpEndpoint', data: form);

//       if (response.statusCode == 200) {
//         final accessToken = response.data["data"]['token'];
//         await saveAccessToken(accessToken);
//         print(accessToken);
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print('Sign up error: $e');
//       return false;
//     }
//   }

//   // Sign in method
//   Future<bool> signIn(Map form) async {
//     try {
//       final response = await dio.post('$apiBaseUrl$signInEndpoint', data: form);

//       if (response.statusCode == 200) {
//         final accessToken = response.data['token'];
//         await saveAccessToken(accessToken);
//         print(form);
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print('Sign in error: $e');
//       return false;
//     }
//   }

//   // Sign out method
//   Future<void> signOut() async {
//     final accessToken = await getAccessToken();
//     try {
//       final response = await dio.post('$apiBaseUrl$signOutEndpoint',
//           options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

//       if (response.statusCode == 200) {
//         await secureStorage.delete(key: accessTokenKey);
//       } else {}
//     } catch (e) {
//       print('Sign out error: $e');
//     }
//   }

//   // Fetch user profile method
//   Future<Map<String, dynamic>> fetchUserProfile() async {
//     final accessToken = await getAccessToken();
//     try {
//       final response = await dio.get('$apiBaseUrl$userProfileEndpoint',
//           options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         throw Exception('Failed to fetch user profile');
//       }
//     } catch (e) {
//       print('Fetch user profile error: $e');
//       throw Exception('Failed to fetch user profile');
//     }
//   }
// }
