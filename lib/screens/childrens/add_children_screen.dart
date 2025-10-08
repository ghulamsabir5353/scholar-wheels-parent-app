import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/screens/childrens/set_account_for_child_screen.dart';

import '../../core/helper.widgets/space_helper.dart';

class AddChildrenScreen extends StatelessWidget {
  static const route = '/add-children';
  const AddChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        centerTitle: false,

        title: Text(
          'Add Children',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(SetAccountForChildScreen.route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.primary,
              ),
              child: Text(
                "Set Account For Child",
                style: poppinFonts(color: AppColor.white, fontSize: xs),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            children: [
              CustomTextField(label: "Name", hintText: "Enter Name"),
              CustomTextField(label: "Age", hintText: "Enter age"),
              CustomTextField(label: "School", hintText: "Enter School"),
              CustomTextField(
                label: "Pickup Address",
                hintText: "Enter Pickup Address",
              ),
              CustomTextField(
                label: "Drop-off Address",
                hintText: "Enter Drop-off Address",
              ),
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
                          "Cancel",
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
                          "Save",
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
            ],
          ),
        ),
      ),
    );
  }
}
