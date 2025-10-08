import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';

class ChatRoomScreen extends StatelessWidget {
  static const route = '/chat-room-screen';
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        leading: backButton(onTap: () => Get.back()),
        title: Text(
          'TransportCo Services',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                child: Column(
                  children: List.generate(100, (index) {
                    return chatBubble(index: index);
                  }),
                ),
              ),
            ),
          ),
          SpaceHelper(h: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.bgGrayD9D8D8, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.bgGray979797, width: 1),
                  ),
                  child: SvgPicture.asset('assets/images/svg/attachment.svg'),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: CustomTextField(
                      hintText: 'Type a message...',
                      height: 47,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.primary,
                  ),
                  child: SvgPicture.asset('assets/images/svg/send.svg'),
                ),
              ],
            ),
          ),
          SpaceHelper(h: 22.w),
        ],
      ),
    );
  }

  chatBubble({index = 0}) {
    return Row(
      mainAxisAlignment: index % 2 == 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 4.h),
          child: Builder(
            builder: (context) {
              return Container(
                constraints: BoxConstraints(minWidth: context.width * 0.3),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? AppColor.primary
                      : AppColor.recieverBubbleColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Will the bus arrive on time tomorrow?",
                      style: poppinFonts(
                        fontSize: xs,
                        color: index % 2 == 0 ? Colors.white : AppColor.black,
                      ),
                    ),
                    SpaceHelper(h: 4.h),
                    Row(
                      mainAxisAlignment: index % 2 == 0
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          "21 Aug 2025, 7:30 PM",
                          style: poppinFonts(
                            fontSize: xs,
                            color: index % 2 == 0
                                ? Colors.white
                                : AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
