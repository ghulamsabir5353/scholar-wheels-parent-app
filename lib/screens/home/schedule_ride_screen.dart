import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/screens/home/widgets/schdule_card.dart';
import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';

class ScheduleRideScreen extends StatefulWidget {
  static const route = '/schedule-ride';

  ScheduleRideScreen({super.key});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  final buttonList = ['Daily', 'Weekly', 'Monthly'];

  int selectedIndex = 0;

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
          'Schedule Rides',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(buttonList.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColor.primary
                              : AppColor.white,
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColor.primary
                                : AppColor.black,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          buttonList[index],
                          style: poppinFonts(
                            color: selectedIndex == index
                                ? AppColor.appColorWhite
                                : AppColor.black,
                            fontSize: xs,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                    child: SchduleCard(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
