import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const route = '/terms-and-conditions';
  const TermsAndConditionsScreen({super.key});

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
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          'Terms & Conditions',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Introduction',
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 24.w),
              Text(
                'Acceptance of Terms',
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              Text(
                'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 24.w),
              Text(
                'User Obligations',
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              Text(
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 24.w),
              Text(
                'Limitation of Liability',
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              Text(
                'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 24.w),
              Text(
                'Changes to Terms',
                style: poppinFonts(
                  fontSize: xl,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              Text(
                'If you have any questions about these Terms & Conditions, please contact us at support@scholarwheels.com.',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
