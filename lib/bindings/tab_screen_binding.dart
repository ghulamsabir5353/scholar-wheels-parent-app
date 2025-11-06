import 'package:get/get.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/controllers/chat_controller.dart';
import 'package:scholarwheels/controllers/contract_controller.dart';
import 'package:scholarwheels/controllers/main.controller.dart';

/// Binding for TabScreen - Initializes all controllers after login
class TabScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize all controllers needed for the main app after login
    // Using Get.put() instead of Get.lazyPut() because these are needed immediately
    Get.put<BottomTabController>(BottomTabController(), permanent: false);
    Get.put<MainController>(MainController(), permanent: false);
    Get.put<ChildController>(ChildController(), permanent: false);
    Get.put<ChatController>(ChatController(), permanent: false);
    Get.put<ContractController>(ContractController(), permanent: false);

    // Add more controllers here as needed:
    // Get.put<SomeOtherController>(SomeOtherController(), permanent: false);
  }
}
