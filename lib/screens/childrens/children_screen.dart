import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/screens/childrens/add_children_screen.dart';
import 'package:scholarwheels/screens/childrens/widgets/child_card.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';

class ChildrenScreen extends StatelessWidget {
  static const route = '/children-screen';
  const ChildrenScreen({super.key});

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
          'Children',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(AddChildrenScreen.route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.w),
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.add, color: AppColor.white, size: 26.sp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            children: List.generate(10, (index) {
              return ChildCard();
            }),
          ),
        ),
      ),
    );
  }
}
