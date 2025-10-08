import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter/material.dart';

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
  }

  // Mandatory
  @override
  void onResumed() {
    log('AppLifecycle - onResumed called');
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
