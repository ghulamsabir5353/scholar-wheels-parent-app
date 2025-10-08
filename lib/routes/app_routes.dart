import 'package:get/get.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/screens/auth/signup_screen.dart';
import 'package:scholarwheels/screens/auth/splash_screen.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';
import 'package:scholarwheels/screens/childrens/add_children_screen.dart';
import 'package:scholarwheels/screens/childrens/change_child_password_screen.dart';
import 'package:scholarwheels/screens/childrens/set_account_for_child_screen.dart';
import 'package:scholarwheels/screens/find_transport/find_transport_filter_screen.dart';
import 'package:scholarwheels/screens/find_transport/request_booking_screen.dart';
import 'package:scholarwheels/screens/home/notification_screen.dart';
import 'package:scholarwheels/screens/home/schedule_ride_screen.dart';
import 'package:scholarwheels/screens/settings/change_password_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

import '../screens/childrens/edit_child_screen.dart';
import '../screens/contracts/booking_detail_screen.dart';
import '../screens/settings/setting_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: SplashScreen.route,
      page: () => const SplashScreen(),
      fullscreenDialog: true,
    ),
    GetPage(name: TabScreen.route, page: () => TabScreen()),
    GetPage(
      name: LoginScreen.route,
      page: () => LoginScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: SignupScreen.route,
      page: () => SignupScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: NotificationScreen.route,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: ScheduleRideScreen.route, page: () => ScheduleRideScreen()),

    GetPage(name: AddChildrenScreen.route, page: () => AddChildrenScreen()),
    GetPage(name: EditChildScreen.route, page: () => EditChildScreen()),
    GetPage(
      name: ChangeChildPasswordScreen.route,
      page: () => ChangeChildPasswordScreen(),
    ),
    GetPage(
      name: SetAccountForChildScreen.route,
      page: () => SetAccountForChildScreen(),
    ),
    GetPage(
      name: FindTransportFilterScreen.route,
      page: () => FindTransportFilterScreen(),
    ),
    GetPage(
      name: RequestBookingScreen.route,
      page: () => RequestBookingScreen(),
    ),
    GetPage(name: BookingDetailScreen.route, page: () => BookingDetailScreen()),
    GetPage(name: ChatRoomScreen.route, page: () => ChatRoomScreen()),
    GetPage(name: SettingScreen.route, page: () => SettingScreen()),
    GetPage(
      name: ChangePasswordScreen.route,
      page: () => ChangePasswordScreen(),
    ),
  ];
}
