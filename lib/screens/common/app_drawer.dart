import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/bookings/request_history_screen.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_screen.dart';
import 'package:scholarwheels/screens/settings/privacy_policy_screen.dart';
import 'package:scholarwheels/screens/settings/terms_and_conditions_screen.dart';

class AppDrawer extends StatelessWidget {
  final void Function(int tabIndex) onSelectTab;
  final String? userName;

  const AppDrawer({super.key, required this.onSelectTab, this.userName});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColor.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Logout',
                      style: poppinFonts(
                        fontSize: xl,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24.w),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SpaceHelper(h: 12.w),
                // Confirmation Message
                Text(
                  'Are You sure? You want to logout this account.',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
                SpaceHelper(h: 20.w),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColor.bgGrayD9D8D8,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: poppinFonts(
                                fontSize: base,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SpaceHelper(w: 12.w),
                    Expanded(
                      child: CustomButton(
                        height: 36.h,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BaseHelper.signOut();
                        },
                        title: 'Logout',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0.r),
          bottomRight: Radius.circular(0.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: 42.h,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.darkPrimary,
                    radius: 20,
                    child: Text(
                      (userName?.isNotEmpty == true
                              ? userName!.substring(0, 1)
                              : 'A')
                          .toUpperCase(),
                      style: poppinFonts(
                        color: AppColor.appColorWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, 👋',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (userName != null)
                        Text(
                          userName ?? 'Hello, 👋',
                          style: poppinFonts(
                            color: AppColor.textLightBlackColor4A4A4A,
                            fontSize: sm,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SpaceHelper(h: 16.w),
            _item(
              icon: 'assets/images/svg/home_icon.svg',
              label: 'Home',
              onTap: () {
                Navigator.pop(context);
                onSelectTab(0);
              },
            ),
            _item(
              icon: 'assets/images/svg/children_icon.svg',
              label: 'Children',
              onTap: () {
                Navigator.pop(context);
                onSelectTab(1);
              },
            ),
            _item(
              icon: 'assets/images/svg/find_icon.svg',
              label: 'Find Transport',
              onTap: () {
                Navigator.pop(context);
                onSelectTab(2);
              },
            ),
            _item(
              icon: 'assets/images/svg/booking_icon.svg',
              label: 'Booking Requests',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(RequestHistoryScreen.route);
              },
            ),
            _item(
              icon: 'assets/images/svg/booking_icon.svg',
              label: 'Contracts',
              onTap: () {
                Navigator.pop(context);
                onSelectTab(3);
              },
            ),

            _item(
              icon: 'assets/images/svg/chat_icon.svg',
              label: 'Chat',
              onTap: () {
                Navigator.pop(context);
                onSelectTab(4);
              },
            ),
            _item(
              icon: 'assets/images/svg/logbook.svg',
              label: 'Logbook',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(LogbookScreen.route);
              },
            ),
            _item(
              icon: 'assets/images/svg/privicy.svg',
              label: 'Privacy Policy',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(PrivacyPolicyScreen.route);
              },
            ),
            _item(
              icon: 'assets/images/svg/privicy.svg',
              label: 'Terms & Conditions',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(TermsAndConditionsScreen.route);
              },
            ),
            const Spacer(),
            _item(
              icon: 'assets/images/svg/logout_icon.svg',
              label: 'Logout',
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // add some paddingg to the list tile
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      leading: SvgPicture.asset(icon, width: 24.w, height: 24.w),
      title: Text(
        label,
        style: poppinFonts(
          color: AppColor.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
