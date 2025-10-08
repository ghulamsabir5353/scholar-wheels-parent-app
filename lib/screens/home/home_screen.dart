import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/home/notification_screen.dart';
import 'package:scholarwheels/screens/home/schedule_ride_screen.dart';
import 'package:scholarwheels/screens/settings/setting_screen.dart';

import 'widgets/ride_card_widget.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(SettingScreen.route);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CircleAvatar(
              backgroundColor: AppColor.darkPrimary,
              radius: 16,
              child: Text(
                'A',
                style: poppinFonts(
                  color: AppColor.appColorWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, Aqsa 👋',
              style: poppinFonts(
                color: AppColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Parent Dashboard',
              style: poppinFonts(
                color: AppColor.textLightBlackColor4A4A4A,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(NotificationScreen.route);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(),
                showBadge: true,
                badgeContent: Text(
                  '1',
                  style: poppinFonts(
                    color: AppColor.appColorWhite,
                    fontSize: 12,
                  ),
                ),
                child: Container(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    "assets/images/svg/notification.svg",
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      AppColor.appBlackColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffE7E7E7)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Active Rides",
                            style: poppinFonts(
                              color: AppColor.darkPrimary,
                              fontSize: xs,
                            ),
                          ),
                          Card(
                            color: AppColor.secondary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                '2',
                                style: poppinFonts(color: AppColor.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffE7E7E7)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Requested",
                            style: poppinFonts(
                              color: AppColor.darkPrimary,
                              fontSize: xs,
                            ),
                          ),
                          Card(
                            color: AppColor.secondary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                '2',
                                style: poppinFonts(color: AppColor.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffE7E7E7)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Contracts",
                            style: poppinFonts(
                              color: AppColor.darkPrimary,
                              fontSize: xs,
                            ),
                          ),
                          Card(
                            color: AppColor.secondary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                '2',
                                style: poppinFonts(color: AppColor.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 12.w),
              InkWell(
                onTap: () {
                  Get.toNamed(ScheduleRideScreen.route);
                },
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffECF4E9),
                    border: Border.all(color: AppColor.secondary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Schedule Rides',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                        ),
                      ),
                      SvgPicture.asset('assets/images/svg/forward_button.svg'),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                decoration: BoxDecoration(
                  gradient: AppColor.cardLinearGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColor.darkPrimary,
                      child: Image.asset('assets/images/png/bus-icon.png'),
                    ),
                    SpaceHelper(w: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next Ride",
                            style: poppinFonts(
                              color: AppColor.appColorWhite,
                              fontSize: base,
                            ),
                          ),
                          Text(
                            "Emma → Lincoln",
                            style: poppinFonts(
                              color: AppColor.appColorWhite,
                              fontSize: sm,
                            ),
                          ),
                          Text(
                            "Elementary at 7:30 AM",
                            style: poppinFonts(
                              color: AppColor.appColorWhite,
                              fontSize: sm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      width: 100.w,
                      height: 32.h,
                      radius: 8,
                      onPressed: () {},
                      title: 'View on Map',
                    ),
                  ],
                ),
              ),
              Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                    child: RideCard(),
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
