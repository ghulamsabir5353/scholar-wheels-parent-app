import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        // Invalidate session synchronously so callers (e.g. splash + billing)
        // never see isLogin=true with no subscription and route to subscription plans.
        BaseHelper.clearSessionSync();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != '/login') {
            Get.offAllNamed('/login');
          }
        });
        return ApiException(
          message:
              error.response?.data['message'] ??
              'Unauthorized: Please log in again.',
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
          message:
              error.response?.data['message'] ??
              'Bad Request: Invalid request parameters.',
          code: 400,
          details: error.response?.data,
        );
      case 500:
        return ApiException(
          message:
              error.response?.data['message'] ??
              'Server Error: Please try again later.',
          code: 500,
          details: error.response?.data,
        );
      case 403:
        return ApiException(
          message:
              error.response?.data['message'] ??
              'Forbidden: You do not have permission to access this resource.',
          code: 403,
          details: error.response?.data,
        );
      case 404:
        return ApiException(
          message:
              error.response?.data['message'] ??
              'Not Found: The requested resource was not found.',
          code: 404,
          details: error.response?.data,
        );
      case 422: // Unprocessable Entity
        customToaster(error.response?.data['message']);
        return ApiException(
          message:
              error.response?.data['message'] ??
              'Unprocessable Entity: Validation failed.',
          code: 422,
          details: error.response?.data,
        );
      default:
        return ApiException(
          message:
              error.response?.data['message'] ?? 'Unexpected error occurred.',
          code: error.response!.statusCode,
          details: error.response?.data,
        );
    }
  } else {
    return ApiException(
      message:
          error.response?.data['message'] ??
          'Network error: Please check your internet connection.',
      details: error.message,
    );
  }
}

/// Centralized API error handling: show toaster and log. Use in catch blocks for every API call.
void showApiError(dynamic e, {String? logLabel}) {
  if (e is ApiException) {
    customToaster(e.message, color: Colors.red);
  } else {
    customToaster('Something went wrong', color: Colors.red);
  }
  log('${logLabel ?? 'api error'}: $e');
}
