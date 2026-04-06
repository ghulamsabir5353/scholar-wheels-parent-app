import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/screens/childrens/edit_child_screen.dart';

import '../../../core/helper.widgets/space_helper.dart';

class ChildCard extends StatelessWidget {
  final ChildModel child;

  const ChildCard({super.key, required this.child});

  /// Get first letter of child's name for avatar
  String _getInitial() {
    if (child.name != null && child.name!.isNotEmpty) {
      return child.name![0].toUpperCase();
    }
    return 'A';
  }

  /// Get status - default to Active
  String _getStatus() {
    return child.user?.status?.capitalizeFirst ?? 'Active';
  }

  void _showDeleteDialog() {
    final ChildController childController = Get.find<ChildController>();

    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          backgroundColor: AppColor.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Child',
                      style: poppinFonts(
                        fontSize: lg,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close, size: 24.w),
                    ),
                  ],
                ),

                // SpaceHelper(h: 12.w),
                // // Child Info
                // Text(
                //   child.name ?? 'Child',
                //   style: poppinFonts(
                //     fontSize: base,
                //     fontWeight: FontWeight.w600,
                //     color: AppColor.black,
                //   ),
                // ),
                SpaceHelper(h: 12.w),
                // Confirmation Message
                Text(
                  'Are you sure? You want to delete this child.',
                  style: poppinFonts(fontSize: sm, color: AppColor.black),
                ),
                SpaceHelper(h: 16.w),
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
                      child: Obx(
                        () => CustomButton(
                          height: 36.h,
                          onPressed: childController.isLoading.value
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                  childController.deleteChild(child.id ?? '');
                                },
                          title: 'Delete',
                          isLoading: childController.isLoading.value,
                        ),
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
    return Card(
      elevation: 2,
      shadowColor: AppColor.cardShadowColor,
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Avatar, Name, Age, Status
            Row(
              children: [
                // Avatar
                ClipOval(
                  child: () {
                    final profileImageUrl =
                        child.user?.profileImagePresignedUrl ??
                        child.user?.profileImage;
                    final hasImage =
                        profileImageUrl != null && profileImageUrl.isNotEmpty;

                    return hasImage
                        ? CustomNetworkImageWidget(
                            imageUrl: profileImageUrl,
                            width: 56.w,
                            height: 56.w,
                            borderRadius: 28.w,
                            fit: BoxFit.cover,
                            errorWidget: Container(
                              width: 56.w,
                              height: 56.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.darkPrimary,
                              ),
                              child: Center(
                                child: Text(
                                  _getInitial(),
                                  style: poppinFonts(
                                    color: AppColor.white,
                                    fontSize: base,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.darkPrimary,
                            ),
                            child: Center(
                              child: Text(
                                _getInitial(),
                                style: poppinFonts(
                                  color: AppColor.white,
                                  fontSize: base,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                  }(),
                ),
                SpaceHelper(w: 12.w),
                // Name and Age
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name ?? 'Child',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SpaceHelper(h: 4.h),
                      Text(
                        'Age ${child.age ?? 'N/A'}',
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                    ],
                  ),
                ),
                // Active Status Tag
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightSecondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatus(),
                    style: poppinFonts(
                      fontSize: sm,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SpaceHelper(h: 16.h),

            // Middle Section: Location Details with green background
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColor.cardBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Details Title
                  Text(
                    'Location Details',
                    style: poppinFonts(
                      fontSize: sm,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SpaceHelper(h: 12.h),
                  // Pickup and School with icons and dotted line
                  RouteEntryWidget(
                    pickupAddress: child.pickUpAddressDescription ?? '',
                    schoolName: child.schoolDescription ?? '',
                    backgroundColor: AppColor.cardBgColor,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            SpaceHelper(h: 16.h),

            // Bottom Section: Action Buttons
            Row(
              children: [
                // Delete Button
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDeleteDialog();
                    },
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          color: AppColor.borderGreen,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Delete',
                          style: poppinFonts(
                            fontSize: base,

                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SpaceHelper(w: 12.w),
                // Edit Details Button
                Expanded(
                  child: CustomButton(
                    height: 36.h,
                    width: double.infinity,
                    onPressed: () {
                      Get.toNamed(EditChildScreen.route, arguments: child.id);
                    },
                    title: 'Edit Details',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for dotted vertical line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.textLightBlackColor4A4A4A
      ..strokeWidth = 1.5;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
