import 'package:get/get.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';

abstract class BaseHelper {
  static RxBool isLogin = false.obs;
  static RxString accessToken = "".obs;
  static void init() {
    if (!isLogin.value) {
      isLogin(box.read(AppConstants.IS_LOGIN) ?? false);
    }

    if (isLogin.value) {
      accessToken(box.read(AppConstants.ACCESS_TOKEN) ?? '');
    }
  }

  static void signOut() {}
}
