import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tadllal/model/api_molels/error_response.dart';
import 'package:tadllal/model/api_molels/login_response.dart';
import 'package:tadllal/model/api_molels/sinin_sinup_request.dart';
import 'package:tadllal/services/dio_helper.dart';

class DioApi {
  Future<LoginResponse> sinIn(
      {required SinInSinUpRequest sinInSinUpRequest}) async {
    try {
      final response = await DioHelper.dio!.post(
        '/login',
        data: sinInSinUpRequest.toJson(),
        options: Options(validateStatus: (status) => status! < 500),
      );
      if (kDebugMode) {
        print("===================");
        print("Login response $response");
        print("===================");
        print("Login response Data ${response.data}");
        print("===================");
        print("Login response headers ${response.headers}");
        print("===================");
        print("Login response headers Map ${response.headers.map}");
        print("===================");
      }
      if (response.statusCode == HttpStatus.ok) {
        return LoginResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        throw ErrorResponse(
          statusMessage: "اسم المستخدم او كلمة المرور غير صحيحة",
          statusCode: response.statusCode,
        );
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    } on ErrorResponse {
      rethrow;
    } catch (e) {
      if (e is DioException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "السيرفر غير متوفر",
        );
      } else if (e is SocketException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: e.message,
        );
      } else if (e is HandshakeException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "Cannot connect securely to server."
              " Please ensure that the server has a valid SSL configuration.",
        );
      } else {
        throw ErrorResponse(
          statusCode: HttpStatus.conflict,
          statusMessage: "حدث خطاء",
        );
      }
    }
  }

  Future<LoginResponse> sinUp(
      {required SinInSinUpRequest sinInSinUpRequest}) async {
    bool showPrint = false;
    try {
      final response = await DioHelper.dio!.post(
        '/register',
        data: sinInSinUpRequest.toJson(),
        options: Options(receiveDataWhenStatusError: true),
      );

      if (kDebugMode) {
        print("===================\n");
        print("SinUP response $response");
      }
      if (response.statusCode == HttpStatus.ok) {
        if (kDebugMode && showPrint) {
          print("===================");
          print("SinUP response $response");
          print("===================");
          print("SinUP response Data ${response.data}");
          print("===================");
          print("SinUP response headers ${response.headers}");
          print("===================");
          print("SinUP response headers Map ${response.headers.map}");
          print("===================");
        }

        return LoginResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.found) {
        throw ErrorResponse(
          userMessage: "الحساب موجود مسبقا",
          statusCode: response.statusCode,
        );
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    } on ErrorResponse catch (e, s) {
      print("==========ErrorResponse=========\n");

      print('Exception details:\n ${e.statusMessage}');
      print('Stack trace:\n $s');
      // print("${e.userMessage}");
      rethrow;
    } on DioException catch (e) {
      print("==========DioException=========\n");

      if ((e.response != null) &&
          (e.response!.statusCode == HttpStatus.found)) {
        throw ErrorResponse(
          statusCode: e.response!.statusCode,
          statusMessage: "الحساب موجود مسبقا",
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ErrorResponse(
          statusCode: 0,
          statusMessage: "السيرفر غير متوفر"
              "",
        );
      } else {
        rethrow;
      }
    } on SocketException catch (e) {
      print("==========SocketException=========\n");
      throw ErrorResponse(
        statusCode: HttpStatus.serviceUnavailable,
        statusMessage: e.message,
      );
    } on HandshakeException {
      print("==========HandshakeException=========\n");
      throw ErrorResponse(
        statusCode: HttpStatus.serviceUnavailable,
        statusMessage: "Cannot connect securely to server."
            " Please ensure that the server has a valid SSL configuration.",
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postCodeAuthentication(String path,
      {dynamic myData, Map<String, dynamic>? queryParameters}) async {
    var response = await DioHelper.dio!.post(
      path,
      data: myData,
      queryParameters: queryParameters,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    return response;
  }

  Future<Response> post(String path,
      {dynamic myData,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Options requestOptions = options ??
        Options(
            // contentType: Headers.formUrlEncodedContentType,
            );
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = DioHelper.getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await DioHelper.dio!.post(path,
        data: myData,
        queryParameters: queryParameters,
        options: requestOptions);

    return response;
  }

  Future<Response> get(String path,
      {dynamic myData,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = DioHelper.getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await DioHelper.dio!.get(path,
        data: myData,
        queryParameters: queryParameters,
        options: requestOptions);
    return response;
  }

  Future<Response> delete(String path,
      {dynamic myData,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = DioHelper.getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    try {
      var response = await DioHelper.dio!.delete(path,
          data: myData,
          queryParameters: queryParameters,
          options: requestOptions);
      if (response.statusCode == HttpStatus.ok) {
        return response;
      } else {
        throw response.statusMessage!;
      }
    } catch (e) {
      rethrow;
    }
  }
}
