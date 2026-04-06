import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';

class AppLifecycle extends FullLifeCycleController with FullLifeCycleMixin {
  @override
  void onInit() {
    //
    super.onInit();
  }

  // Mandatory
  @override
  void onDetached() {
    log('AppLifecycle - onDetached called');
    _handleAppClose();
  }

  // Mandatory
  @override
  void onInactive() {
    log('AppLifecycle - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    log('AppLifecycle - onPaused called');
    // Don't clear session here - this is called when app goes to background
    // User might resume the app, so we should keep the session active
  }

  // Mandatory
  @override
  void onResumed() {
    log('AppLifecycle - onResumed called');
  }

  /// Handle app termination - clear session if rememberMe is false
  /// This is only called when app is actually killed/terminated
  void _handleAppClose() {
    try {
      // Check if rememberMe is false and user is logged in
      final rememberMe = box.read(AppConstants.REMEMBER_ME) ?? false;
      if (!rememberMe && BaseHelper.isLogin.value) {
        log(
          'App terminated without rememberMe - clearing session and removing FCM token',
        );
        // Clear session and remove FCM token without navigation
        // Use unawaited since we're in a lifecycle callback
        BaseHelper.clearSession();
      }
    } catch (e) {
      log('Error handling app termination: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        log("App Resumed");

        break;
      case AppLifecycleState.inactive:
        log("App InActive");
        break;
      case AppLifecycleState.paused:
        log("App Paused");
        break;
      case AppLifecycleState.detached:
        log("App Detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        log("Hidden");
        break;
    }
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
