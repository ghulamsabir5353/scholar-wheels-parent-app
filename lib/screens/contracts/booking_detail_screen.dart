import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/space_helper.dart';

class BookingDetailScreen extends StatelessWidget {
  static const String route = '/booking-detail-screen';
  const BookingDetailScreen({super.key});

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
          'TP123456',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
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
                            'Trip Overview',
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
                            'Date: ',
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' March 15, 2024',
                            style: poppinFonts(
                              fontSize: xs,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 7.w),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffECF4E9),
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle →  Blue Toyota Hiace - ABC 123',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Driver → John Smith',
                                  style: poppinFonts(
                                    color: AppColor.textLightBlackColor4A4A4A,
                                    fontSize: xs,
                                  ),
                                ),
                                Text(
                                  'Distance → 12.5 km',
                                  style: poppinFonts(
                                    color: AppColor.textLightBlackColor4A4A4A,
                                    fontSize: xs,
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 3.w),
                            Text(
                              'Start: 7:30 AM   →   End: 8:15 AM',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                          ],
                        ),
                      ),
                      SpaceHelper(h: 12.w),
                    ],
                  ),
                ),
              ),

              SpaceHelper(h: 7.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: Color(0xffECF4E9),
                  border: Border.all(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route Map',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 12.w),
                    Image.asset('assets/images/png/map.png'),
                    SpaceHelper(h: 12.w),
                    CustomButton(onPressed: () {}, title: "Live Tracking"),
                  ],
                ),
              ),
              SpaceHelper(h: 7.w),
              Text(
                'Children Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.w),
              Card(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
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
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
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
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                        fontSize: xs,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: SvgPicture.asset(
                                'assets/images/svg/delete.svg',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SpaceHelper(h: 12.w),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),

              Text(
                'Parent Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.w),
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.w,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.darkPrimary,
                        radius: 24,
                        child: Text(
                          "A",
                          style: poppinFonts(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SpaceHelper(w: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Michael Chen",
                            style: poppinFonts(
                              fontSize: base,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "michael.chen@email.com",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Text(
                            "+1 (555) 123-4567",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),

              Text(
                'Transport Owner Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.w),
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.w,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.darkPrimary,
                        radius: 24,
                        child: Text(
                          "A",
                          style: poppinFonts(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SpaceHelper(w: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Michael Chen",
                            style: poppinFonts(
                              fontSize: base,
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "michael.chen@email.com",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Text(
                            "+1 (555) 123-4567",
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              Card(
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
                            'Trip Overview',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: base,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SpaceHelper(h: 7.w),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffECF4E9),
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SpaceHelper(h: 3.w),
                            Text(
                              'Start: 7:30 AM   →   End: 8:15 AM',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                            Text(
                              'Duration →  4 months',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SpaceHelper(h: 12.w),
                    ],
                  ),
                ),
              ),

              CustomButton(onPressed: () {}, title: "Download Contract pdf"),
              Container(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
