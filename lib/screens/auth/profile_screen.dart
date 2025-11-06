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

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _loadExistingUserData();
  }

  void _loadExistingUserData() {
    // Load existing user data from signup to pre-fill the form
    if (!_hasLoadedData) {
      final user = BaseHelper.currentUser.value;

      // Pre-fill email if available
      if (user.email != null && user.email!.isNotEmpty) {
        authController.emailController.text = user.email!;
      }

      // Pre-fill first name if available
      if (user.firstName != null && user.firstName!.isNotEmpty) {
        authController.firstNameController.text = user.firstName!;
      }

      // Pre-fill surname if available
      if (user.surName != null && user.surName!.isNotEmpty) {
        authController.surNameController.text = user.surName!;
      }

      // Pre-fill phone if available
      if (user.phone != null && user.phone!.isNotEmpty) {
        authController.phoneController.text = user.phone!;
      }

      _hasLoadedData = true;
    }
  }

  void _handleCompleteProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.completeProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  BaseHelper.getLogo(width: 160, height: 90),
                  Column(
                    children: [
                      Text(
                        'Complete Your Profile',
                        style: poppinFonts(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),
                      Text(
                        'Let\'s set up your account for a personalized experience.',
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: authController.firstNameController,
                          label: 'First Name',
                          hintText: 'Enter First Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SpaceHelper(w: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: authController.surNameController,
                          label: 'Surname',
                          hintText: 'Enter Surname',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Surname is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: authController.cityController,
                          label: 'City',
                          hintText: 'Enter City',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SpaceHelper(w: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: authController.zipCodeController,
                          label: 'Zip Code',
                          hintText: 'Enter Code',
                          isNumericKeyboard: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Zip code is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: authController.addressController,
                    label: 'Address',
                    hintText: 'Enter your address',
                    height: 120,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  SpaceHelper(h: 16.h),
                  Obx(
                    () => CustomButton(
                      isLoading: authController.isLoading.value,
                      onPressed: authController.isLoading.value
                          ? null
                          : _handleCompleteProfile,
                      title: 'Complete Profile',
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
