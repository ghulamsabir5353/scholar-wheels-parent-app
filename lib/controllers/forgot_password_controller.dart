import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';

class ForgotPasswordController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final RxBool isResendingOTP = false.obs;
  final RxBool isVerifyingOTP = false.obs;
  final RxBool isResettingPassword = false.obs;
  final RxBool hasOTPError = false.obs;
  final RxString otpErrorMessage = ''.obs;

  // Form controllers
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Timer for OTP resend
  final RxInt countdownSeconds = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _countdownTimer;

  // Store email and token
  String? _email;
  String? _resetToken;

  String? get email => _email;
  String? get resetToken => _resetToken;

  void setResetToken(String token) {
    _resetToken = token;
  }

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments if navigating from verify OTP
    // Store in _email only, don't set emailController to avoid setState during build
    final args = Get.arguments;
    if (args is Map && args['email'] != null) {
      _email = args['email'] as String;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Send forgot password request
  Future<void> sendForgotPasswordRequest() async {
    try {
      isLoading.value = true;
      final email = emailController.text.trim();

      if (email.isEmpty) {
        customToaster('Please enter your email', color: Colors.red);
        return;
      }

      final response = await apiService.createData(
        AppConstants.forgotPassword,
        {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _email = email;
        customToaster(
          response.data['message'] ?? 'OTP sent to your email',
          color: Colors.green,
        );
        // Navigate to verify OTP screen
        Get.toNamed('/verify-otp', arguments: {'email': email});
        // Start countdown timer
        startCountdown();
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to send OTP';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'sendForgotPasswordRequest');
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOTP() async {
    try {
      isVerifyingOTP.value = true;
      hasOTPError.value = false;
      otpErrorMessage.value = '';
      final email = _email ?? emailController.text.trim();
      final otp = otpController.text.trim();

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return false;
      }

      if (otp.isEmpty || otp.length < 6) {
        hasOTPError.value = true;
        otpErrorMessage.value = 'Please enter valid OTP';
        return false;
      }

      final response = await apiService.createData(AppConstants.verifyOTP, {
        'email': email,
        'otp': otp,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract token from response: expect data.token
        final data = response.data['data'];
        final token = (data is Map<String, dynamic> ? data['token'] : null)
            ?.toString();

        if (token == null || token.isEmpty) {
          hasOTPError.value = true;
          otpErrorMessage.value = 'Token not received from server';
          return false;
        }

        _resetToken = token;

        customToaster('OTP verified successfully', color: Colors.green);
        // Navigate to reset password screen
        Get.toNamed(
          '/reset-password',
          arguments: {'email': email, 'token': _resetToken},
        );
        return true;
      } else {
        hasOTPError.value = true;
        otpErrorMessage.value = (response.data['message'] ?? 'Invalid OTP')
            .toString();
        // Only show toaster for server errors, not for invalid OTP
        if (response.statusCode != 400) {
          customToaster(otpErrorMessage.value, color: Colors.red);
        }
        return false;
      }
    } catch (e) {
      log('Error verifying OTP: $e');
      hasOTPError.value = true;

      // Extract detailed message from ApiException / backend when available
      if (e is ApiException) {
        final details = e.details;
        String message = e.message;

        if (details is Map) {
          if (details['message'] != null) {
            message = details['message'].toString();
          } else if (details['errors'] is List &&
              (details['errors'] as List).isNotEmpty) {
            message = details['errors'].first.toString();
          }
        }

        otpErrorMessage.value = message;
      } else {
        otpErrorMessage.value = 'Something went wrong';
      }

      // Show error primarily under the OTP fields (avoid duplicate toaster)
      return false;
    } finally {
      isVerifyingOTP.value = false;
    }
  }

  /// Resend OTP
  Future<void> resendOTP() async {
    try {
      isResendingOTP.value = true;
      final email = _email ?? emailController.text.trim();

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return;
      }

      final response = await apiService.createData(AppConstants.resendOTP, {
        'email': email,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          response.data['message'] ?? 'OTP resent to your email',
          color: Colors.green,
        );
        // Reset countdown
        startCountdown();
        // Clear OTP field
        otpController.clear();
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to resend OTP';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'resendOTP');
    } finally {
      isResendingOTP.value = false;
    }
  }

  /// Reset password
  Future<void> resetPassword() async {
    try {
      isResettingPassword.value = true;
      // Get token from stored value or arguments
      final token = _resetToken ?? Get.arguments?['token'];
      final newPassword = newPasswordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (token == null || token.isEmpty) {
        customToaster('Reset token not found', color: Colors.red);
        return;
      }

      if (newPassword.isEmpty) {
        customToaster('Please enter new password', color: Colors.red);
        return;
      }

      if (newPassword.length < 8) {
        customToaster(
          'Password must be at least 8 characters',
          color: Colors.red,
        );
        return;
      }

      if (newPassword != confirmPassword) {
        customToaster('Passwords do not match', color: Colors.red);
        return;
      }

      // reset-password is a PATCH endpoint
      final response = await apiService.patchData(AppConstants.resetPassword, {
        'token': token,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          response.data['message'] ?? 'Password reset successfully',
          color: Colors.green,
        );
        // Clear all fields
        clearAllFields();
        // Navigate back to login
        Get.offAllNamed(LoginScreen.route);
      } else {
        final errorMessage =
            response.data['message'] ?? 'Failed to reset password';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'resetPassword');
    } finally {
      isResettingPassword.value = false;
    }
  }

  /// Start countdown timer for resend OTP
  void startCountdown() {
    _countdownTimer?.cancel();
    canResend.value = false;
    countdownSeconds.value = 60;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  /// Format countdown time as MM:SS
  String get formattedCountdown {
    final minutes = countdownSeconds.value ~/ 60;
    final seconds = countdownSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Clear all fields
  void clearAllFields() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _email = null;
    _resetToken = null;
    _countdownTimer?.cancel();
  }
}
