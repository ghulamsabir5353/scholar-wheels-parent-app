import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';

import '../../core/helper.widgets/space_helper.dart';

class SetAccountForChildScreen extends StatefulWidget {
  static const route = '/set-account-for-child-screen';
  const SetAccountForChildScreen({super.key});

  @override
  State<SetAccountForChildScreen> createState() =>
      _SetAccountForChildScreenState();
}

class _SetAccountForChildScreenState extends State<SetAccountForChildScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final ChildController childController = Get.find<ChildController>();

      // Validate that passwords match
      if (childController.passwordController.text !=
          confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Call the create child API
      await childController.addChild();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChildController childController = Get.find<ChildController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        centerTitle: false,
        title: Text(
          'Set Account For Child',
          style: poppinFonts(fontSize: base, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.w),
            child: Column(
              children: [
                CustomTextField(
                  controller: childController.emailController,
                  label: "Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
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
                SpaceHelper(h: 3.h),
                CustomTextField(
                  controller: childController.passwordController,
                  label: "Password",
                  hintText: "Enter Password",
                  isObsecure: passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  hasSuffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                SpaceHelper(h: 3.h),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  hintText: "Enter Confirm Password",
                  isObsecure: confirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != childController.passwordController.text) {
                      return 'Passwords do not match';
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

                SpaceHelper(h: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
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
                          width: double.infinity,
                          title: "Save",
                          isLoading: childController.isLoading.value,
                          onPressed: childController.isLoading.value
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
    );
  }
}
