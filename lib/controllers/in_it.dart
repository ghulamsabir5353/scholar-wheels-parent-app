import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scholarwheels/controllers/app_lifecycel_controller.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';

import 'package:scholarwheels/core/helper.widgets/custom_loader_animation.dart';

import 'package:scholarwheels/services/api_client.dart';
import 'package:scholarwheels/services/api_services.dart';

late GetStorage box;

Future<void> init() async {
  configLoading();
  Get.put<ApiClient>(ApiClient());
  Get.put<ApiService>(ApiService(Get.find<ApiClient>()));
  await GetStorage.init();
  Get.put(AppLifecycle());
  box = GetStorage();
  Get.put(AuthController());
  BaseHelper.init();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
