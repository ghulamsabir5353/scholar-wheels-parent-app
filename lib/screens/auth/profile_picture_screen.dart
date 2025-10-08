import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BaseHelper.getLogo(width: 160, height: 100),
              Column(
                children: [
                  Text(
                    'Profile Picture',
                    style: poppinFonts(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.primary, width: 2),
                    ),
                    child: SvgPicture.asset('assets/images/svg/bag-icon.svg'),
                  ),
                ],
              ),
              SpaceHelper(h: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondary, width: 1),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/svg/share.svg'),
                        SpaceHelper(w: 10.w),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.secondary, width: 1),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/svg/edit.svg'),
                        SpaceHelper(w: 10.w),
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
