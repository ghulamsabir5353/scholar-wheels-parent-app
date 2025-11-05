import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import '../../core/helper.constants/textStyle.dart';

class SignupScreen extends StatefulWidget {
  static const route = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  bool passwordVisible = true;
  bool reEnterPasswordVisible = true;

  void _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.registerParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                BaseHelper.getLogo(width: 160, height: 100),
                Column(
                  children: [
                    Text(
                      'Join School Wheels',
                      style: poppinFonts(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'Welcome, Please create your account ',
                      textAlign: TextAlign.center,
                      style: poppinFonts(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: AppColor.lightGreenColorText,
                      ),
                    ),
                  ],
                ),
                SpaceHelper(h: 16),
                CustomTextField(
                  controller: authController.firstNameController,
                  label: 'First Name',
                  hintText: 'Enter your first name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: authController.surNameController,
                  label: 'Surname',
                  hintText: 'Enter your surname',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Surname is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: authController.emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: authController.phoneController,
                  label: 'Phone Number',
                  hintText: 'Enter your phone',
                  isNumericKeyboard: true,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: authController.passwordController,
                  label: 'Password',
                  hintText: "Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  isObsecure: passwordVisible,
                  hasSuffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    child: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                ),
                CustomTextField(
                  controller: authController.confirmPasswordController,
                  label: 'Confirm Password',
                  hintText: "Re Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != authController.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  isObsecure: reEnterPasswordVisible,
                  hasSuffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        reEnterPasswordVisible = !reEnterPasswordVisible;
                      });
                    },
                    child: Icon(
                      reEnterPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                ),
                SpaceHelper(h: 12),
                Obx(
                  () => CustomButton(
                    isLoading: authController.isLoading.value,
                    onPressed: authController.isLoading.value
                        ? null
                        : _handleSignup,
                    title: 'Sign up',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          " Sign in",
                          style: poppinFonts(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
