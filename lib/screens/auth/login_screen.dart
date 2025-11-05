import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
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
  final AuthController authController = Get.find<AuthController>();
  final List<FocusNode> _focusNodes = [];
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes for accessibility
    for (int i = 0; i < 3; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.login(
        email: authController.emailController.text.trim(),
        password: authController.passwordController.text,
        role: "parent",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardNavigator(
      child: Scaffold(
        body: Semantics(
          label: 'Login screen',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Semantics(
                      label: 'Scholar Wheels logo',
                      image: true,
                      child: BaseHelper.getLogo(width: 160, height: 100),
                    ),
                    Semantics(
                      label: 'Welcome message and instructions',
                      child: Column(
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
                    ),
                    SpaceHelper(h: 16),
                    CustomTextField(
                      controller: authController.emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      semanticLabel: 'Email address',
                      semanticHint: 'Enter your email address to login',
                      focusNode: _focusNodes[0],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: authController.passwordController,
                      label: 'Password',
                      hintText: "Enter your password",
                      semanticLabel: 'Password',
                      semanticHint: 'Enter your password to login',
                      focusNode: _focusNodes[1],
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
                          passwordVisible
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
                        semanticLabel: 'Login button',
                        semanticHint: 'Tap to login to your account',
                        onPressed: authController.isLoading.value
                            ? null
                            : _handleLogin,
                        title: 'Login',
                      ),
                    ),
                    Semantics(
                      label: 'Sign up link',
                      child: Padding(
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
                                fontSize: 12,
                              ),
                            ),
                            Semantics(
                              label: 'Sign up',
                              hint: 'Tap to create a new account',
                              button: true,
                              onTap: () {
                                Get.toNamed(SignupScreen.route);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(SignupScreen.route);
                                },
                                child: Text(
                                  " Sign up",
                                  style: poppinFonts(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
