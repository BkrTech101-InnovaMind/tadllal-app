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
      if (response.statusCode == HttpStatus.ok) {
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

        return LoginResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is! DioException) rethrow;

      DioException error = e;
      if (error is SocketException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: error.message!,
        );
      }

      if (error is HandshakeException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "Cannot connect securely to server."
              " Please ensure that the server has a valid SSL configuration.",
        );
      }

      throw error;
    }
  }

  Future<LoginResponse> sinUp(
      {required SinInSinUpRequest sinInSinUpRequest}) async {
    try {
      final response = await DioHelper.dio!.post(
        '/register',
        data: sinInSinUpRequest.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        if (kDebugMode) {
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

        // var user=jsonEncode(response.data);

        return LoginResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusMessage: response.data["message"],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is! DioException) rethrow;

      DioException error = e;
      if (error is SocketException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: error.message!,
        );
      }

      if (error is HandshakeException) {
        throw ErrorResponse(
          statusCode: HttpStatus.serviceUnavailable,
          statusMessage: "Cannot connect securely to server."
              " Please ensure that the server has a valid SSL configuration.",
        );
      }
      throw ErrorResponse(statusMessage: error.message!);
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
    Options requestOptions = options ?? Options();
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
