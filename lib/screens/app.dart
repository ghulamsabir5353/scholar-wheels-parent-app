import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/screens/auth/get_started_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    requestPermissions();

    // OnesignalService().onNotifiacation();
    // OnesignalService().onNotificationClick();

    _checkPermissions();
    // FirebaseMessagingService().setUpFirebase();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.notification.request().isGranted) {
    } else {
      if (Platform.isAndroid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notification permission is required to use this feature',
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return Obx(() {
      if (!BaseHelper.isLogin.value) {
        return const TabScreen();
      } else {
        return const GetStartedScreen();
      }
    });
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.photos.request();
  }
}
