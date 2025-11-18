import 'package:get/get.dart';
import 'package:scholarwheels/bindings/tab_screen_binding.dart';
import 'package:scholarwheels/screens/auth/get_started_screen.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/auth/profile_screen.dart';
import 'package:scholarwheels/screens/auth/signup_screen.dart';
import 'package:scholarwheels/screens/auth/splash_screen.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';
import 'package:scholarwheels/screens/childrens/add_children_screen.dart';
import 'package:scholarwheels/screens/childrens/set_account_for_child_screen.dart';
import 'package:scholarwheels/screens/find_transport/find_transport_filter_screen.dart';
import 'package:scholarwheels/screens/find_transport/request_booking_screen.dart';
import 'package:scholarwheels/screens/common/location_search_screen.dart';
import 'package:scholarwheels/screens/find_transport/booking_success_screen.dart';
import 'package:scholarwheels/screens/home/notification_screen.dart';
import 'package:scholarwheels/screens/home/schedule_ride_screen.dart';
import 'package:scholarwheels/screens/settings/change_password_screen.dart';
import 'package:scholarwheels/screens/settings/personal_profile_screen.dart';
import 'package:scholarwheels/screens/settings/privacy_policy_screen.dart';
import 'package:scholarwheels/screens/settings/terms_and_conditions_screen.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_screen.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_detail_screen.dart';
import 'package:scholarwheels/screens/settings/billings/billing_screen.dart';
import 'package:scholarwheels/screens/settings/billings/billing_history_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';
import 'package:scholarwheels/screens/settings/rating_review_screen.dart';
import 'package:scholarwheels/screens/settings/support_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';
import 'package:scholarwheels/core/helper.middlewares/auth_middleware.dart';

import '../screens/childrens/edit_child_screen.dart';
import '../screens/contracts/contract_detail_screen.dart';
import '../screens/bookings/booking_detail_screen.dart';
import '../screens/bookings/request_history_screen.dart';
import '../screens/settings/setting_screen.dart';
import '../screens/home/tracking/live_tracking_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: SplashScreen.route,
      page: () => const SplashScreen(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: TabScreen.route,
      page: () => const TabScreen(),
      binding: TabScreenBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: GetStartedScreen.route,
      page: () => const GetStartedScreen(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: LoginScreen.route,
      page: () => LoginScreen(),
      transition: Transition.leftToRight,
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: SignupScreen.route,
      page: () => SignupScreen(),
      transition: Transition.rightToLeft,
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: NotificationScreen.route,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: ScheduleRideScreen.route, page: () => ScheduleRideScreen()),

    GetPage(name: AddChildrenScreen.route, page: () => AddChildrenScreen()),
    GetPage(
      name: EditChildScreen.route,
      page: () => EditChildScreen(),
      arguments: Get.arguments,
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
      name: LocationSearchScreen.route,
      page: () => LocationSearchScreen(
        initialValue: Get.arguments?['initialValue'],
        hintText: Get.arguments?['hintText'] ?? 'Search for a location...',
      ),
    ),
    GetPage(
      name: RequestBookingScreen.route,
      page: () => RequestBookingScreen(),
    ),
    GetPage(
      name: BookingSuccessScreen.route,
      page: () => const BookingSuccessScreen(),
    ),

    GetPage(
      name: RequestHistoryScreen.route,
      page: () => const RequestHistoryScreen(),
    ),

    GetPage(
      name: ContractDetailScreen.route,
      page: () => ContractDetailScreen(),
    ),
    GetPage(name: ChatRoomScreen.route, page: () => ChatRoomScreen()),
    GetPage(name: SettingScreen.route, page: () => SettingScreen()),
    GetPage(
      name: ChangePasswordScreen.route,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(
      name: PersonalProfileScreen.route,
      page: () => PersonalProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: LogbookScreen.route, page: () => LogbookScreen()),
    GetPage(name: LogbookDetailScreen.route, page: () => LogbookDetailScreen()),
    GetPage(name: BillingScreen.route, page: () => BillingScreen()),
    GetPage(
      name: BillingHistoryScreen.route,
      page: () => const BillingHistoryScreen(),
    ),
    GetPage(
      name: SubscriptionPlansScreen.route,
      page: () => const SubscriptionPlansScreen(),
    ),
    GetPage(name: RatingReviewScreen.route, page: () => RatingReviewScreen()),
    GetPage(name: SupportScreen.route, page: () => SupportScreen()),
    GetPage(
      name: PrivacyPolicyScreen.route,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: TermsAndConditionsScreen.route,
      page: () => const TermsAndConditionsScreen(),
    ),
    GetPage(
      name: ProfileScreen.route,
      page: () => ProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: ProfilePictureScreen.route,
      page: () => ProfilePictureScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: BookingDetailScreen.route, page: () => BookingDetailScreen()),
    GetPage(
      name: LiveTrackingScreen.route,
      page: () => const LiveTrackingScreen(),
    ),
  ];
}
