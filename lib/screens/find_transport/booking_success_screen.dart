import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/tab_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  static const route = '/booking-success';

  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 180.w,
                height: 180.w,
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(90.r),
                ),
                child: SvgPicture.asset(
                  'assets/images/svg/verified.svg',
                  width: 180.w,
                  height: 180.w,
                  colorFilter: ColorFilter.mode(
                    AppColor.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SpaceHelper(h: 32.h),

              // Heading
              Text(
                'Request Submitted Successfully!',
                textAlign: TextAlign.center,
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'Your request has been sent to the transport owner.\n',
                  textAlign: TextAlign.center,
                  style: poppinFonts(
                    fontSize: base,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Sub-text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  'We\'ll notify you once the transport owner responds to your request.',
                  textAlign: TextAlign.center,
                  style: poppinFonts(
                    fontSize: sm,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ),
              SpaceHelper(h: 40.h),

              // Back to Home Button
              CustomButton(
                width: double.infinity,
                height: 36.h.toDouble(),
                onPressed: () {
                  // Navigate to home and clear navigation stack
                  Get.offAllNamed(TabScreen.route);
                },
                title: "Back to Home",
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for wavy/scalloped border effect on the badge
class WavyBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveCount = 6;
    final waveHeight = 3.0;
    final waveWidth = size.width / waveCount;

    // Start from top-left
    path.moveTo(0, waveHeight);

    // Create scalloped/wavy top edge
    for (int i = 0; i <= waveCount; i++) {
      final x = i * waveWidth;
      final y = i.isEven ? 0.0 : waveHeight * 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.quadraticBezierTo(
          (i - 0.5) * waveWidth,
          (i - 1).isEven ? waveHeight : 0,
          x,
          y,
        );
      }
    }

    // Right edge
    path.lineTo(size.width, size.height - waveHeight * 2);

    // Create scalloped/wavy bottom edge
    for (int i = waveCount; i >= 0; i--) {
      final x = i * waveWidth;
      final y = i.isEven ? size.height : size.height - waveHeight * 2;
      path.quadraticBezierTo(
        (i + 0.5) * waveWidth,
        i.isEven ? size.height - waveHeight : size.height,
        x,
        y,
      );
    }

    // Close the path
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
