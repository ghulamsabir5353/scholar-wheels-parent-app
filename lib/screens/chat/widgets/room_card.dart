import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';

import '../../../core/helper.constants/font_sized.dart';
import '../../../core/helper.constants/textStyle.dart';
import '../../../core/helper.widgets/space_helper.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: InkWell(
        onTap: () {
          Get.toNamed(ChatRoomScreen.route);
        },
        child: Card(
          elevation: 1,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TransportCo Services",
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Bus #12 (ABC-123)",
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      Text(
                        "Emma has been dropped off safely at 3:20 PM",
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "2min",
                      style: poppinFonts(
                        fontSize: xs,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                    Card(
                      color: AppColor.secondary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        child: Text(
                          '2',
                          style: poppinFonts(color: AppColor.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
