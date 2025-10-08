import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class AppLoader {
  static void show({String status = 'Loading...'}) {
    EasyLoading.show(status: status);
  }

  static void showProgress(double progress, {String status = 'Loading...'}) {
    EasyLoading.showProgress(progress, status: status);
  }

  static void showSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  static void showError(String message) {
    EasyLoading.showError(message);
  }

  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  static void showToast(String message) {
    EasyLoading.showToast(message);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
