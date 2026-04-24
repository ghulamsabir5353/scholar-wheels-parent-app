import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_outline_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import 'package:scholarwheels/models/trip_model.dart';
import 'package:scholarwheels/models/vehicle_model.dart';

class LogbookRideCard extends StatelessWidget {
  final TripModel trip;
  final Function(String)? onViewDetailsTap;

  const LogbookRideCard({super.key, required this.trip, this.onViewDetailsTap});

  // Derived properties from trip model
  String get rideId => trip.tripId ?? 'N/A';

  String get dateText => _formatDate(trip.serviceDate);

  Vehicle? get _vehicle => trip.vehicle;

  String get vehicleName {
    final v = _vehicle;
    if (v == null) return 'N/A';
    return '${v.make ?? ''} ${v.model ?? ''}'.trim().isEmpty
        ? 'N/A'
        : '${v.make ?? ''} ${v.model ?? ''}'.trim();
  }

  String get vehicleSubtitle {
    final v = _vehicle;
    if (v == null) return 'N/A';
    final color = v.color ?? '';
    final reg = v.registrationNumber ?? '';
    final combined = '$color (${reg})'.trim();
    return combined.isEmpty ? 'N/A' : combined;
  }

  AssignedChild? get _firstChild => trip.assignedChildren?.isNotEmpty == true
      ? trip.assignedChildren!.first
      : null;

  String get childName => _firstChild?.child?.name ?? 'N/A';

  String get transportOwnerName {
    final o = trip.transportOwner;
    if (o == null) return 'N/A';
    if (o.businessName != null && o.businessName!.trim().isNotEmpty) {
      return o.businessName!.trim();
    }
    final first = o.firstName ?? '';
    final last = o.surName ?? '';
    return '$first $last'.trim().isEmpty ? 'N/A' : '$first $last'.trim();
  }

  String get driverName => trip.driver?.fullName ?? 'N/A';

  String get pickupAddress {
    final c = _firstChild;
    return c?.pickupAddress?.description ??
        c?.child?.pickUpAddress?.description ??
        'N/A';
  }

  String get schoolName {
    final c = _firstChild;
    return c?.child?.school ?? c?.child?.dropOffAddress?.description ?? 'N/A';
  }

  int get childrenCount => trip.assignedChildren?.length ?? 0;

  String get status => trip.status ?? 'N/A';

  String get startTime => _formatTime(
    _firstChild?.pickupStatusUpdatedAt ??
        _firstChild?.pickupTime ??
        trip.pickupTime ??
        trip.scheduledPickupTime,
  );

  String endTime() {
    if (trip.endTime != null) {
      return AppDateTimeFormatter.format(trip.endTime, pattern: 'h:mm a');
    }
    if (trip.dropOffStatusUpdatedAt != null) {
      return AppDateTimeFormatter.format(
        DateTime.parse(trip.dropOffStatusUpdatedAt ?? ''),
        pattern: 'h:mm a',
      );
    }
    if (trip.dropOffTime != null) {
      return AppDateTimeFormatter.formatStringTime(trip.dropOffTime ?? '');
    }
    return 'N/A';
  }

  String get distanceText => trip.route?.estimatedDistance.toString() ?? 'N/A';

  String _formatDate(DateTime? date) {
    return AppDateTimeFormatter.format(date, pattern: 'd MMM, yyyy');
  }

  String _formatTime(String? time) {
    final trimmed = time?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return AppDateTimeFormatter.format(trip.startTime, pattern: 'h:mm a');
    }
    return AppDateTimeFormatter.formatStringTime(
      time,
      referenceDate: trip.serviceDate ?? trip.createdAt,
    );
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower == 'completed') return AppColor.primary;
    if (lower == 'cancelled') return AppColor.notCompletedStatusColor;
    return AppColor.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: AppColor.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SpaceHelper(h: 12.h),
          _buildOwnerDriverRow(),
          SpaceHelper(h: 12.h),
          Text(
            'Location Details',
            style: poppinFonts(
              fontSize: sm,
              fontWeight: FontWeight.w500,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
          SpaceHelper(h: 8.h),
          _buildLocationCard(),
          SpaceHelper(h: 12.h),
          CustomOutlineButton(
            title: 'View Details',
            onPressed: onViewDetailsTap != null
                ? () => onViewDetailsTap!(_firstChild?.child?.id ?? '')
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ride#',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 4.h),
            Text(
              rideId,
              style: poppinFonts(
                fontSize: base,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Child',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 4.h),
            Text(
              childName,
              style: poppinFonts(
                fontSize: base,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOwnerDriverRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transport Owner',
                style: poppinFonts(
                  fontSize: sm,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 4.h),
              Text(
                transportOwnerName,
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SpaceHelper(w: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Driver',
                style: poppinFonts(
                  fontSize: sm,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 4.h),
              Text(
                driverName,
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardBgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.borderGreen, width: 1),
        boxShadow: AppColor.cardShadow,
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicleName,
                    style: poppinFonts(
                      fontSize: base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  SpaceHelper(h: 2.h),
                  Text(
                    vehicleSubtitle,
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _statusColor(status),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status.capitalizeFirst ?? 'N/A',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
          SpaceHelper(h: 12.h),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
              boxShadow: AppColor.cardShadow,
            ),
            padding: EdgeInsets.all(12.w),
            child: RouteEntryWidget(
              pickupAddress: pickupAddress,
              schoolName: schoolName,
              padding: EdgeInsets.zero,
              backgroundColor: AppColor.white,
              border: null,
              margin: EdgeInsets.zero,
            ),
          ),

          SpaceHelper(h: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pickup Time: ',
                    style: poppinFonts(
                      fontSize: sm,
                      color: AppColor.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    startTime,
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Dropoff Time: ',
                    style: poppinFonts(
                      fontSize: sm,
                      color: AppColor.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    endTime(),
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
