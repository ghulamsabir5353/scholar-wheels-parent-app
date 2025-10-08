import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = false, duration}) {
  Get.showSnackbar(GetSnackBar(
    backgroundColor: isError ? Colors.red : Colors.grey.shade300,
    message: message,
    duration: Duration(seconds: duration ?? 3),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}

void showcustomBottomSheet(Widget widget) {
  Get.bottomSheet(widget,
      isDismissible: true,
      isScrollControlled: false,
      enableDrag: true,
      elevation: 22,
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor);
}
