import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/auth/profile_screen.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 52),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Profile Picture',
                    style: poppinFonts(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Circular avatar placeholder (default initials or icon).',
                    textAlign: TextAlign.center,
                    style: poppinFonts(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppColor.lightGreenColorText,
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondary, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.share, color: AppColor.primary),
                        Text(
                          'Upload Photo',
                          style: poppinFonts(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondary, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColor.primary),
                        Text(
                          'Edit Photo',
                          style: poppinFonts(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 24),
              CustomButton(
                onPressed: () {
                  Get.to(() => ProfileScreen());
                },
                title: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
