import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/controllers/network_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/routes/app_routes.dart';
import 'package:scholarwheels/screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColor.appColorWhite,
      ),
      fallbackLocale: const Locale('en', 'US'),
      defaultTransition: Transition.topLevel,
      initialRoute: SplashScreen.route,
      getPages: AppRoutes.pages,
      navigatorKey: Get.key,
      builder: EasyLoading.init(),
    );
  }
}
