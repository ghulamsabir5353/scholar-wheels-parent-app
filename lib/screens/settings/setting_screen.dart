import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/settings/personal_profile_screen.dart';
import 'package:scholarwheels/screens/settings/change_password_screen.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_screen.dart';
import 'package:scholarwheels/screens/settings/billings/billing_screen.dart';
import 'package:scholarwheels/screens/settings/rating_review_screen.dart';
import 'package:scholarwheels/screens/settings/support_screen.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/custom_button.dart';

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

  /// Get full name from user data
  String _getFullName(user) {
    final firstName = user.firstName ?? '';
    final surName = user.surName ?? '';
    if (firstName.isEmpty && surName.isEmpty) {
      return 'User';
    }
    return '$firstName $surName'.trim();
  }

  /// Get user initials for avatar
  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'U';
    final parts = fullName
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    } else if (parts.length == 1 && parts[0].length == 1) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  void _handleItemTap(String item, BuildContext context) {
    switch (item) {
      case "Logout":
        _showLogoutDialog(context);
        break;
      case "Personal Profile":
        Get.toNamed(PersonalProfileScreen.route);
        break;
      case "Change Password":
        Get.toNamed(ChangePasswordScreen.route);
        break;
      case "Logbook":
        Get.toNamed(LogbookScreen.route);
        break;
      case "Billing & Subscription":
        Get.toNamed(BillingScreen.route);
        break;
      case "Rating and Reviews":
        Get.toNamed(RatingReviewScreen.route);
        break;
      case "Support":
        Get.toNamed(SupportScreen.route);
        break;
      default:
        break;
    }
  }

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
      body: Obx(() {
        final user = BaseHelper.currentUser.value;
        final fullName = _getFullName(user);
        final email = user.email ?? '';
        final phone = user.phone ?? '';
        // Use profileImagePresignedUrl for display (presigned URL from server)
        // Fallback to profileImage if presigned URL is not available
        final profileImageUrl =
            user.profileImagePresignedUrl ?? user.profileImage;
        final initials = _getInitials(fullName);

        return SingleChildScrollView(
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
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                profileImageUrl != null &&
                                    profileImageUrl.isNotEmpty
                                ? Colors.transparent
                                : AppColor.darkPrimary,
                          ),
                          child:
                              profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? ClipOval(
                                  child: CustomNetworkImageWidget(
                                    imageUrl: profileImageUrl,
                                    width: 52.w,
                                    height: 52.w,
                                    borderRadius: 26.w,
                                    fit: BoxFit.cover,
                                    errorWidget: Container(
                                      width: 52.w,
                                      height: 52.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.darkPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          initials,
                                          style: poppinFonts(
                                            color: Colors.white,
                                            fontSize: base,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    initials,
                                    style: poppinFonts(
                                      color: Colors.white,
                                      fontSize: base,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                        SpaceHelper(w: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: poppinFonts(
                                  fontSize: base,
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (email.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    email,
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.textLightBlackColor4A4A4A,
                                    ),
                                  ),
                                ),
                              if (phone.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    phone,
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.textLightBlackColor4A4A4A,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SpaceHelper(h: 4.h),
                Column(
                  children: List.generate(list.length, (index) {
                    return GestureDetector(
                      onTap: () => _handleItemTap(list[index], context),
                      child: Container(
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
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
