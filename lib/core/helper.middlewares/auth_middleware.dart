import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/screens/auth/get_started_screen.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

/// Middleware to check if user is authenticated before accessing a route
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    if (!BaseHelper.isLogin.value) {
      // User is not authenticated, redirect to get started screen
      return RouteSettings(name: GetStartedScreen.route);
    }

    // Check if user has completed profile (roleData exists)
    // Only check this for routes that require complete profile (like TabScreen)
    // ProfilePictureScreen and ProfileScreen routes should not require roleData
    final routesRequiringProfile = [TabScreen.route];

    if (routesRequiringProfile.contains(route)) {
      if (BaseHelper.currentUser.value.roleData == null) {
        // User is logged in but hasn't completed profile, redirect to profile completion
        return RouteSettings(name: ProfilePictureScreen.route);
      }
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
      // Check if user has completed profile
      if (BaseHelper.currentUser.value.roleData == null) {
        // User is logged in but hasn't completed profile, redirect to profile completion
        return RouteSettings(name: ProfilePictureScreen.route);
      }
      // User is already authenticated with complete profile, redirect to home
      return RouteSettings(name: TabScreen.route);
    }
    return null;
  }
}
