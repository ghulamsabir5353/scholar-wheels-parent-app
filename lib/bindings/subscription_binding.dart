import 'package:get/get.dart';
import 'package:scholarwheels/controllers/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize controller if not already registered
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.put<SubscriptionController>(
        SubscriptionController(),
        permanent: false,
      );
    }
  }
}
