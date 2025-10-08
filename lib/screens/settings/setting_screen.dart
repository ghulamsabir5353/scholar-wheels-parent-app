import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';

class SettingScreen extends StatelessWidget {
  static const route = '/settings';
  SettingScreen({super.key});
  final list = [
    "Personal Profile",
    'Change Password',
    "Logbook",
    "Billing & Subscription",
    "Rating and Reviews",
    "Support",
    "Logout",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        leading: backButton(onTap: () => Get.back()),
        title: Text(
          'Profile',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: AppColor.white,
                        child: Image.asset('assets/images/png/profile.png'),
                      ),
                      SpaceHelper(w: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mike",
                            style: poppinFonts(
                              fontSize: base,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "michael.chen@email.com",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Text(
                            "+1 (555) 123-4567",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 4.h),
              Column(
                children: List.generate(list.length, (index) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.w,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 4.w),
                    decoration: BoxDecoration(
                      color: AppColor.lightSecondary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderGreen),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list[index],
                          style: poppinFonts(
                            fontSize: base,
                            color: AppColor.black,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/svg/forward_button.svg',
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
