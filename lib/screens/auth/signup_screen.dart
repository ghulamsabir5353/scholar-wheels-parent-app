import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/auth/profile_picture_screen.dart';

import '../../core/helper.constants/textStyle.dart';

class SignupScreen extends StatefulWidget {
  static const route = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool reEnterPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 52),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  label: 'Email',
                  hintText: 'Enter your email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Phone Number',
                  hintText: 'Enter your phone',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Password',
                  hintText: "Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
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
                  label: 'Confirm Password',
                  hintText: "Re Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
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
                CustomButton(
                  onPressed: () {
                    Get.to(() => ProfilePictureScreen());
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                    }
                  },
                  title: 'Sign up',
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
