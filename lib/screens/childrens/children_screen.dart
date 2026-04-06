import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/screens/childrens/add_children_screen.dart';
import 'package:scholarwheels/screens/childrens/widgets/child_card.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/space_helper.dart';

class ChildrenScreen extends StatefulWidget {
  static const route = '/children-screen';
  const ChildrenScreen({super.key});

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  final ChildController childController = Get.find<ChildController>();

  @override
  void initState() {
    super.initState();
    // Children list is automatically loaded in controller's onInit
  }

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
            // hit bottom nav index 0 here and show the home screen
            Get.find<BottomTabController>().setTabIndex(0);
          },
        ),
        titleSpacing: 0,
        title: Text(
          'Children',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
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
      body: Obx(() {
        final state = childController.childrenState.value;

        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ErrorState) {
          final errorState = state as ErrorState;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
                SpaceHelper(h: 16.h),
                Text(
                  errorState.message,
                  style: poppinFonts(fontSize: base, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SpaceHelper(h: 16.h),
                ElevatedButton(
                  onPressed: () => childController.getChildrenList(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ExceptionState) {
          final exceptionState = state as ExceptionState;
          return Center(
            child: Text(
              'Exception: ${exceptionState.exception}',
              style: poppinFonts(color: Colors.red),
            ),
          );
        }

        if (state is EmptyState) {
          final emptyState = state as EmptyState;
          // add some padding
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care,
                    size: 80.sp,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                  SpaceHelper(h: 16.h),
                  Text(
                    emptyState.message,
                    style: poppinFonts(
                      fontSize: base,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DataState<List<ChildModel>>) {
          final dataState = state;
          return RefreshIndicator(
            onRefresh: () async {
              await childController.getChildrenList();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                child: Column(
                  children: dataState.data
                      .map(
                        (child) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ChildCard(child: child),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        }

        return SizedBox.shrink();
      }),
    );
  }
}
