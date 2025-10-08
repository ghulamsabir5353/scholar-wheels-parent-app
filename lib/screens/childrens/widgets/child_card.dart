import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/screens/childrens/edit_child_screen.dart';

import '../../../core/helper.widgets/space_helper.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({super.key});

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
                          'Emma Johnsons',
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
                          'Age 8 • 3rd Grade',
                          style: poppinFonts(
                            fontSize: xs,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SpaceHelper(h: 6.w),
            Row(
              children: [
                SvgPicture.asset('assets/images/svg/pickup-icon.svg'),

                SpaceHelper(w: 6.w),
                Text(
                  'Pickup: ',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '123 Maple Street',
                  style: poppinFonts(
                    color: AppColor.textLightBlackColor4A4A4A,
                    fontSize: sm,
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 5.w),
            Row(
              children: [
                SvgPicture.asset('assets/images/svg/pickup-icon.svg'),

                SpaceHelper(w: 6.w),
                Text(
                  'Pickup: ',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '123 Maple Street',
                  style: poppinFonts(
                    color: AppColor.textLightBlackColor4A4A4A,
                    fontSize: sm,
                  ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transport Assigned',
                        style: poppinFonts(
                          color: AppColor.primary,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SpaceHelper(h: 3.w),
                      Row(
                        children: [
                          Text(
                            'Driver: ',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Michael Rodriguez',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: xs,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 3.w),
                      Row(
                        children: [
                          Text(
                            'Vehicle: ',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Blue Toyota Hiace - ABC 123',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: xs,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 3.w),
                      Row(
                        children: [
                          Text(
                            'Rating: ',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '4.5',
                                style: poppinFonts(
                                  color: AppColor.textLightBlackColor4A4A4A,
                                  fontSize: sm,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: AppColor.darkSecondary,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ],
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
                      "Scheduled",
                      style: poppinFonts(color: AppColor.primary, fontSize: sm),
                    ),
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
                        "View Trips",
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
                      Get.toNamed(EditChildScreen.route);
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
                          "Edit Details",
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
