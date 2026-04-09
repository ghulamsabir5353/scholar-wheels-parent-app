import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/booking_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';

import 'package:scholarwheels/core/helper.widgets/location_permission_map_gate.dart';
import '../../core/helper.widgets/route_map_widget.dart';

class BookingDetailScreen extends StatefulWidget {
  static const String route = '/booking-detail-screen';
  const BookingDetailScreen({super.key});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isInteractingWithMap = false;
  int _mapPointerCount = 0;

  String _getRequestId(BookingModel? booking) {
    if (booking?.bookingId != null) return booking!.bookingId!;
    if (booking?.id != null) return booking!.id!;
    return 'N/A';
  }

  String _getRequestDate(BookingModel? booking) {
    if (booking?.createdAt != null) {
      return DateFormat('d MMM, yyyy').format(booking!.createdAt!);
    }
    return 'N/A';
  }

  String _getRequestDuration(BookingModel? booking) {
    // if (booking?.startDate != null && booking?.endDate != null) {
    //   final difference = booking!.endDate!.difference(booking.startDate!);
    //   final months = (difference.inDays / 30).round();
    //   return '$months Months';
    // }
    if (booking?.contractDuration != null) {
      return '${booking!.contractDuration} Days';
    }
    return 'N/A';
  }

  String _getRequestDurationDates(BookingModel? booking) {
    if (booking?.startDate != null && booking?.endDate != null) {
      final startDate = DateFormat('d MMM, yyyy').format(booking!.startDate!);
      final endDate = DateFormat('d MMM, yyyy').format(booking.endDate!);
      return '$startDate - $endDate';
    }
    return 'N/A';
  }

  String _getStatus(BookingModel? booking) {
    final status = booking?.approveStatus ?? booking?.status ?? 'Pending';
    return status;
  }

  Color _getStatusColor(BookingModel? booking) {
    final status = _getStatus(booking).toLowerCase();
    if (status == 'accepted' || status == 'approved') {
      return Colors.white;
    } else if (status == 'rejected' || status == 'declined') {
      return Colors.white;
    }
    return Colors.white;
  }

  Color _getStatusBgColor(BookingModel? booking) {
    final status = _getStatus(booking).toLowerCase();
    if (status == 'accepted' || status == 'approved') {
      return AppColor.primary;
    } else if (status == 'rejected' || status == 'declined') {
      return Colors.red;
    }
    return Colors.amber.shade700;
  }

  String _getTransportOwnerBusinessName(BookingModel? booking) {
    if (booking?.transportOwner?.businessName != null &&
        booking!.transportOwner!.businessName!.isNotEmpty) {
      return booking.transportOwner!.businessName!;
    }
    return 'N/A';
  }

  String _getTransportOwnerName(BookingModel? booking) {
    if (booking?.transportOwner == null) return 'N/A';
    final firstName = booking!.transportOwner!.businessName ?? '';

    if (firstName.isNotEmpty) {
      return '$firstName';
    }
    return 'N/A';
  }

  String _getTransportOwnerEmail(BookingModel? booking) {
    if (booking?.transportOwner?.user?.email != null) {
      return booking!.transportOwner!.user!.email!;
    }
    return 'N/A';
  }

  String _getTransportOwnerPhone(BookingModel? booking) {
    if (booking?.transportOwner?.user?.phone != null) {
      return booking!.transportOwner!.user!.phone!;
    }
    return 'N/A';
  }

  String _getDriverName(BookingModel? booking) {
    // Check if route has driver object (from route_model)
    // Note: booking model Route might not have driver, only assignedDriver ID
    if (booking?.route?.assignedDriver != null) {
      // If we have assignedDriver ID, show "Driver Assigned"
      return 'Driver Assigned';
    }
    return 'N/A';
  }

  String _getVehicleName(BookingModel? booking) {
    // Format: "Color Make Model" or "Color VehicleType"
    final vehicle = booking?.route?.vehicle;
    if (vehicle != null) {
      final parts = <String>[];

      // Add color if available
      if (vehicle.color != null && vehicle.color!.isNotEmpty) {
        parts.add(vehicle.color!);
      }

      // Add make if available
      if (vehicle.make != null && vehicle.make!.isNotEmpty) {
        parts.add(vehicle.make!);
      }

      // Add model if available
      if (vehicle.model != null && vehicle.model!.isNotEmpty) {
        parts.add(vehicle.model!);
      }

      // If we have parts, join them
      if (parts.isNotEmpty) {
        return parts.join(' ');
      }

      // Fallback to vehicleType
      if (vehicle.vehicleType != null && vehicle.vehicleType!.isNotEmpty) {
        return vehicle.vehicleType!;
      }
    }

    // Fallback to routeName
    if (booking?.route?.routeName != null) {
      return booking!.route!.routeName!;
    }

    return 'N/A';
  }

  String _getPickupTime(BookingModel? booking) {
    if (booking?.pickUpTime != null) {
      return booking!.pickUpTime!;
    }
    return 'N/A';
  }

  String _getDropOffTime(BookingModel? booking) {
    if (booking?.knockOffTime != null) {
      return booking!.knockOffTime!;
    }
    return 'N/A';
  }

  String _getPickupAddress(BookingModel? booking) {
    if (booking?.children != null && booking!.children!.isNotEmpty) {
      return booking.children!.first.pickUpAddress?.description ??
          booking.route?.suburbName ??
          'N/A';
    }
    return booking?.route?.suburbName ?? 'N/A';
  }

  String _getSchoolName(BookingModel? booking) {
    if (booking?.children != null && booking!.children!.isNotEmpty) {
      return booking.children!.first.dropOffAddress?.description ??
          booking.children!.first.school ??
          booking.route?.suburbName ??
          'N/A';
    }
    return booking?.route?.suburbName ?? 'N/A';
  }

  String _getDistance(BookingModel? booking) {
    if (booking?.route?.estimatedDistance != null) {
      return '${booking!.route!.estimatedDistance} km';
    }
    return '12.5 km';
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'A';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  double _getAverageRating(BookingModel? booking) {
    if (booking?.transportOwner?.averageRating != null) {
      return booking!.transportOwner!.averageRating!;
    }
    return 4.9; // Default
  }

  double _getTotalRatings(BookingModel? booking) {
    if (booking?.transportOwner?.totalRatings != null) {
      return booking!.transportOwner!.totalRatings!;
    }
    return 5353; // Default
  }

  bool _isVerified(BookingModel? booking) {
    return booking?.transportOwner?.isVerified ?? false;
  }

  bool _isAccepted(BookingModel? booking) {
    final status = _getStatus(booking).toLowerCase();
    return status == 'accepted' || status == 'approved';
  }

  @override
  Widget build(BuildContext context) {
    final booking = Get.arguments as BookingModel?;

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
          _getRequestId(booking),
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: _isInteractingWithMap
            ? const NeverScrollableScrollPhysics()
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Request Detail Section
              if (booking != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Detail',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                    Card(
                      elevation: 2,
                      shadowColor: AppColor.cardShadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColor.cardBorderColorGrey),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildDetailRow(
                                  'Request Date:',
                                  _getRequestDate(booking),
                                ),
                                SpaceHelper(h: 12.h),
                                _buildDetailRow(
                                  'Request Duration:',
                                  _getRequestDuration(booking),
                                ),
                                SpaceHelper(h: 12.h),
                                _buildDetailRow(
                                  'Request Duration Dates:',
                                  _getRequestDurationDates(booking),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusBgColor(booking),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  _getStatus(booking).capitalizeFirst ??
                                      _getStatus(booking),
                                  style: poppinFonts(
                                    color: _getStatusColor(booking),
                                    fontSize: xs,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                  ],
                ),

              // Transport Info Section
              if (booking?.transportOwner != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transport Info',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                    Card(
                      elevation: 2,
                      shadowColor: AppColor.cardShadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColor.cardBorderColorGrey),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Business Name and Rating
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.primary,
                                  radius: 20.r,
                                  child: Text(
                                    _getInitials(
                                      _getTransportOwnerBusinessName(booking),
                                    ),
                                    style: poppinFonts(
                                      color: AppColor.white,
                                      fontSize: base,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SpaceHelper(w: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _getTransportOwnerBusinessName(
                                                booking,
                                              ),
                                              style: poppinFonts(
                                                color: AppColor.black,
                                                fontSize: base,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          if (_isVerified(booking))
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColor.lightSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/svg/verified.svg',
                                                    width: 14.w,
                                                    height: 14.h,
                                                  ),
                                                  SpaceHelper(w: 4.w),
                                                  Text(
                                                    'Verified',
                                                    style: poppinFonts(
                                                      color: AppColor.black,
                                                      fontSize: xs,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      SpaceHelper(h: 4.h),
                                      Row(
                                        children: [
                                          Text(
                                            '${_getAverageRating(booking)}',
                                            style: poppinFonts(
                                              color: AppColor.black,
                                              fontSize: sm,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SpaceHelper(w: 4.w),
                                          Icon(
                                            Icons.star,
                                            size: 14.w,
                                            color: AppColor.primary,
                                          ),
                                          SpaceHelper(w: 4.w),
                                          Text(
                                            '(${_getTotalRatings(booking)} reviews)',
                                            style: poppinFonts(
                                              color: AppColor
                                                  .textLightBlackColor4A4A4A,
                                              fontSize: xs,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 12.h),
                            _buildDetailRow(
                              'Transport Owner:',
                              _getTransportOwnerName(booking),
                              fontSize: sm,
                            ),
                            SpaceHelper(h: 12.h),
                            _buildDetailRow(
                              'Driver:',
                              _getDriverName(booking),
                              fontSize: sm,
                            ),
                            SpaceHelper(h: 12.h),
                            _buildDetailRow(
                              'Vehicle:',
                              _getVehicleName(booking),
                              fontSize: sm,
                            ),
                            SpaceHelper(h: 12.h),
                            CustomButton(
                              onPressed: () {
                                // Navigate to chat tab (4th tab, index 4)
                                final bottomController =
                                    Get.find<BottomTabController>();
                                bottomController.setTabIndex(4);
                                // Navigate to tab screen if not already there
                                Get.until(
                                  (route) =>
                                      route.settings.name == '/tab_screen',
                                );
                              },
                              title: "Chat",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                  ],
                ),
              // Children Detail Section
              if (booking?.children != null && booking!.children!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Children Detail',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 12.h),
                    Card(
                      elevation: 2,
                      shadowColor: AppColor.cardShadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColor.cardBorderColorGrey),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...booking.children!.map((child) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColor.primary,
                                      radius: 20.r,
                                      child: Text(
                                        (child.name?.isNotEmpty == true
                                            ? child.name![0].toUpperCase()
                                            : 'C'),
                                        style: poppinFonts(
                                          color: AppColor.white,
                                          fontSize: base,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SpaceHelper(w: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            child.name ?? 'N/A',
                                            style: poppinFonts(
                                              color: AppColor.black,
                                              fontSize: base,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SpaceHelper(h: 4.h),
                                          Text(
                                            'Age ${child.age ?? 'N/A'}${child.school != null ? ' • ${child.school}' : ''}',
                                            style: poppinFonts(
                                              fontSize: sm,
                                              color: AppColor
                                                  .textLightBlackColor4A4A4A,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    SpaceHelper(h: 12.h),
                  ],
                ),

              // Route Details Section
              if (booking?.route != null ||
                  booking?.pickUpTime != null ||
                  booking?.knockOffTime != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route Details',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                    Card(
                      elevation: 2,
                      shadowColor: AppColor.cardShadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColor.cardBorderColorGrey),
                      ),
                      color: AppColor.lightSecondary,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: _buildDetailRow(
                                    'Pickup Time :',
                                    _getPickupTime(booking),
                                  ),
                                ),
                                Flexible(
                                  child: _buildDetailRow(
                                    'Drop Off Time :',
                                    _getDropOffTime(booking),
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 12.h),
                            // Pickup and School Info
                            RouteEntryWidget(
                              pickupAddress: _getPickupAddress(booking),
                              schoolName: _getSchoolName(booking),
                              isLast: false,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Distance",
                                  style: poppinFonts(
                                    fontSize: sm,
                                    color: AppColor.black,
                                  ),
                                ),
                                SpaceHelper(w: 8.w),
                                Text(
                                  _getDistance(booking),
                                  style: poppinFonts(
                                    fontSize: sm,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                  ],
                ),

              // Route Map Section
              if (booking != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route Map',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SpaceHelper(h: 12.h),

                    Listener(
                      onPointerDown: (_) {
                        _mapPointerCount++;
                        if (_mapPointerCount >= 2 && !_isInteractingWithMap) {
                          setState(() => _isInteractingWithMap = true);
                        }
                      },
                      onPointerUp: (_) {
                        _mapPointerCount--;
                        if (_mapPointerCount < 0) _mapPointerCount = 0;
                        if (_mapPointerCount < 2 && _isInteractingWithMap) {
                          setState(() => _isInteractingWithMap = false);
                        }
                      },
                      onPointerCancel: (_) {
                        _mapPointerCount--;
                        if (_mapPointerCount < 0) _mapPointerCount = 0;
                        if (_mapPointerCount < 2 && _isInteractingWithMap) {
                          setState(() => _isInteractingWithMap = false);
                        }
                      },
                      child: Card(
                        elevation: 2,
                        shadowColor: AppColor.cardShadowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: AppColor.cardBorderColorGrey),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LocationPermissionMapGate(
                                child: RouteMapWidget(
                                  pickupLocation: booking.route?.suburb,
                                  dropOffLocation: booking.route?.dropOffPoint,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SpaceHelper(h: 8.h),
                  ],
                ),
              SpaceHelper(h: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    double? fontSize,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: poppinFonts(
            fontSize: fontSize ?? sm,
            color: AppColor.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SpaceHelper(w: 8.w),
        Expanded(
          child: Text(
            value,
            style: poppinFonts(
              fontSize: fontSize ?? sm,
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
