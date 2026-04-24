import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/screens/home/widgets/schdule_card.dart';
import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../controllers/main.controller.dart';
import '../../models/dashboard_model.dart';
import '../../services/api_state.dart';

class ScheduleRideScreen extends StatefulWidget {
  static const route = '/schedule-ride';

  ScheduleRideScreen({super.key});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  final buttonList = ['Daily', 'Weekly', 'Monthly'];
  int selectedIndex = 0;
  final MainController mainController = Get.find<MainController>();
  late String status;

  @override
  void initState() {
    super.initState();
    // Get status from arguments, default to 'scheduled'
    status = Get.arguments as String? ?? 'scheduled';
    _loadTrips();
  }

  void _loadTrips() {
    final filterType = buttonList[selectedIndex].toLowerCase();
    mainController.scheduleRideFilter.value = buttonList[selectedIndex];
    mainController.getTrips(filterType: filterType, status: status);
  }

  String _getScreenTitle() {
    if (status.toLowerCase() == 'active') {
      return 'Active Rides';
    }
    return 'Schedule Rides';
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
        titleSpacing: 0,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          _getScreenTitle(),
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          if (status.toLowerCase() != 'active')
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  buttonList.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        _loadTrips();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColor.primary
                              : AppColor.white,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColor.primary
                                : AppColor.bgGrayD9D8D8,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            buttonList[index],
                            style: poppinFonts(
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                              color: selectedIndex == index
                                  ? AppColor.white
                                  : AppColor.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Trips List
          Expanded(
            child: Obx(() {
              final state = mainController.tripsState.value;

              if (mainController.isLoadingTrips.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                );
              }

              if (state is ErrorState<List<NextTrip>>) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: poppinFonts(color: Colors.red),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _loadTrips,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is EmptyState<List<NextTrip>>) {
                return Center(
                  child: Text(
                    state.message,
                    style: poppinFonts(
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                );
              }

              if (state is DataState<List<NextTrip>>) {
                final trips = state.data;
                if (trips.isEmpty) {
                  return Center(
                    child: Text(
                      status.toLowerCase() == 'active'
                          ? 'No active rides found'
                          : 'No scheduled rides found',
                      style: poppinFonts(
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: trips.map((trip) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.w),
                          child: SchduleCard(trip: trip, status: status),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }

              return SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }
}
