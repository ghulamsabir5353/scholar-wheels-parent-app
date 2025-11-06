import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

/// Reusable widget for displaying pickup and school information
/// with icons and dotted connecting lines
class RouteEntryWidget extends StatelessWidget {
  final String pickupAddress;
  final String schoolName;
  final bool isLast;
  final Color? backgroundColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Border? border;

  const RouteEntryWidget({
    super.key,
    required this.pickupAddress,
    required this.schoolName,
    this.isLast = false,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: border,
      ),
      margin: margin ?? EdgeInsets.only(bottom: isLast ? 0 : 12.w),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side with icons and dotted line
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pickup icon
              Container(
                width: 30.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.gray.withOpacity(0.8),
                      blurRadius: 1.5.r,
                      offset: Offset(0, 1.5.r),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/svg/pickup.svg',
                    width: 18.w,
                    height: 18.w,
                    colorFilter: ColorFilter.mode(
                      AppColor.textLightBlackColor4A4A4A,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              // Dotted vertical line connecting pickup to school
              SizedBox(
                height: 24.h,
                child: CustomPaint(painter: DottedLinePainter()),
              ),
              // School icon
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.gray.withOpacity(0.8),
                      blurRadius: 1.5.r,
                      offset: Offset(0, 1.5.r),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/svg/school.svg',
                    width: 18.w,
                    height: 18.w,
                    colorFilter: ColorFilter.mode(
                      AppColor.textLightBlackColor4A4A4A,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SpaceHelper(w: 6.w),
          // Right side with labels and addresses
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup point
                Text(
                  'Pickup:',
                  style: poppinFonts(
                    color: AppColor.textLightBlackColor4A4A4A,
                    fontSize: xs,
                  ),
                ),
                SpaceHelper(h: 2.h),
                Text(
                  pickupAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 22.h,
                  child: CustomPaint(painter: HorizontalDottedLinePainter()),
                ),
                // School
                Text(
                  'School:',
                  style: poppinFonts(
                    color: AppColor.textLightBlackColor4A4A4A,
                    fontSize: xs,
                  ),
                ),
                SpaceHelper(h: 3.h),
                Text(
                  schoolName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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

/// Custom painter for dotted horizontal line
class HorizontalDottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.black
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
