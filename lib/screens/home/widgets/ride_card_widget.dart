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
    return Semantics(
      label: 'Ride information card',
      child: Card(
        elevation: 2,
        shadowColor: AppColor.cardShadowColor,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: 'Active rides section',
                header: true,
                child: Row(
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
              ),
              Semantics(
                label: 'Ride tracking description',
                child: Row(
                  children: [
                    Text(
                      'Track your child\'s current ride in real-time',
                      style: poppinFonts(
                        fontSize: sm,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  ],
                ),
              ),
              SpaceHelper(h: 7.w),
              Semantics(
                label: 'Emma Johnson ride details',
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffECF4E9),
                    border: Border.all(color: AppColor.borderGreen),
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
                              Semantics(
                                label: 'Clock icon',
                                child: SvgPicture.asset(
                                  'assets/images/svg/clock.svg',
                                ),
                              ),
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
                      Semantics(
                        label: 'Arrived status',
                        child: Container(
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
                            style: poppinFonts(
                              color: AppColor.primary,
                              fontSize: sm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              Semantics(
                label: 'Emma Johnson second ride details',
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.w,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffECF4E9),
                    border: Border.all(color: AppColor.borderGreen),
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
                              Semantics(
                                label: 'Clock icon',
                                child: SvgPicture.asset(
                                  'assets/images/svg/clock.svg',
                                ),
                              ),
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
                      Semantics(
                        label: 'Arrived status',
                        child: Container(
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
                            style: poppinFonts(
                              color: AppColor.primary,
                              fontSize: sm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              CustomButton(
                semanticLabel: 'Live tracking button',
                semanticHint: 'Tap to view live tracking of your child\'s ride',
                onPressed: () {},
                title: "Live Tracking",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
