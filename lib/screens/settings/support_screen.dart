import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/settings/privacy_policy_screen.dart';
import 'package:scholarwheels/screens/settings/terms_and_conditions_screen.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';
import '../../core/helper.widgets/custom_button.dart';
import '../../core/helper.widgets/custom_textfield.dart';

class SupportScreen extends StatelessWidget {
  static const route = '/support';
  SupportScreen({super.key});
  final list = ["Privicy Policy", "Terms & Condidtion"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(onTap: () => Get.back()),

        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          'Support',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // SpaceHelper(h: 16.h),
              // Text(
              //   'Contact Support',
              //   style: poppinFonts(
              //     fontSize: base,
              //     color: AppColor.black,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // SpaceHelper(h: 6.h),
              // CustomTextField(label: "Subject", hintText: "Enter Subject"),

              // CustomTextField(
              //   label: "Message",
              //   hintText: "Describe your issue in detail",
              // ),

              // CustomButton(
              //   height: 36.h,
              //   title: "Send to Support",
              //   onPressed: () {},
              // ),

              // SpaceHelper(h: 16.h),
              // // add here other way to reach us like supor email phone hours as
              // SizedBox(
              //   width: double.infinity,

              //   child: Card(
              //     color: AppColor.white,
              //     elevation: 1,
              //     child: Padding(
              //       padding: EdgeInsets.all(12.w),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           // title
              //           Text(
              //             "Other ways to reach us",
              //             style: poppinFonts(
              //               fontSize: base,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //           SpaceHelper(h: 4.h),
              //           Text(
              //             "support@scholarwheels.com",
              //             style: poppinFonts(fontSize: sm),
              //           ),
              //           Text(
              //             "Phone: +1 (555) 123-4567",
              //             style: poppinFonts(fontSize: sm),
              //           ),
              //           Text(
              //             "Hours: 9:00 AM - 5:00 PM",
              //             style: poppinFonts(fontSize: sm),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleItemTap(String item, BuildContext context) {
    if (item == "Privicy Policy") {
      Get.toNamed(PrivacyPolicyScreen.route);
    } else if (item == "Terms & Condidtion") {
      Get.toNamed(TermsAndConditionsScreen.route);
    }
  }
}
