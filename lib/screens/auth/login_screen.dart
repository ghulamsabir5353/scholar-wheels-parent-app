import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/auth/signup_screen.dart';

import '../../core/helper.constants/textStyle.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
                  label: 'Password',
                  hintText: "Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),
                SpaceHelper(h: 12),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                    }
                  },
                  title: 'Login',
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
                        "If You didn't have a account then",
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(SignupScreen.route);
                        },
                        child: Text(
                          " Sign up",
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
