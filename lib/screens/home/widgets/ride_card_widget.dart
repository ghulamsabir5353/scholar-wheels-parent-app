import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';

import '../../../core/helper.widgets/custom_button.dart';
import '../../../core/helper.widgets/space_helper.dart';

class RideCard extends StatelessWidget {
  const RideCard({super.key});

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
                Text(
                  'Active Rides',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Track your child’s current ride in real-time',
                  style: poppinFonts(
                    fontSize: sm,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 7.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Color(0xffECF4E9),
                border: Border.all(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emma Johnson',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                        ),
                      ),
                      SpaceHelper(h: 1.w),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/clock.svg'),
                          SpaceHelper(w: 6.w),
                          Text(
                            'ETA: Now',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: sm,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 2.w),
                      Text(
                        'Home → Lincoln Elementary',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightSecondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Arrived",
                      style: poppinFonts(color: AppColor.primary, fontSize: sm),
                    ),
                  ),
                ],
              ),
            ),
            SpaceHelper(h: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
              decoration: BoxDecoration(
                color: Color(0xffECF4E9),
                border: Border.all(color: AppColor.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emma Johnson',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                        ),
                      ),
                      SpaceHelper(h: 1.w),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/clock.svg'),
                          SpaceHelper(w: 6.w),
                          Text(
                            'ETA: Now',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: sm,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 2.w),
                      Text(
                        'Home → Lincoln Elementary',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightSecondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Arrived",
                      style: poppinFonts(color: AppColor.primary, fontSize: sm),
                    ),
                  ),
                ],
              ),
            ),
            SpaceHelper(h: 12.w),
            CustomButton(onPressed: () {}, title: "Live Tracking"),
          ],
        ),
      ),
    );
  }
}
