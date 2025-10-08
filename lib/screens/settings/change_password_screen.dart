import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';

import '../../core/helper.widgets/space_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const route = 'change-password-screen';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
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
          'Change Password',
          style: poppinFonts(fontSize: base, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            children: [
              CustomTextField(
                label: "Current Password",
                hintText: "Enter Current Password",
                isObsecure: currentPasswordVisible,
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
              CustomTextField(
                label: "New Password",
                hintText: "Enter New Password",
                isObsecure: newPasswordVisible,
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
              CustomTextField(
                label: "Confirm Password",
                hintText: "Enter Password Password",
                isObsecure: confirmPasswordVisible,
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

              Row(
                children: [
                  Expanded(
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
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        border: Border.all(color: AppColor.secondary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: poppinFonts(
                            fontWeight: FontWeight.w500,
                            fontSize: base,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
