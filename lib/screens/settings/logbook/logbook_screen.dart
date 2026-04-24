import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/trip_model.dart';
import 'package:scholarwheels/screens/settings/logbook/logbook_detail_screen.dart';
import 'package:scholarwheels/screens/settings/logbook/widgets/logbook_ride_card.dart';
import 'package:scholarwheels/services/api_state.dart';

class LogbookScreen extends StatefulWidget {
  static const route = '/logbook';
  LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  late MainController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MainController>();
    // Initialize with current filter (defaults to 'Daily' if not set)
    controller.getLogbookTrips(filter: controller.selectedFilter.value);
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
            // Get.find<BottomTabController>().setTabIndex(0);
            Get.back();
          },
        ),
        titleSpacing: 0,
        title: Text(
          'Logbook',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: Obx(() {
        final state = controller.logbookTripsState.value;

        if (state is LoadingState<List<TripModel>>) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (state is ErrorState<List<TripModel>>) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              Center(
                child: Text(
                  state.message,
                  style: poppinFonts(color: Colors.red, fontSize: sm),
                ),
              ),
              SpaceHelper(h: 16.h),
              OutlinedButton(
                onPressed: () => controller.getLogbookTrips(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.primary),
                  foregroundColor: AppColor.primary,
                ),
                child: Text(
                  'Retry',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          );
        }

        if (state is EmptyState<List<TripModel>>) {
          return Column(
            // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              SpaceHelper(h: 12.h),
              _buildFilterSegment(controller),
              SpaceHelper(h: 24.h),
              Center(
                child: Text(
                  state.message,
                  style: poppinFonts(
                    fontSize: sm,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ),
            ],
          );
        }

        if (state is! DataState<List<TripModel>>) {
          return const SizedBox.shrink();
        }

        final trips = state.data;

        return RefreshIndicator(
          onRefresh: () => controller.refreshLogbookTrips(),
          color: AppColor.primary,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSegment(controller),
                SpaceHelper(h: 12.h),
                ...trips.map((trip) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: LogbookRideCard(
                      trip: trip,
                      onViewDetailsTap: (childId) {
                        Get.toNamed(
                          LogBookDetailScreen.route,
                          arguments: {
                            '_id': trip.id,
                            'tripId': trip.tripId,
                            'status': trip.status,
                            'childId': childId,
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterSegment(MainController controller) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(color: AppColor.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildFilterButton(
              'Daily',
              controller.selectedFilter.value == 'Daily',
              () {
                controller.selectedFilter.value = 'Daily';
                controller.getLogbookTrips(filter: 'Daily');
              },
            ),
            _buildFilterButton(
              'Weekly',
              controller.selectedFilter.value == 'Weekly',
              () {
                controller.selectedFilter.value = 'Weekly';
                controller.getLogbookTrips(filter: 'Weekly');
              },
            ),
            _buildFilterButton(
              'Monthly',
              controller.selectedFilter.value == 'Monthly',
              () {
                controller.selectedFilter.value = 'Monthly';
                controller.getLogbookTrips(filter: 'Monthly');
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.black,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: poppinFonts(
              fontSize: xs,
              color: isSelected ? AppColor.white : AppColor.black,
            ),
          ),
        ),
      ),
    );
  }
}
