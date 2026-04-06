import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/booking_model.dart';
import 'package:scholarwheels/screens/bookings/booking_detail_screen.dart';

import '../../../core/helper.widgets/space_helper.dart';

class BookingHistoryCard extends StatelessWidget {
  final BookingModel booking;

  const BookingHistoryCard({super.key, required this.booking});

  String _getTransportOwnerName() {
    if (booking.transportOwner == null) return 'N/A';
    final firstName = booking.transportOwner!.firstName ?? '';
    final surName = booking.transportOwner!.surName ?? '';
    if (firstName.isNotEmpty && surName.isNotEmpty) {
      return '$firstName $surName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (surName.isNotEmpty) {
      return surName;
    } else if (booking.transportOwner!.businessName != null &&
        booking.transportOwner!.businessName!.isNotEmpty) {
      return booking.transportOwner!.businessName!;
    }
    return 'N/A';
  }

  String _getChildName() {
    if (booking.children != null && booking.children!.isNotEmpty) {
      return booking.children!.first.name ?? 'N/A';
    }
    return 'N/A';
  }

  String _getVehicleName() {
    if (booking.route?.routeName != null &&
        booking.route!.routeName!.isNotEmpty) {
      return booking.route!.routeName!;
    }
    return 'N/A';
  }

  String _getStatus() {
    // Use approveStatus if available, otherwise use status
    final status = booking.approveStatus ?? booking.status ?? 'Pending';
    return status;
  }

  String _getRequestDuration() {
    if (booking.contractDuration != null) {
      return booking.contractDuration!;
    }
    // Calculate duration from start and end dates if available
    if (booking.startDate != null && booking.endDate != null) {
      final difference = booking.endDate!.difference(booking.startDate!);
      final months = (difference.inDays / 30).round();
      return '$months Months';
    }
    return 'N/A';
  }

  String _getRequestDate() {
    if (booking.createdAt != null) {
      return DateFormat('d MMM, yyyy').format(booking.createdAt!);
    }
    return 'N/A';
  }

  String _getPickupAddress() {
    if (booking.children != null && booking.children!.isNotEmpty) {
      return booking.children!.first.pickUpAddress?.description ??
          booking.route?.suburbName ??
          'N/A';
    }
    return booking.route?.suburbName ?? 'N/A';
  }

  String _getSchoolName() {
    if (booking.children != null && booking.children!.isNotEmpty) {
      return booking.children!.first.dropOffAddress?.description ??
          booking.children!.first.school ??
          booking.route?.dropOffPointName ??
          'N/A';
    }
    return booking.route?.dropOffPointName ?? 'N/A';
  }

  String _getRequestId() {
    if (booking.bookingId != null) {
      return booking.bookingId!;
    }
    if (booking.id != null) {
      return booking.id!;
    }
    return 'N/A';
  }

  Color _getStatusColor() {
    final status = _getStatus().toLowerCase();
    if (status == 'accepted' || status == 'approved') {
      return Colors.white;
    } else if (status == 'rejected' || status == 'declined') {
      return Colors.white;
    }
    return Colors.white; // Pending - white text
  }

  Color _getStatusBgColor() {
    final status = _getStatus().toLowerCase();
    if (status == 'accepted' || status == 'approved') {
      return AppColor.primary; // Dark green
    } else if (status == 'rejected' || status == 'declined') {
      return Colors.red; // Red
    }
    return Colors.amber.shade700; // Yellow/gold for pending
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.cardBorderColorGrey),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Request# and Request Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request#',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      SpaceHelper(h: 2.h),
                      Text(
                        _getRequestId(),
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Date',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      SpaceHelper(h: 2.h),
                      Text(
                        _getRequestDate(),
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 12.h),
            // Transport Owner and Child
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transport Owner',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: xs,
                        ),
                      ),
                      SpaceHelper(h: 2.h),
                      Text(
                        _getTransportOwnerName(),
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      SpaceHelper(h: 2.h),
                      Text(
                        _getChildName(),
                        style: poppinFonts(
                          color: AppColor.black,
                          fontSize: base,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SpaceHelper(h: 16.h),
            // Request Details Heading
            Text(
              'Request Details',
              style: poppinFonts(
                color: AppColor.black,
                fontSize: base,
                fontWeight: FontWeight.w500,
              ),
            ),
            SpaceHelper(h: 12.h),
            // Main Green Content Area
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Color(0xffECF4E9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Name
                      Padding(
                        padding: EdgeInsets.only(
                          right: 80.w,
                        ), // Space for status badge
                        child: Text(
                          _getVehicleName(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SpaceHelper(h: 8.h),
                      // Request Duration
                      Text(
                        'Request Duration : ${_getRequestDuration()} Days',
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      SpaceHelper(h: 12.h),
                      // White Container with Pickup and School Info
                      RouteEntryWidget(
                        pickupAddress: _getPickupAddress(),
                        schoolName: _getSchoolName(),
                      ),
                    ],
                  ),
                  // Status Badge - Positioned at top right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _getStatus().capitalizeFirst ?? _getStatus(),
                        style: poppinFonts(
                          color: _getStatusColor(),
                          fontSize: xs,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SpaceHelper(h: 16.h),
            // View Details Button
            InkWell(
              onTap: () {
                Get.toNamed(BookingDetailScreen.route, arguments: booking);
              },
              child: Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.borderGreen),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'View Details',
                    style: poppinFonts(
                      fontWeight: FontWeight.w500,
                      fontSize: sm,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for dotted vertical line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.textLightBlackColor4A4A4A
      ..strokeWidth = 1.5;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
