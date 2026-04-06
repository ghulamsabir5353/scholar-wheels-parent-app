import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/screens/auth/get_started_screen.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

/// Returns true if user has an active subscription (from /me cache or currentUser).
bool get _hasActiveSubscription {
  if (BaseHelper.mySubscription.value?.hasActiveSubscription == true) {
    return true;
  }
  final u = BaseHelper.currentUser.value;
  return u.activeSubscription == true && u.subscription != null;
}

/// Middleware to check if user is authenticated before accessing a route.
/// Priority: login → profile (roleData) → subscription → dashboard.
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!BaseHelper.isLogin.value) {
      return RouteSettings(name: GetStartedScreen.route);
    }

    final routesRequiringProfileAndSubscription = [TabScreen.route];

    if (routesRequiringProfileAndSubscription.contains(route)) {
      if (BaseHelper.currentUser.value.roleData == null) {
        return RouteSettings(name: ProfilePictureScreen.route);
      }
      if (!_hasActiveSubscription) {
        return RouteSettings(name: SubscriptionPlansScreen.route);
      }
    }

    return null;
  }
}

/// Middleware to prevent authenticated users from accessing auth screens.
/// Priority: profile completion → subscription → home.
class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (BaseHelper.isLogin.value) {
      if (BaseHelper.currentUser.value.roleData == null) {
        return RouteSettings(name: ProfilePictureScreen.route);
      }
      if (!_hasActiveSubscription) {
        return RouteSettings(name: SubscriptionPlansScreen.route);
      }
      return RouteSettings(name: TabScreen.route);
    }
    return null;
  }
}
