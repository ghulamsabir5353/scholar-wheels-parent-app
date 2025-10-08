import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // TextScaler textScaler = MediaQuery.textScalerOf(context).clamp(
    //   minScaleFactor: appTextScaleFactor,
    //   maxScaleFactor: 1.3 * appTextScaleFactor,
    // );
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: isTablet
          ? const Size(834, 1194) // iPad Air logical size
          : const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
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
          builder: EasyLoading.init(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
