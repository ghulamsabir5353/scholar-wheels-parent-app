import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/forgot_password_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import '../../core/helper.constants/textStyle.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const route = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final _formKey = GlobalKey<FormState>();

    return KeyboardNavigator(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          centerTitle: false,
          titleSpacing: 0,
          leading: backButton(onTap: () => Get.back()),
          title: Text(
            'Forgot Password',
            style: poppinFonts(
              fontSize: 18,
              color: AppColor.headingFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  BaseHelper.getLogo(width: 160, height: 80),

                  Text(
                    'Forgot Password?',
                    style: poppinFonts(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                    ),
                  ),
                  SpaceHelper(h: 8),
                  Text(
                    'Don\'t worry, it happens. Enter your email to reset your password.',
                    textAlign: TextAlign.center,
                    style: poppinFonts(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppColor.lightGreenColorText,
                    ),
                  ),
                  SpaceHelper(h: 32),
                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SpaceHelper(h: 24),
                  Obx(
                    () => CustomButton(
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                controller.sendForgotPasswordRequest();
                              }
                            },
                      title: 'Send Reset Link',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
