import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_detail_screen.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class LogbookCard extends StatelessWidget {
  const LogbookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12.w),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Emma Johnson - Michael Rodriguez',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 4.w),
            Row(
              children: [
                Text(
                  'Trip ID ',
                  style: poppinFonts(
                    fontSize: sm,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'TP123456',
                  style: poppinFonts(
                    fontSize: xs,
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
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toyota Hiace',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                        ),
                      ),
                      Text(
                        'Jan 2024 - Jun 2024',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      SpaceHelper(h: 3.w),
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
                      SpaceHelper(h: 3.w),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/pickup-icon.svg'),
                          SpaceHelper(w: 6.w),
                          Text(
                            'School: ',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Lincoln Elementary School',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: sm,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
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
                        "Active",
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
            SpaceHelper(h: 12.w),
            InkWell(
              onTap: () {
                Get.toNamed(LogbookDetailScreen.route);
              },
              child: Container(
                width: double.infinity,
                height: 36.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "View Details",
                    style: poppinFonts(
                      fontWeight: FontWeight.w500,
                      fontSize: base,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
