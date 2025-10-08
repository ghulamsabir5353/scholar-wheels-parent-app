import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';

class RequestBookingScreen extends StatelessWidget {
  static const route = '/request-booking';
  const RequestBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          'Request Booking',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Route',
                    style: poppinFonts(fontSize: base, color: AppColor.black),
                  ),
                  Text(
                    'Route 4',
                    style: poppinFonts(
                      fontSize: base,
                      color: AppColor.headingFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 12.w),
              CustomTextField(
                label: "Rephrase to Preferred Pickup Time",
                hintText: "Add Time",
              ),
              CustomTextField(
                label: "Standard School Knock Off Time",
                hintText: "Add Time",
              ),
              CustomTextField(
                label: "Contract Starting from",
                hintText: "Add Date",
              ),
              CustomTextField(label: "Contract End On", hintText: "Add Date"),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.secondary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: poppinFonts(
                            fontWeight: FontWeight.w500,
                            fontSize: base,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(RequestBookingScreen.route);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 36.h,

                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Request Sent",
                            style: poppinFonts(
                              fontWeight: FontWeight.w500,
                              fontSize: base,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
