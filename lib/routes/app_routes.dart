import 'package:get/get.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';
import 'package:scholarwheels/screens/auth/signup_screen.dart';
import 'package:scholarwheels/screens/auth/splash_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

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
  ];
}
