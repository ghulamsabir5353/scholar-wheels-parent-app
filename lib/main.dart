import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scholarwheels/controllers/in_it.dart';
import 'package:scholarwheels/controllers/network_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/firebase_options.dart';
import 'package:scholarwheels/routes/app_routes.dart';
import 'package:scholarwheels/screens/auth/splash_screen.dart';
import 'package:scholarwheels/services/fcm_notification_service.dart';
import 'package:scholarwheels/services/deep_link_service.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');
  // Handle background notification here if needed
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Configure System UI for Android navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Pre-cache Google Fonts to avoid network issues in release mode
  await _preCacheFonts();

  await init();

  // Initialize FCM notification service
  FCMNotificationService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
      child: const MyApp(),
    ),
  );
}

/// Pre-cache Google Fonts to prevent network errors in release mode
Future<void> _preCacheFonts() async {
  try {
    await GoogleFonts.pendingFonts([GoogleFonts.plusJakartaSans()]);
    log('Google Fonts cached successfully');
  } catch (e) {
    log('Error caching Google Fonts: $e');
    // Continue with the app even if font caching fails
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Deep Link service after the widget tree is built so that
    // any navigation triggered from deep links happens on a stable tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService().initialize();
    });
  }

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
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            scaffoldBackgroundColor: AppColor.appColorWhite,
            colorScheme: ColorScheme.light(primary: AppColor.primary),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColor.primary,
            ),
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
                child: SafeArea(
                  top: false,
                  bottom: true,
                  left: true,
                  right: true,
                  minimum: EdgeInsets.zero,
                  child: child!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
