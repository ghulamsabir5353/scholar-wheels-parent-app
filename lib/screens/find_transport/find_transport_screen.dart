import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/find_transport/find_transport_filter_screen.dart';
import 'package:scholarwheels/screens/find_transport/widgets/transport_card.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';

class FindTransportScreen extends StatefulWidget {
  static const route = '/find-transport';
  const FindTransportScreen({super.key});

  @override
  State<FindTransportScreen> createState() => _FindTransportScreenState();
}

class _FindTransportScreenState extends State<FindTransportScreen> {
  bool showMainSection = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,

        title: Text(
          'Find Transport',
          style: poppinFonts(
            fontSize: xl,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(FindTransportFilterScreen.route);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset('assets/images/svg/filter-button.svg'),
            ),
          ),
        ],
      ),
      body: showMainSection
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              child: Column(
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
                                'Emma Johnsons - Michael Rodriguez',
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
                                'Schedule Time:  ',
                                style: poppinFonts(
                                  fontSize: sm,
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '7:30 AM → 8:00 AM',
                                style: poppinFonts(
                                  fontSize: xs,
                                  color: AppColor.textLightBlackColor4A4A4A,
                                ),
                              ),
                            ],
                          ),
                          SpaceHelper(h: 7.w),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg/location.svg',
                                        ),
                                        SpaceHelper(w: 4.w),
                                        Text(
                                          'Toyota Hiace',
                                          style: poppinFonts(
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: sm,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SpaceHelper(h: 6.w),
                                    Text(
                                      '• Home → Lincoln Elementary',
                                      style: poppinFonts(
                                        color: AppColor.black,
                                        fontSize: xs,
                                      ),
                                    ),
                                    SpaceHelper(h: 3.w),
                                    Text(
                                      '• Home → Lincoln Elementary',
                                      style: poppinFonts(
                                        color: AppColor.black,
                                        fontSize: xs,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SpaceHelper(h: 12.w),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showMainSection = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Find Your Route",
                                  style: poppinFonts(
                                    fontWeight: FontWeight.w500,
                                    fontSize: base,
                                    color: AppColor.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                child: Column(
                  children: List.generate(10, (index) {
                    return TransportCard();
                  }),
                ),
              ),
            ),
    );
  }
}
