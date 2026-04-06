import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class AccountDeletionController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final RxBool isRequesting = false.obs;
  final RxBool isResendingOtp = false.obs;
  final RxBool isVerifying = false.obs;
  final RxBool hasOtpError = false.obs;
  final RxString otpErrorMessage = ''.obs;
  static const int countdownDurationSeconds = 600; // 10 minutes

  final RxInt countdownSeconds = 600.obs;
  final RxBool canResendOtp = false.obs;

  final TextEditingController otpController = TextEditingController();
  Timer? _countdownTimer;

  String? _challengeToken;
  String? get challengeToken => _challengeToken;

  void setChallengeToken(String? token) => _challengeToken = token;

  String get formattedCountdown {
    final minutes = countdownSeconds.value ~/ 60;
    final seconds = countdownSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startCountdown() {
    _countdownTimer?.cancel();
    canResendOtp.value = false;
    countdownSeconds.value = countdownDurationSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        canResendOtp.value = true;
      }
    });
  }

  /// POST user/account-deletion/request with body { userId }. Returns challenge token.
  Future<bool> requestAccountDeletion() async {
    final userId = BaseHelper.currentUser.value.id;
    if (userId == null || userId.isEmpty) {
      customToaster('User not found', color: Colors.red);
      return false;
    }
    try {
      isRequesting.value = true;
      final response = await apiService.createData(
        AppConstants.accountDeletionRequest,
        {'userId': userId},
      );
      final data = response.data;
      if (data != null && response.statusCode == 200) {
        final token = data['challengeToken'] as String?;
        if (token != null && token.isNotEmpty) {
          _challengeToken = token;
          startCountdown();
          customToaster(
            data['message'] ?? 'OTP sent to your email.',
            color: Colors.green,
          );
          return true;
        }
      }
      customToaster(
        data?['message'] ?? 'Failed to request account deletion',
        color: Colors.red,
      );
      return false;
    } catch (e) {
      showApiError(e, logLabel: 'accountDeletionRequest');
      return false;
    } finally {
      isRequesting.value = false;
    }
  }

  /// POST user/account-deletion/resend-otp (same pattern as login resend - send userId).
  Future<void> resendOtp() async {
    final userId = BaseHelper.currentUser.value.id;
    if (userId == null || userId.isEmpty) {
      customToaster('User not found.', color: Colors.red);
      return;
    }
    try {
      isResendingOtp.value = true;
      final response = await apiService.createData(
        AppConstants.accountDeletionResendOtp,
        {'userId': userId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          response.data?['message'] ?? 'OTP resent to your email',
          color: Colors.green,
        );
        startCountdown();
        otpController.clear();
        hasOtpError.value = false;
      } else {
        customToaster(
          response.data?['message'] ?? 'Failed to resend OTP',
          color: Colors.red,
        );
      }
    } catch (e) {
      showApiError(e, logLabel: 'accountDeletionResendOtp');
    } finally {
      isResendingOtp.value = false;
    }
  }

  /// POST user/account-deletion/verify with challengeToken + otp. Returns success.
  Future<bool> verifyAccountDeletion() async {
    final token = _challengeToken;
    final otp = otpController.text.trim();
    if (token == null || token.isEmpty) {
      customToaster('Session expired. Please start again.', color: Colors.red);
      return false;
    }
    if (otp.length != 6) {
      hasOtpError.value = true;
      otpErrorMessage.value = 'Please enter valid OTP';
      return false;
    }
    try {
      isVerifying.value = true;
      hasOtpError.value = false;
      otpErrorMessage.value = '';
      final response = await apiService.createData(
        AppConstants.accountDeletionVerify,
        {'challengeToken': token, 'otp': otp},
      );
      final data = response.data;
      if (data != null && data['status'] == false) {
        hasOtpError.value = true;
        otpErrorMessage.value = (data['message'] ?? 'Invalid OTP').toString();
        return false;
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          data?['message'] ?? 'Account deleted successfully',
          color: Colors.green,
        );
        return true;
      }
      hasOtpError.value = true;
      otpErrorMessage.value = data?['message'] ?? 'Verification failed';
      return false;
    } catch (e) {
      showApiError(e, logLabel: 'accountDeletionVerify');
      hasOtpError.value = true;
      otpErrorMessage.value = 'Something went wrong';
      return false;
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
