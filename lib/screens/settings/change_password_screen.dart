import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';

import '../../core/helper.widgets/space_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const route = '/change-password-screen';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate that new password and confirm password match
      if (authController.newPasswordController.text !=
          authController.confirmNewPasswordController.text) {
        Get.snackbar(
          'Error',
          'New password and confirm password do not match',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await authController.changePassword();
    }
  }

  void _clearFields() {
    authController.currentPasswordController.clear();
    authController.newPasswordController.clear();
    authController.confirmNewPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _clearFields();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          leading: backButton(onTap: () => Get.back()),
          centerTitle: false,
          title: Text(
            'Change Password',
            style: poppinFonts(fontSize: base, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: authController.currentPasswordController,
                    label: "Current Password",
                    hintText: "Enter Current Password",
                    isObsecure: currentPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                    hasSuffixIcon: IconButton(
                      icon: Icon(
                        currentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.black,
                      ),
                      onPressed: () {
                        setState(() {
                          currentPasswordVisible = !currentPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SpaceHelper(h: 12.h),
                  CustomTextField(
                    controller: authController.newPasswordController,
                    label: "New Password",
                    hintText: "Enter New Password",
                    isObsecure: newPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    hasSuffixIcon: IconButton(
                      icon: Icon(
                        newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.black,
                      ),
                      onPressed: () {
                        setState(() {
                          newPasswordVisible = !newPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SpaceHelper(h: 12.h),
                  CustomTextField(
                    controller: authController.confirmNewPasswordController,
                    label: "Confirm Password",
                    hintText: "Enter Confirm Password",
                    isObsecure: confirmPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password is required';
                      }
                      return null;
                    },
                    hasSuffixIcon: IconButton(
                      icon: Icon(
                        confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.black,
                      ),
                      onPressed: () {
                        setState(() {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        });
                      },
                    ),
                  ),

                  SpaceHelper(h: 24.h),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _clearFields();
                            Get.back();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 36.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.secondary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: poppinFonts(
                                  fontWeight: FontWeight.w500,
                                  fontSize: base,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SpaceHelper(w: 12.w),
                      Expanded(
                        child: Obx(
                          () => CustomButton(
                            height: 36.h,
                            radius: 8,
                            title: "Save",
                            isLoading: authController.isLoading.value,
                            onPressed: authController.isLoading.value
                                ? null
                                : _handleSave,
                          ),
                        ),
                      ),
                    ],
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
