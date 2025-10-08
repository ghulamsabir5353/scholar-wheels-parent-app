import 'package:dio/dio.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class ApiException implements Exception {
  final String message;
  final int? code;
  final dynamic details;

  ApiException({required this.message, this.code, this.details});

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message, details: $details)';
  }
}

// 🔹 Centralized function for handling Dio exceptions
ApiException handleDioError(DioException error) {
  if (error.response != null) {
    switch (error.response!.statusCode) {
      case 401:
        if (BaseHelper.isLogin.value) {
          BaseHelper.signOut();
        }
        return ApiException(
          message: 'Unauthorized: Please log in again.',
          code: 401,
          details: error.response?.data,
        );
      case 400:
        // Handle specific error messages for 400 Bad Request
        if (error.response?.data.containsKey('message')) {
          customToaster(
            error.response?.data['message'] ?? 'Validation failed.',
          );
        }
        return ApiException(
          message: 'Bad Request: Invalid request parameters.',
          code: 400,
          details: error.response?.data,
        );
      case 500:
        return ApiException(
          message: 'Server Error: Please try again later.',
          code: 500,
          details: error.response?.data,
        );
      case 403:
        return ApiException(
          message:
              'Forbidden: You do not have permission to access this resource.',
          code: 403,
          details: error.response?.data,
        );
      case 404:
        return ApiException(
          message: 'Not Found: The requested resource was not found.',
          code: 404,
          details: error.response?.data,
        );
      case 422: // Unprocessable Entity
        customToaster(error.response?.data['message']);
        return ApiException(
          message: 'Unprocessable Entity: Validation failed.',
          code: 422,
          details: error.response?.data,
        );
      default:
        return ApiException(
          message: 'Unexpected error occurred.',
          code: error.response!.statusCode,
          details: error.response?.data,
        );
    }
  } else {
    return ApiException(
      message: 'Network error: Please check your internet connection.',
      details: error.message,
    );
  }
}
