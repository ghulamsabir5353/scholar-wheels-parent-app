import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/billing_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/screens/auth/get_started_screen.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    2.delay(() => _checkAndNavigate());
  }

  /// Priority: not login → profile (roleData) → subscription → dashboard.
  Future<void> _checkAndNavigate() async {
    if (!BaseHelper.isLogin.value) {
      Get.offAllNamed(GetStartedScreen.route);
      return;
    }
    if (BaseHelper.currentUser.value.roleData == null) {
      customToaster(
        'Please complete your profile to continue',
        color: Colors.red,
      );
      Get.offAllNamed(ProfilePictureScreen.route);
      return;
    }
    try {
      final billing = Get.isRegistered<BillingController>()
          ? Get.find<BillingController>()
          : Get.put(BillingController());
      await billing.fetchMySubscription();
    } catch (_) {}
    if (!BaseHelper.isLogin.value) {
      Get.offAllNamed(GetStartedScreen.route);
      return;
    }
    final hasSubscription =
        BaseHelper.mySubscription.value?.hasActiveSubscription == true;
    if (hasSubscription) {
      Get.offAllNamed(TabScreen.route);
    } else {
      Get.offAllNamed(SubscriptionPlansScreen.route);
    }
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
