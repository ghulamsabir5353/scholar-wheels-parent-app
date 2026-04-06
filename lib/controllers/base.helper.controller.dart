import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/models/user_model.dart';
import 'package:scholarwheels/models/user_subscription_me_model.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/services/fcm_notification_service.dart';

abstract class BaseHelper {
  static RxBool isLogin = false.obs;
  static RxString accessToken = "".obs;
  static Rx<UserDetail> currentUser = UserDetail().obs;

  /// Global user subscription from GET /usersubscription/me. Updated when
  /// billing screen opens, when returning from subscription plans, and on app resume.
  static Rx<UserSubscriptionMeResponse?> mySubscription =
      Rx<UserSubscriptionMeResponse?>(null);
  static void init() {
    // signOut();

    // Check if rememberMe was enabled
    final rememberMe = box.read(AppConstants.REMEMBER_ME) ?? false;

    if (!isLogin.value) {
      // Only restore login state if rememberMe was true
      if (rememberMe) {
        isLogin(box.read(AppConstants.IS_LOGIN) ?? false);
      } else {
        // Clear any stored login data if rememberMe was false
        box.remove(AppConstants.IS_LOGIN);
        box.remove(AppConstants.ACCESS_TOKEN);
        box.remove(AppConstants.USER_DETAIL);
        isLogin(false);
      }
    }

    if (isLogin.value && rememberMe) {
      accessToken(box.read(AppConstants.ACCESS_TOKEN) ?? '');
      currentUser(UserDetail.fromJson(box.read(AppConstants.USER_DETAIL)));
      // Save FCM token after login
      FCMNotificationService.refreshToken();
    } else if (!rememberMe) {
      // Clear login state if rememberMe was false
      isLogin.value = false;
      accessToken.value = "";
      currentUser.value = UserDetail();
    }
    print('currentUser: ${currentUser.value.toJson()}');
    print('accessToken: $accessToken');
    print('isLogin: $isLogin');
    print('rememberMe: $rememberMe');
  }

  /// Clears auth state and storage immediately (no async). Use when the session
  /// must be invalid before other code runs (e.g. 401) so routing does not treat
  /// the user as logged in without a subscription.
  static void clearSessionSync() {
    isLogin.value = false;
    accessToken.value = "";
    currentUser.value = UserDetail();
    mySubscription.value = null;
    box.remove(AppConstants.IS_LOGIN);
    box.remove(AppConstants.ACCESS_TOKEN);
    box.remove(AppConstants.USER_DETAIL);
    box.remove(AppConstants.REMEMBER_ME);
  }

  /// Clear session without navigation (for app lifecycle events)
  static Future<void> clearSession() async {
    // Delete FCM token from backend before clearing login state
    // This ensures we have access token to make the API call
    await FCMNotificationService.deleteToken();
    clearSessionSync();
  }

  static Future<void> signOut() async {
    await clearSession();
    if (Get.currentRoute == LoginScreen.route) {
      return;
    } else {
      Get.offAllNamed(LoginScreen.route);
    }
  }

  static getLogo({double? width, double? height}) {
    return Image.asset(
      'assets/images/png/logo.png',
      width: (width ?? 160).w,
      height: (height ?? 160).w,
    );
  }

  static getWhiteLogo({double? width, double? height}) {
    return Image.asset(
      'assets/images/png/white_logo.png',
      width: (width ?? 160).w,
      height: (height ?? 160).w,
    );
  }
}
