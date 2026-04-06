import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/models/user_model.dart';
import 'package:scholarwheels/controllers/billing_controller.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/auth/verify_registration_otp_screen.dart';
import 'package:scholarwheels/screens/auth/verify_login_otp_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

enum LoginType { google, apple, email, none }

class AuthController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;

  // Form controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form controllers (used in both signup and profile completion)
  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  // Change password controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Profile data
  String? profileImagePath;
  String role = "parent";

  // Registration OTP related
  final RxBool isResendingRegistrationOTP = false.obs;
  final RxBool isVerifyingRegistrationOTP = false.obs;
  final RxBool hasRegistrationOTPError = false.obs;
  final RxString registrationOTPErrorMessage = ''.obs;
  final otpController = TextEditingController();
  final RxInt registrationCountdownSeconds = 600.obs; // 10 minutes in seconds
  final RxBool canResendRegistrationOTP = false.obs;
  Timer? _registrationCountdownTimer;
  String? _registrationEmail;

  String? get registrationEmail => _registrationEmail;
  set registrationEmail(String? email) => _registrationEmail = email;

  // Login OTP related
  final RxBool isResendingLoginOTP = false.obs;
  final RxBool isVerifyingLoginOTP = false.obs;
  final RxBool hasLoginOTPError = false.obs;
  final RxString loginOTPErrorMessage = ''.obs;
  final loginOtpController = TextEditingController();
  final RxInt loginCountdownSeconds = 60.obs; // 1 minute in seconds
  final RxBool canResendLoginOTP = false.obs;
  Timer? _loginCountdownTimer;
  String? _loginEmail;
  String? _challengeToken;
  bool _rememberMe = false;

  String? get loginEmail => _loginEmail;
  set loginEmail(String? email) => _loginEmail = email;
  String? get challengeToken => _challengeToken;
  set challengeToken(String? token) => _challengeToken = token;
  bool get rememberMe => _rememberMe;
  set rememberMe(bool value) => _rememberMe = value;

  /// Clear all form fields
  void clearAllFields() {
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    surNameController.clear();
    cityController.clear();
    zipCodeController.clear();
    addressController.clear();
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    profileImagePath = null;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    surNameController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    otpController.dispose();
    loginOtpController.dispose();
    _registrationCountdownTimer?.cancel();
    _loginCountdownTimer?.cancel();
    super.dispose();
  }

  /// Register a new parent user
  Future<void> registerParent() async {
    try {
      isLoading.value = true;

      final requestBody = {
        "firstName": firstNameController.text.trim(),
        "surName": surNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "phone": phoneController.text.trim(),
        "confirmPassword": confirmPasswordController.text,
      };

      final response = await apiService.createData(
        AppConstants.registerParent,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('signup response: ${response.data}');

        // Parse signup response - now returns email for OTP verification
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];
          final email = data['email'] as String?;

          if (email != null) {
            registrationEmail = email;
            customToaster(
              response.data['message'] ??
                  'Registration successful. Please check your email to verify your account.',
              color: Colors.green,
            );

            // Start countdown timer (10 minutes)
            startRegistrationCountdown();

            // Navigate to OTP verification screen
            Get.toNamed(
              VerifyRegistrationOTPScreen.route,
              arguments: {'email': email},
            );
          } else {
            customToaster('Email not received from server', color: Colors.red);
          }
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Registration failed';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'registerParent');
    } finally {
      isLoading.value = false;
    }
  }

  /// Complete user profile - Creates parent profile
  Future<void> completeProfile() async {
    try {
      isLoading.value = true;

      // Get current user ID
      final userId = BaseHelper.currentUser.value.id;
      if (userId == null) {
        customToaster('User ID not found', color: Colors.red);
        return;
      }

      final requestBody = {
        "userId": userId,
        "firstName": firstNameController.text.trim(),
        "surName": surNameController.text.trim(),
        "lastName": surNameController.text.trim(), // API expects lastName
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "postalCode": zipCodeController.text.trim(), // API uses postalCode
        "profileImage": profileImagePath ?? "",
      };

      // Use POST request to create parent profile
      final response = await apiService.createData('parent', requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('parent profile data: ${response.data}');

        // Update roleData in current user with parent details
        if (response.data != null && response.data['parent'] != null) {
          final parentData = response.data['parent'];

          // Update user with roleData (parent details)
          final updatedUser = BaseHelper.currentUser.value.copyWith(
            profileImage: parentData['user']['profileImage'],
            profileImagePresignedUrl:
                parentData['user']['profileImagePresignedUrl'],
            roleData: RoleData.fromJson(parentData),
          );
          BaseHelper.currentUser.value = updatedUser;

          // Update in local storage
          box.write(AppConstants.USER_DETAIL, updatedUser.toJson());
        }

        customToaster(
          response.data['message'] ?? 'Profile completed successfully!',
          color: Colors.green,
        );

        // Clear all profile fields
        clearAllFields();

        // Redirect to subscription plans with trial messaging (user can start trial or add payment)
        Get.offAllNamed(
          SubscriptionPlansScreen.route,
          arguments: {'fromProfileCompletion': true},
        );
      } else {
        customToaster(
          response.data['message'] ?? 'Profile completion failed',
          color: Colors.red,
        );
      }
    } catch (e) {
      showApiError(e, logLabel: 'completeProfile');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile (for settings screen)
  Future<void> updateUser() async {
    try {
      isLoading.value = true;

      // Get current user ID
      final userId = BaseHelper.currentUser.value.id;
      if (userId == null) {
        customToaster('User ID not found', color: Colors.red);
        return;
      }

      final requestBody = {
        "email": emailController.text.trim(),
        "profileImage": profileImagePath ?? "",
        "firstName": firstNameController.text.trim(),
        "surName": surNameController.text.trim(), // API uses lastName
        "phone": phoneController.text.trim(),
      };

      final endpoint = '${AppConstants.updateUser}/$userId';

      // Use PATCH request to update user profile
      final response = await apiService.patchData(endpoint, requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' user data: ${BaseHelper.currentUser.value}}');
        log('update user data: ${response.data}');

        // Update current user data if response contains user data
        if (response.data != null && response.data['data'] != null) {
          final userData = response.data['data'];
          UserDetail user = UserDetail.fromJson(userData);
          BaseHelper.currentUser.value = BaseHelper.currentUser.value.copyWith(
            firstName: user.firstName,
            surName: user.surName,
            email: user.email,
            phone: user.phone,
            profileImage: user.profileImage,
            profileImagePresignedUrl: user.profileImagePresignedUrl,
          );
          box.write(
            AppConstants.USER_DETAIL,
            BaseHelper.currentUser.value.toJson(),
          );
        }

        customToaster(
          response.data['message'] ?? 'Profile updated successfully!',
          color: Colors.green,
        );
        Get.back(); // Go back to settings screen
      } else {
        customToaster('Profile update failed', color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'updateUser');
    } finally {
      isLoading.value = false;
    }
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
    String role = "parent",
    bool rememberMe = false,
  }) async {
    try {
      isLoading.value = true;
      _rememberMe = rememberMe;

      final requestBody = {"email": email, "password": password, "role": role};

      final response = await apiService.createData(
        AppConstants.login,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('login response: ${response.data}');

        final responseData = response.data;
        if (responseData != null && responseData['data'] != null) {
          final data = responseData['data'];

          // Check if OTP is required
          if (data['requiresOtp'] == true) {
            final isRegistrationOtp = data['isRegistrationOtp'] == true;
            final email = data['email'] as String?;
            final challengeToken = data['challengeToken'] as String?;

            if (email != null) {
              _loginEmail = email;
              _challengeToken = challengeToken;

              customToaster(
                responseData['message'] ??
                    'OTP sent to your email. Please verify to complete login.',
                color: Colors.green,
              );

              // Start countdown timer (1 minute)
              startLoginCountdown();

              if (isRegistrationOtp) {
                // Navigate to registration OTP screen
                Get.toNamed(
                  VerifyRegistrationOTPScreen.route,
                  arguments: {'email': email},
                );
              } else {
                // Navigate to login OTP screen
                Get.toNamed(
                  VerifyLoginOTPScreen.route,
                  arguments: {'email': email, 'challengeToken': challengeToken},
                );
              }
              return;
            }
          }

          // If no OTP required, proceed with normal login
          final token = data['token'];
          final userData = data['user'];

          // Store token and user data globally
          BaseHelper.accessToken.value = token;
          BaseHelper.currentUser.value = UserDetail.fromJson(userData);
          BaseHelper.isLogin.value = true;

          // Store in local storage only if rememberMe is true
          if (rememberMe) {
            box.write(AppConstants.ACCESS_TOKEN, token);
            box.write(AppConstants.USER_DETAIL, userData);
            box.write(AppConstants.IS_LOGIN, true);
            box.write(AppConstants.REMEMBER_ME, true);
          } else {
            // Don't persist login state if rememberMe is false
            box.remove(AppConstants.ACCESS_TOKEN);
            box.remove(AppConstants.USER_DETAIL);
            box.remove(AppConstants.IS_LOGIN);
            box.write(AppConstants.REMEMBER_ME, false);
          }

          log('User logged in: ${BaseHelper.currentUser.value.email}');

          // Clear all fields after successful login
          clearAllFields();

          // Socket connection will be initialized by ChatController.onInit()
          // when TabScreenBinding creates ChatController after navigation

          customToaster('Login successful!', color: Colors.green);
          Get.offAllNamed(TabScreen.route);
        }
      } else {
        // Show error message from API response
        final errorMessage = response.data?['message'] ?? 'Login failed';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'login');
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify registration OTP
  Future<bool> verifyRegistrationOTP() async {
    try {
      isVerifyingRegistrationOTP.value = true;
      hasRegistrationOTPError.value = false;
      registrationOTPErrorMessage.value = '';
      final email = registrationEmail ?? emailController.text.trim();
      final otp = otpController.text.trim();

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return false;
      }

      if (otp.isEmpty || otp.length < 6) {
        hasRegistrationOTPError.value = true;
        registrationOTPErrorMessage.value = 'Please enter valid OTP';
        return false;
      }

      final response = await apiService.createData(
        AppConstants.verifyRegistrationOTP,
        {'email': email, 'otp': otp},
      );

      // Check if response has status: false in body (even with 200 status code)
      final responseData = response.data;
      if (responseData != null && responseData['status'] == false) {
        // Handle invalid OTP response
        hasRegistrationOTPError.value = true;
        final errorMessage = responseData['message'] ?? 'Invalid OTP';
        registrationOTPErrorMessage.value = errorMessage.toString();

        // Check for errors array
        if (responseData['errors'] != null &&
            (responseData['errors'] as List).isNotEmpty) {
          registrationOTPErrorMessage.value = responseData['errors'][0]
              .toString();
        }

        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response - returns token and user data
        if (responseData != null && responseData['data'] != null) {
          final data = responseData['data'];
          final token = data['token'];
          final userData = data['user'];

          // Store token and user data globally
          BaseHelper.accessToken.value = token;
          BaseHelper.currentUser.value = UserDetail.fromJson(userData);
          BaseHelper.isLogin.value = true;

          // Store in local storage
          box.write(AppConstants.ACCESS_TOKEN, token);
          box.write(AppConstants.USER_DETAIL, userData);
          box.write(AppConstants.IS_LOGIN, true);

          log(
            'User registered and verified: ${BaseHelper.currentUser.value.email}',
          );
          customToaster(
            responseData['message'] ??
                'Email verified successfully. Your account is now active.',
            color: Colors.green,
          );

          // Clear OTP and countdown
          otpController.clear();
          _registrationCountdownTimer?.cancel();
          registrationEmail = null;

          // Clear signup fields
          clearAllFields();

          // Navigate to profile picture screen
          Get.offAllNamed(ProfilePictureScreen.route);
          return true;
        } else {
          hasRegistrationOTPError.value = true;
          registrationOTPErrorMessage.value = 'Invalid response from server';
          return false;
        }
      } else {
        hasRegistrationOTPError.value = true;
        final errorMessage = responseData?['message'] ?? 'Invalid OTP';
        registrationOTPErrorMessage.value = errorMessage.toString();

        // Check for errors array
        if (responseData?['errors'] != null &&
            (responseData!['errors'] as List).isNotEmpty) {
          registrationOTPErrorMessage.value = responseData['errors'][0]
              .toString();
        }

        // Only show toaster for server errors, not for invalid OTP
        if (response.statusCode != 400) {
          customToaster(registrationOTPErrorMessage.value, color: Colors.red);
        }
        return false;
      }
    } catch (e) {
      showApiError(e, logLabel: 'verifyRegistrationOTP');
      hasRegistrationOTPError.value = true;
      registrationOTPErrorMessage.value = 'Something went wrong';
      return false;
    } finally {
      isVerifyingRegistrationOTP.value = false;
    }
  }

  /// Resend registration OTP
  Future<void> resendRegistrationOTP() async {
    try {
      isResendingRegistrationOTP.value = true;
      final email = registrationEmail ?? emailController.text.trim();

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return;
      }

      final response = await apiService.createData(
        AppConstants.resendRegistrationOTP,
        {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          response.data['message'] ?? 'Registration OTP resent to your email',
          color: Colors.green,
        );
        // Reset countdown timer (10 minutes)
        startRegistrationCountdown();
        // Clear OTP field
        otpController.clear();
      } else {
        final errorMessage =
            response.data?['message'] ?? 'Failed to resend OTP';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'resendRegistrationOTP');
    } finally {
      isResendingRegistrationOTP.value = false;
    }
  }

  /// Start countdown timer for registration OTP resend (10 minutes)
  void startRegistrationCountdown() {
    _registrationCountdownTimer?.cancel();
    canResendRegistrationOTP.value = false;
    registrationCountdownSeconds.value = 600; // 10 minutes

    _registrationCountdownTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      if (registrationCountdownSeconds.value > 0) {
        registrationCountdownSeconds.value--;
      } else {
        timer.cancel();
        canResendRegistrationOTP.value = true;
      }
    });
  }

  /// Format countdown time as MM:SS
  String get formattedRegistrationCountdown {
    final minutes = registrationCountdownSeconds.value ~/ 60;
    final seconds = registrationCountdownSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Verify login OTP
  Future<bool> verifyLoginOTP() async {
    try {
      isVerifyingLoginOTP.value = true;
      hasLoginOTPError.value = false;
      loginOTPErrorMessage.value = '';
      final email = loginEmail ?? emailController.text.trim();
      final otp = loginOtpController.text.trim();
      final token = challengeToken;

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return false;
      }

      if (token == null || token.isEmpty) {
        customToaster('Challenge token is required', color: Colors.red);
        return false;
      }

      if (otp.isEmpty || otp.length < 6) {
        hasLoginOTPError.value = true;
        loginOTPErrorMessage.value = 'Please enter valid OTP';
        return false;
      }

      final response = await apiService.createData(
        AppConstants.verifyLoginOTP,
        {
          'challengeToken': token,
          'otp': otp,
          'rememberMe': rememberMe.toString(),
        },
      );

      // Check if response has status: false in body (even with 200 status code)
      final responseData = response.data;
      if (responseData != null && responseData['status'] == false) {
        print('responseData: ${responseData['data']['user']['subscription']}');
        // Handle invalid OTP response
        hasLoginOTPError.value = true;
        final errorMessage = responseData['message'] ?? 'Invalid OTP';
        loginOTPErrorMessage.value = errorMessage.toString();

        // Check for errors array
        if (responseData['errors'] != null &&
            (responseData['errors'] as List).isNotEmpty) {
          loginOTPErrorMessage.value = responseData['errors'][0].toString();
        }

        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response - returns token and user data
        if (responseData != null && responseData['data'] != null) {
          final data = responseData['data'];
          final authToken = data['token'];
          final userData = data['user'];

          // Store token and user data globally
          BaseHelper.accessToken.value = authToken;
          BaseHelper.currentUser.value = UserDetail.fromJson(userData);
          BaseHelper.isLogin.value = true;

          // Store in local storage only if rememberMe is true
          if (rememberMe) {
            box.write(AppConstants.ACCESS_TOKEN, authToken);
            box.write(AppConstants.USER_DETAIL, userData);
            box.write(AppConstants.IS_LOGIN, true);
            box.write(AppConstants.REMEMBER_ME, true);
          } else {
            // Don't persist login state if rememberMe is false
            box.remove(AppConstants.ACCESS_TOKEN);
            box.remove(AppConstants.USER_DETAIL);
            box.remove(AppConstants.IS_LOGIN);
            box.write(AppConstants.REMEMBER_ME, false);
          }

          log('User logged in with OTP: ${BaseHelper.currentUser.value.email}');

          customToaster(
            responseData['message'] ?? 'Login successful',
            color: Colors.green,
          );

          // Clear OTP and countdown
          loginOtpController.clear();
          _loginCountdownTimer?.cancel();
          loginEmail = null;
          challengeToken = null;

          // Clear all fields after successful login
          clearAllFields();

          // Priority: roleData (complete profile) → subscription → home
          final user = BaseHelper.currentUser.value;
          if (user.roleData == null) {
            Get.offAllNamed(ProfilePictureScreen.route);
            return true;
          }
          // Use GET usersubscription/me for subscription state (login response may not include it)
          try {
            final billing = Get.isRegistered<BillingController>()
                ? Get.find<BillingController>()
                : Get.put(BillingController());
            await billing.fetchMySubscription();
          } catch (_) {}
          final hasSubscription =
              BaseHelper.mySubscription.value?.hasActiveSubscription == true;
          if (hasSubscription) {
            Get.offAllNamed(TabScreen.route);
          } else {
            Get.offAllNamed(SubscriptionPlansScreen.route);
          }
          return true;
        } else {
          hasLoginOTPError.value = true;
          loginOTPErrorMessage.value = 'Invalid response from server';
          return false;
        }
      } else {
        hasLoginOTPError.value = true;
        final errorMessage = responseData?['message'] ?? 'Invalid OTP';
        loginOTPErrorMessage.value = errorMessage.toString();

        // Check for errors array
        if (responseData?['errors'] != null &&
            (responseData!['errors'] as List).isNotEmpty) {
          loginOTPErrorMessage.value = responseData['errors'][0].toString();
        }

        // Only show toaster for server errors, not for invalid OTP
        if (response.statusCode != 400) {
          customToaster(loginOTPErrorMessage.value, color: Colors.red);
        }
        return false;
      }
    } catch (e) {
      showApiError(e, logLabel: 'verifyLoginOTP');
      hasLoginOTPError.value = true;
      loginOTPErrorMessage.value = 'Something went wrong';
      return false;
    } finally {
      isVerifyingLoginOTP.value = false;
    }
  }

  /// Resend login OTP
  Future<void> resendLoginOTP() async {
    try {
      isResendingLoginOTP.value = true;
      final email = loginEmail ?? emailController.text.trim();

      if (email.isEmpty) {
        customToaster('Email is required', color: Colors.red);
        return;
      }

      final response = await apiService.createData(
        AppConstants.resendLoginOTP,
        {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        customToaster(
          response.data['message'] ?? 'OTP resent to your email',
          color: Colors.green,
        );
        // Reset countdown timer (1 minute)
        startLoginCountdown();
        // Clear OTP field
        loginOtpController.clear();
      } else {
        final errorMessage =
            response.data?['message'] ?? 'Failed to resend OTP';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'resendLoginOTP');
    } finally {
      isResendingLoginOTP.value = false;
    }
  }

  /// Start countdown timer for login OTP resend (1 minute)
  void startLoginCountdown() {
    _loginCountdownTimer?.cancel();
    canResendLoginOTP.value = false;
    loginCountdownSeconds.value = 60; // 1 minute

    _loginCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (loginCountdownSeconds.value > 0) {
        loginCountdownSeconds.value--;
      } else {
        timer.cancel();
        canResendLoginOTP.value = true;
      }
    });
  }

  /// Format countdown time as MM:SS
  String get formattedLoginCountdown {
    final minutes = loginCountdownSeconds.value ~/ 60;
    final seconds = loginCountdownSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Change user password
  Future<void> changePassword() async {
    try {
      isLoading.value = true;

      final requestBody = {
        "currentPassword": currentPasswordController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
      };

      // Use PATCH request to change password
      final response = await apiService.createData(
        AppConstants.changePassword,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('change password data: ${response.data}');

        customToaster(
          response.data['message'] ?? 'Password changed successfully!',
          color: Colors.green,
        );

        // Clear password fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        Get.back(); // Go back to settings screen
      } else {
        customToaster(
          response.data['message'] ?? 'Password change failed',
          color: Colors.red,
        );
      }
    } catch (e) {
      showApiError(e, logLabel: 'changePassword');
    } finally {
      isLoading.value = false;
    }
  }
}
