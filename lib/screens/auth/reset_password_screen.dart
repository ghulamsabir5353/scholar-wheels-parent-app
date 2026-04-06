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

class ResetPasswordScreen extends StatefulWidget {
  static const route = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ForgotPasswordController controller =
      Get.find<ForgotPasswordController>();
  final _formKey = GlobalKey<FormState>();
  bool newPasswordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Get token from arguments and set it
    final args = Get.arguments;
    if (args is Map && args['token'] != null) {
      controller.setResetToken(args['token'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            'Reset Password',
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
                    'Reset Password',
                    style: poppinFonts(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                    ),
                  ),
                  SpaceHelper(h: 8),
                  Text(
                    'Reset Your new Password and login with new password',
                    textAlign: TextAlign.center,
                    style: poppinFonts(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppColor.lightGreenColorText,
                    ),
                  ),
                  SpaceHelper(h: 32),
                  CustomTextField(
                    controller: controller.newPasswordController,
                    label: 'New Password',
                    hintText: 'Enter new password',
                    isObsecure: newPasswordVisible,
                    hasSuffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          newPasswordVisible = !newPasswordVisible;
                        });
                      },
                      child: Icon(
                        newPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SpaceHelper(h: 16),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Confirm new password',
                    isObsecure: confirmPasswordVisible,
                    hasSuffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        });
                      },
                      child: Icon(
                        confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != controller.newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SpaceHelper(h: 32),
                  Obx(
                    () => CustomButton(
                      isLoading: controller.isResettingPassword.value,
                      onPressed: controller.isResettingPassword.value
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                controller.resetPassword();
                              }
                            },
                      title: 'Save Password',
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
