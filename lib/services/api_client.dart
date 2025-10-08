import 'package:dio/dio.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';

import 'api_exception.dart';
import 'header_manager.dart';
import 'response_handler.dart';

/// A client class that handles all the API requests using the Dio package.
/// This class provides methods for GET, POST, PUT, and DELETE requests, including support for file uploads.

class ApiClient {
  /// Base URL of the API.
  final String appBaseUrls = AppConstants.baseUrl;

  /// Dio instance for handling HTTP requests.
  final Dio _dio = Dio();

  /// Error message when there is no internet connection.
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';

  /// Timeout duration for API requests in seconds.
  final int timeoutInSeconds = 60;

  /// Constructor to initialize the Dio instance with timeout settings.
  ApiClient() {
    _dio.options.baseUrl = appBaseUrls;
    _dio.options.connectTimeout = Duration(seconds: timeoutInSeconds);
    _dio.options.receiveTimeout = Duration(seconds: timeoutInSeconds);
  }

  /// Sends a GET request to the specified [uri].
  ///
  /// [query] contains the query parameters to be sent with the request.
  /// [headers] allows custom headers to be provided.
  /// [customAppBaseUrl] allows overriding the base URL if needed.
  /// Returns a [Response] object containing the server's response.
  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? customAppBaseUrl,
  }) async {
    try {
      if (kDebugMode) {
        log('query $query');
        log('GET request URL: $uri');
      }

      final response = await _dio.get(
        uri,
        queryParameters: query,
        data: body,
        options: Options(
          headers:
              headers ??
              HeaderManager.getMainHeaders(BaseHelper.accessToken.value),
        ),
      );

      return ResponseHandler.handleResponse(response);
    } on DioException catch (error) {
      throw handleDioError(error); // 🔹 Reuse function
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error occurred.',
        details: error.toString(),
      );
    }
  }

  /// Sends a POST request to the specified [uri] with the provided [body].
  ///
  /// [headers] allows custom headers to be provided.
  /// [customAppBaseUrl] allows overriding the base URL if needed.
  /// [file] and [fileKey] are used for file upload if present.
  /// Returns a [Response] object containing the server's response.
  Future<Response> postData(
    String uri,
    Map<String, dynamic> body, {
    bool isFromData = false,
    Map<String, String>? headers,
    File? file,
    String? fileKey,
  }) async {
    try {
      if (kDebugMode) {
        log('POST request URL: ${_dio.options.baseUrl}$uri');
        log('POST request Body: $body');
      }

      Options options = Options(
        headers:
            headers ??
            HeaderManager.getMainHeaders(BaseHelper.accessToken.value),
      );
      Response response;

      if (file != null && fileKey != null) {
        // If a file is provided, use FormData for multipart request
        FormData formData = FormData.fromMap({
          ...body,
          fileKey: await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        });
        response = await _dio.post(uri, data: formData, options: options);
      } else {
        // Otherwise, send the body as JSON
        response = await _dio.post(
          uri,
          data: isFromData ? FormData.fromMap({...body}) : body,
          options: options,
        );
      }

      return ResponseHandler.handleResponse(response);
    } on DioException catch (error) {
      throw handleDioError(error); // 🔹 Reuse function
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error occurred.',
        details: error.toString(),
      );
    }
  }

  /// Sends a POST request with [FormData] to the specified [uri].
  ///
  /// [formData] is used for sending multipart form data.
  /// [headers] allows custom headers to be provided.
  /// [customAppBaseUrl] allows overriding the base URL if needed.
  /// Returns a [Response] object containing the server's response.
  Future<Response> postFormData(
    String uri,
    FormData formData, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        log('POST FormData request URL: $uri');
        log('POST FormData request Body: $formData');
      }

      final response = await _dio.post(
        uri,
        data: formData,
        options: Options(
          headers:
              headers ??
              HeaderManager.getMainHeaders(BaseHelper.accessToken.value),
        ),
        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            log('Upload Progress: $sent / $total');
          }
        },
      );

      return ResponseHandler.handleResponse(response);
    } on DioException catch (error) {
      throw handleDioError(error); // 🔹 Reuse function
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error occurred.',
        details: error.toString(),
      );
    }
  }

  /// Sends a PUT request to the specified [uri] with the provided [body].
  ///
  /// [headers] allows custom headers to be provided.
  /// [customAppBaseUrl] allows overriding the base URL if needed.
  /// Returns a [Response] object containing the server's response.
  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        log('PUT request URL: $uri');
        log('PUT request Body: $body');
      }

      final response = await _dio.put(
        uri,
        // data: jsonEncode(body),
        data: body,
        options: Options(
          headers:
              headers ??
              HeaderManager.getMainHeaders(BaseHelper.accessToken.value),
        ),
      );

      return ResponseHandler.handleResponse(response);
    } on DioException catch (error) {
      throw handleDioError(error); // 🔹 Reuse function
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error occurred.',
        details: error.toString(),
      );
    }
  }

  /// Sends a DELETE request to the specified [uri].
  ///
  /// [headers] allows custom headers to be provided.
  /// [customAppBaseUrl] allows overriding the base URL if needed.
  /// Returns a [Response] object containing the server's response.
  Future<Response> deleteData(
    String uri, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        uri,
        data: body,
        options: Options(
          headers:
              headers ??
              HeaderManager.getMainHeaders(BaseHelper.accessToken.value),
        ),
      );

      return ResponseHandler.handleResponse(response);
    } on DioException catch (error) {
      throw handleDioError(error); // 🔹 Reuse function
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error occurred.',
        details: error.toString(),
      );
    }
  }
}
