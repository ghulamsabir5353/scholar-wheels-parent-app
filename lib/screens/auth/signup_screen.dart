import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/validators.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/settings/terms_and_conditions_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool hasAcceptedTerms = false;

  void _handleSignup() async {
    // User must accept terms & subscription before signing up
    if (!hasAcceptedTerms) {
      Get.snackbar(
        'Terms required',
        'Please accept the Terms & Conditions and subscription policy to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

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
                SpaceHelper(h: 20.h),
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
                  label: 'Sur Name',
                  hintText: 'Enter your Sur Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sur Name is required';
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
                  hintText: 'e.g. 0821234567',
                  isNumericKeyboard: true,
                  keyboardType: TextInputType.phone,
                  maxLength: Validators.southAfricaPhoneMaxLength,
                  validator: Validators.validateSouthAfricaPhone,
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
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      width: 12.w,
                      height: 12.h,
                      child: SvgPicture.asset(
                        passwordVisible
                            ? 'assets/images/svg/visible_eye.svg'
                            : 'assets/images/svg/visible_eye_off.svg',
                      ),
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
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      width: 12.w,
                      height: 12.h,
                      child: SvgPicture.asset(
                        reEnterPasswordVisible
                            ? 'assets/images/svg/visible_eye.svg'
                            : 'assets/images/svg/visible_eye_off.svg',
                      ),
                    ),
                  ),
                ),
                SpaceHelper(h: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: hasAcceptedTerms,
                      activeColor: AppColor.primary,
                      onChanged: (value) {
                        setState(() {
                          hasAcceptedTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Get.toNamed(TermsAndConditionsScreen.route);
                          // https://scholarwheels.co.za/terms-condition
                          launchUrl(
                            Uri.parse(
                              'https://scholarwheels.co.za/terms-condition',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: poppinFonts(
                              fontSize: 12.sp,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                            children: [
                              const TextSpan(
                                text: 'By signing up, you agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: poppinFonts(
                                  fontSize: 12.sp,
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and subscription policy.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
