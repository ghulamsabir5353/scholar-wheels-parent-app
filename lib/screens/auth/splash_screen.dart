import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/screens/app.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    2.delay(() {
      Get.offAll(() => const AppScreen(), transition: Transition.downToUp);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColorWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(52.0),
          child: Text("Hello"),
          // child: Image.asset(
          //   'assets/images/png/logo.png',
          //   scale: 3,
          // ),
        ),
      ),
    );
  }
}
