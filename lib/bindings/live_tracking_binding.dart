import 'package:get/get.dart';
import 'package:scholarwheels/controllers/live_tracking_controller.dart';

class LiveTrackingBinding extends Bindings {
  @override
  void dependencies() {
    // Keep a single controller instance; avoids duplicate socket sessions.
    if (!Get.isRegistered<LiveTrackingController>()) {
      Get.put<LiveTrackingController>(
        LiveTrackingController(),
        permanent: false,
      );
    }
  }
}
