import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_outline_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

import 'package:scholarwheels/models/trip_model.dart';
import 'package:scholarwheels/models/vehicle_model.dart';

class LogbookRideCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onViewDetailsTap;

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

  String get startTime {
    // Find all children that were actually picked up
    final pickedChildren =
        trip.assignedChildren?.where((child) {
          final status = child.pickupStatus?.toLowerCase() ?? '';
          return (status == 'picked' || status == 'picked_up') &&
              child.pickupTime != null &&
              child.pickupTime!.isNotEmpty;
        }).toList() ??
        [];

    // If we have picked children, find the earliest pickup time
    if (pickedChildren.isNotEmpty) {
      // Sort by pickupTime to get the earliest one
      pickedChildren.sort((a, b) {
        final timeA = a.pickupTime ?? '';
        final timeB = b.pickupTime ?? '';
        return timeA.compareTo(timeB);
      });
      return _formatTime(pickedChildren.first.pickupTime);
    }

    // Fall back to trip.pickupTime or scheduledPickupTime if no children were picked
    return _formatTime(trip.pickupTime ?? trip.scheduledPickupTime);
  }

  String get endTime =>
      _formatTime(_firstChild?.dropOffTime ?? trip.dropOffTime);

  String get distanceText => trip.route?.estimatedDistance.toString() ?? 'N/A';

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('d MMM, yyyy').format(date);
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1].split(' ').first;
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
      }
    } catch (_) {}
    return time;
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
            onPressed: onViewDetailsTap ?? () {},
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
                      color: AppColor.primary,
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
                    endTime,
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
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
