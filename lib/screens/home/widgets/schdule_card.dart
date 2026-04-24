import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_outline_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/screens/home/widgets/manage_ride_modal.dart';
import 'package:scholarwheels/screens/home/tracking/live_tracking_screen.dart';
import '../../../core/helper.widgets/space_helper.dart';

class SchduleCard extends StatelessWidget {
  final NextTrip trip;
  final String status;
  const SchduleCard({super.key, required this.trip, required this.status});

  String _formatTime(String? time, {DateTime? referenceDate}) {
    return AppDateTimeFormatter.formatStringTime(
      time,
      referenceDate: referenceDate,
    );
  }

  String _formatDate(DateTime? date) {
    return AppDateTimeFormatter.format(date, pattern: 'dd MMM, yyyy');
  }

  void _showManageRideModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ManageRideModal(trip: trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstChild = trip.assignedChildren?.isNotEmpty == true
        ? trip.assignedChildren!.first
        : null;
    final childName = firstChild?.child?.name ?? 'Child';
    final driverName = trip.driver?.fullName ?? 'N/A';
    final vehicle = trip.vehicle;
    final vehicleName = vehicle != null
        ? '${vehicle.make ?? ''} ${vehicle.model ?? ''}'.trim()
        : 'N/A';
    final vehicleDetails = vehicle?.registrationNumber ?? '';
    final pickupAddress =
        firstChild?.pickupAddress?.description ??
        firstChild?.child?.pickUpAddress?.description ??
        'N/A';
    final schoolName =
        firstChild?.child?.school ??
        firstChild?.child?.dropOffAddress?.description ??
        'N/A';
    final pickupTime =
        firstChild?.pickupTime ?? trip.scheduledPickupTime?.toString() ?? 'N/A';
    final dropoffTime = firstChild?.dropOffTime ?? trip.dropOffTime ?? 'N/A';
    final rideId = trip.tripId ?? trip.id ?? 'N/A';
    final scheduleDate = trip.serviceDate;

    return Card(
      elevation: 1,
      shadowColor: AppColor.cardShadowColor,
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride# and Schedule Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ride# ',
                      style: poppinFonts(
                        color: AppColor.textLightBlackColor4A4A4A,
                        fontSize: sm,
                      ),
                    ),
                    Text(
                      '$rideId',
                      style: poppinFonts(
                        color: AppColor.black,
                        fontSize: sm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (scheduleDate != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Date: ',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: sm,
                        ),
                      ),
                      Text(
                        '${_formatDate(scheduleDate)}',
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SpaceHelper(h: 12.h),

            // Child and Driver
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Child',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      Text(
                        childName,
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Text(
                        'Driver',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      Text(
                        driverName,
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 12.h),

            // Vehicle and Route Details (Green Background)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.cardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Info and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicleName,
                              style: poppinFonts(
                                color: AppColor.black,
                                fontSize: base,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (vehicleDetails.isNotEmpty)
                              Text(
                                vehicleDetails,
                                style: poppinFonts(
                                  color: AppColor.textLightBlackColor4A4A4A,
                                  fontSize: sm,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          trip.status != null && trip.status!.isNotEmpty
                              ? '${trip.status![0].toUpperCase()}${trip.status!.substring(1)}'
                              : 'Scheduled',
                          style: poppinFonts(
                            color: AppColor.white,
                            fontSize: sm,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SpaceHelper(h: 12.h),

                  // Route Entry Widget
                  RouteEntryWidget(
                    pickupAddress: pickupAddress,
                    schoolName: schoolName,
                    backgroundColor: AppColor.white,

                    isLast: true,
                  ),
                  SpaceHelper(h: 12.h),

                  // Times
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Pickup Time: ',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: sm,
                            ),
                          ),
                          Text(
                            _formatTime(
                              pickupTime.toString(),
                              referenceDate: scheduleDate,
                            ),
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Dropoff Time: ',
                            style: poppinFonts(
                              color: AppColor.textLightBlackColor4A4A4A,
                              fontSize: sm,
                            ),
                          ),
                          Text(
                            _formatTime(
                              dropoffTime.toString(),
                              referenceDate: scheduleDate,
                            ),
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SpaceHelper(h: 12.h),

            // Manage Ride Button
            if (status == 'scheduled')
              CustomOutlineButton(
                title: 'Manage Ride',
                onPressed: () {
                  _showManageRideModal(context);
                },
              )
            else
              CustomOutlineButton(
                title: 'Live Tracking',
                onPressed: trip.isScheduledForToday
                    ? () {
                        Get.toNamed(LiveTrackingScreen.route, arguments: trip);
                      }
                    : null,
                isDisabled: !trip.isScheduledForToday,
              ),
          ],
        ),
      ),
    );
  }
}
