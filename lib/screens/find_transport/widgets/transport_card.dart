import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart' show AppColor;
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/find_transport/request_booking_screen.dart';

class TransportCard extends StatelessWidget {
  const TransportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.darkPrimary,
                  radius: 20,
                  child: Text(
                    "A",
                    style: poppinFonts(
                      color: AppColor.appColorWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SpaceHelper(w: 6.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Transport company',
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SpaceHelper(w: 3.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.lightSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Verified",
                            style: poppinFonts(
                              color: AppColor.primary,
                              fontSize: xs,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColor.darkSecondary,
                          size: 16,
                        ),
                        Text(
                          '4.9 (345 rides)',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SpaceHelper(h: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Color(0xffECF4E9),
                border: Border.all(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/svg/bus-icon.svg'),

                      SpaceHelper(w: 6.w),

                      Text(
                        'Toyota Hiace',
                        style: poppinFonts(
                          color: AppColor.primary,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SpaceHelper(h: 3.w),
                  Container(
                    width: double.infinity,

                    child: Wrap(
                      children: List.generate(3, (index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.w,
                          ),
                          margin: EdgeInsets.only(
                            right: 6.w,
                            top: 6.w,
                            bottom: 6.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.lightSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Child Safety Locks",
                            style: poppinFonts(
                              color: AppColor.primary,
                              fontSize: xs,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  SpaceHelper(h: 3.w),

                  Row(
                    children: [
                      Text(
                        '\$25-30/day',
                        style: poppinFonts(
                          color: Color(0xff480B07),
                          fontSize: xs,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SpaceHelper(h: 12.w),
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
                        "View Detail",
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
                          "Request Booking",
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
    );
  }
}
