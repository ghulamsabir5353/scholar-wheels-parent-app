import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';

class GetStartedScreen extends StatefulWidget {
  static const route = '/get_started';
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool check = false;
  final globaleKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    requestPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.unfocus();
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffFFFFFF),
      body: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/png/get_started_screen_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // Gradient overlay for better text readability (optional)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Content on top
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    const Spacer(),
                    // Logo at top

                    // Spacer to push content down

                    // Text and button section at bottom
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BaseHelper.getWhiteLogo(width: 160.w, height: 100.h),
                        Text(
                          'Easy Child Management',
                          style: poppinFonts(
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                            color: AppColor.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            'Add your children and manage their school rides with just a few taps',
                            textAlign: TextAlign.center,
                            style: poppinFonts(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomButton(
                          onPressed: () {
                            Get.to(() => LoginScreen());
                          },
                          title: "Next",
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
