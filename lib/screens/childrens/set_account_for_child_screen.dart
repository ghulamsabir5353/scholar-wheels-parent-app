import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';

import '../../core/helper.widgets/space_helper.dart';

class SetAccountForChildScreen extends StatefulWidget {
  static const route = '/set-account-for-child-screen';
  const SetAccountForChildScreen({super.key});

  @override
  State<SetAccountForChildScreen> createState() =>
      _SetAccountForChildScreenState();
}

class _SetAccountForChildScreenState extends State<SetAccountForChildScreen> {
  bool passwordVisible = false;
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
          'Set Account For Child',
          style: poppinFonts(fontSize: base, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.w),
          child: Column(
            children: [
              CustomTextField(label: "Email", hintText: "Enter Email"),
              CustomTextField(
                label: "Password",
                hintText: "Enter Password",
                isObsecure: passwordVisible,
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

              SpaceHelper(h: 12.w),
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
