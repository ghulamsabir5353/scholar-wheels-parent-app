import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffFFFFFF),
        body: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Easy Child Management',
                      style: poppinFonts(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Add your children and manage their school rides with just a few taps',
                      textAlign: TextAlign.center,
                      style: poppinFonts(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: AppColor.lightGreenColorText,
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                  title: "Next",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
