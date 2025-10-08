import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_services.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  final ApiService apiService = Get.find<ApiService>();
}
