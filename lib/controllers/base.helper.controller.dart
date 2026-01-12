import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/models/user_model.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/services/fcm_notification_service.dart';

abstract class BaseHelper {
  static RxBool isLogin = false.obs;
  static RxString accessToken = "".obs;
  static Rx<UserDetail> currentUser = UserDetail().obs;
  static void init() {
    if (!isLogin.value) {
      isLogin(box.read(AppConstants.IS_LOGIN) ?? false);
    }

    if (isLogin.value) {
      accessToken(box.read(AppConstants.ACCESS_TOKEN) ?? '');
      currentUser(UserDetail.fromJson(box.read(AppConstants.USER_DETAIL)));
    }
  }

  static Future<void> signOut() async {
    // Delete FCM token from backend before clearing login state
    // This ensures we have access token to make the API call
    await FCMNotificationService.deleteToken();
    
    // Clear global state
    isLogin.value = false;
    accessToken.value = "";
    currentUser.value = UserDetail();

    // Clear local storage
    box.remove(AppConstants.IS_LOGIN);
    box.remove(AppConstants.ACCESS_TOKEN);
    box.remove(AppConstants.USER_DETAIL);
    Get.offAllNamed(LoginScreen.route);
  }

  static getLogo({double? width, double? height}) {
    return Image.asset(
      'assets/images/png/logo.png',
      width: (width ?? 160).w,
      height: (height ?? 160).w,
    );
  }
}
