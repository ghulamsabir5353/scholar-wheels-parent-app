import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/models/user_model.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';
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

        // Parse signup response - now returns token like login
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];
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
            'User signed up and logged in: ${BaseHelper.currentUser.value.email}',
          );
          customToaster(
            response.data['message'] ?? 'Account created successfully!',
            color: Colors.green,
          );
          
          // Clear signup fields
          clearAllFields();
          
          Get.offAllNamed(
            ProfilePictureScreen.route,
          ); // Navigate to profile picture screen
        }
      } else {
        customToaster('Registration failed', color: Colors.red);
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
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
            roleData: RoleData.fromJson(parentData),
          );
          BaseHelper.currentUser.value = updatedUser;

          // Update in local storage
          box.write(AppConstants.USER_DETAIL, updatedUser.toJson());
        }

        customToaster(
          response.data['message'] ??
              'Profile completed successfully! Please login to continue.',
          color: Colors.green,
        );

        // Clear all profile fields
        clearAllFields();

        // Log out the user and redirect to login screen
        // This ensures roleData is properly set before accessing dashboard
        BaseHelper.signOut();
        Get.offAllNamed(LoginScreen.route);
      } else {
        customToaster(
          response.data['message'] ?? 'Profile completion failed',
          color: Colors.red,
        );
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
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
        "lastName": surNameController.text.trim(), // API uses lastName
        "phone": phoneController.text.trim(),
      };

      final endpoint = '${AppConstants.updateUser}/$userId';

      // Use PATCH request to update user profile
      final response = await apiService.patchData(endpoint, requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('update user data: ${response.data}');

        // Update current user data if response contains user data
        if (response.data != null && response.data['data'] != null) {
          final userData = response.data['data'];
          BaseHelper.currentUser.value = UserDetail.fromJson(userData);
          box.write(AppConstants.USER_DETAIL, userData);
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
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Login user
  Future<void> login({
    required String email,
    required String password,
    String role = "parent",
  }) async {
    try {
      isLoading.value = true;

      final requestBody = {"email": email, "password": password, "role": role};

      final response = await apiService.createData(
        AppConstants.login,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('login response: ${response.data}');

        // Parse login response
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];
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

          log('User logged in: ${BaseHelper.currentUser.value.email}');

          // Clear all fields after successful login
          clearAllFields();

          customToaster('Login successful!', color: Colors.green);
          Get.offAllNamed(TabScreen.route);
        }
      } else {
        // Show error message from API response
        final errorMessage = response.data?['message'] ?? 'Login failed';
        customToaster(errorMessage, color: Colors.red);
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('login error: $e');
    } finally {
      isLoading.value = false;
    }
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
      log('error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
