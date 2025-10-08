import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
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
      Get.offAll(
        () => const AppScreen(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 800),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(52.w),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0), // 👈 start small → full size
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutBack, // 👈 smooth bounce effect
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: BaseHelper.getLogo(width: 320, height: 320),
          ),
        ),
      ),
    );
  }
}
