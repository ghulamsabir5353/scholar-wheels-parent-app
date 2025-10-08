import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';
import '../childrens/add_children_screen.dart';

class FindTransportFilterScreen extends StatelessWidget {
  static const route = '/find-transport-filter-screen';
  const FindTransportFilterScreen({super.key});

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
          'Filters',
          style: poppinFonts(
            fontSize: xl,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search with Filters',
                style: poppinFonts(
                  fontSize: lg,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.w),
              CustomTextField(
                label: "Pickup Location",
                hintText: 'Enter Pickup Location',
              ),
              CustomTextField(
                label: "School/Drop-off",
                hintText: 'Enter School/Drop-off',
              ),
              SpaceHelper(h: 12.w),
              CustomButton(onPressed: () {}, title: "Find Transport"),
            ],
          ),
        ),
      ),
    );
  }
}
