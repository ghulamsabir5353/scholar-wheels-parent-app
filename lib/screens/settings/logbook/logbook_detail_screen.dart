import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class LogbookDetailScreen extends StatelessWidget {
  static const route = '/logbook-detail';
  const LogbookDetailScreen({super.key});

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
              // Trip Overview
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip Overview',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SpaceHelper(h: 8.w),
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
                            'March 15, 2024',
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
                              'Vehicle: Blue Toyota Hiace - ABC 123',
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
                                  'Driver: John Smith',
                                  style: poppinFonts(
                                    color: AppColor.textLightBlackColor4A4A4A,
                                    fontSize: xs,
                                  ),
                                ),
                                Text(
                                  'Distance: 12.5 km',
                                  style: poppinFonts(
                                    color: AppColor.textLightBlackColor4A4A4A,
                                    fontSize: xs,
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 3.w),
                            Text(
                              'Start: 7:30 AM   →   End: 8:15 AM',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              // Route Map
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
              SpaceHelper(h: 12.w),
              // Children Detail
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
                              "E",
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
                              Text(
                                'Emma Johnson',
                                style: poppinFonts(
                                  color: AppColor.black,
                                  fontSize: base,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Age 8 - 3rd Grade',
                                style: poppinFonts(
                                  fontSize: xs,
                                  color: AppColor.textLightBlackColor4A4A4A,
                                ),
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
                        child: Column(
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
                            Text(
                              'Driver: Michael Rodriguez',
                              style: poppinFonts(
                                color: AppColor.black,
                                fontSize: sm,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                            Text(
                              'Vehicle: Blue Toyota Hiace - ABC 123',
                              style: poppinFonts(
                                color: AppColor.black,
                                fontSize: sm,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                            Row(
                              children: [
                                Text(
                                  'Rating: 4.9',
                                  style: poppinFonts(
                                    color: AppColor.black,
                                    fontSize: sm,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SpaceHelper(w: 4.w),
                                Icon(
                                  Icons.star,
                                  size: 14.w,
                                  color: AppColor.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              // Parent Detail
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
                          "M",
                          style: poppinFonts(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: base,
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
              // Transport Owner Detail
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
                          "M",
                          style: poppinFonts(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: base,
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
              // Contract Terms
              Card(
                elevation: 1,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contract Terms',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w500,
                        ),
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
                              'Start: 2024-09-01 - End: 2024-12-15',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                            SpaceHelper(h: 3.w),
                            Text(
                              'Duration - 4 months',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: xs,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 12.w),
              CustomButton(onPressed: () {}, title: "Download Contract pdf"),
              SpaceHelper(h: 200),
            ],
          ),
        ),
      ),
    );
  }
}
