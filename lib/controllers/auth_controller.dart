import 'package:get/get.dart';
import 'package:scholarwheels/services/api_services.dart';

enum LoginType { google, apple, email, none }

// 000717.7b6412f17a9a4e59b91c85f42d38855e.2229
// shahmeerahmad1435@icloud.com
class AuthController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
