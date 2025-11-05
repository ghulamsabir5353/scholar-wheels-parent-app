import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

/// Middleware to check if user is authenticated before accessing a route
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    if (!BaseHelper.isLogin.value) {
      // User is not authenticated, redirect to login
      Get.offAllNamed(LoginScreen.route);
      return null;
    }
    return null;
  }
}

/// Middleware to prevent authenticated users from accessing auth screens
class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is already logged in
    if (BaseHelper.isLogin.value) {
      // User is already authenticated, redirect to home
      Get.offAllNamed(TabScreen.route);
      return null;
    }
    return null;
  }
}
