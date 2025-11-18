import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/route_map_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/models/location_data_model.dart'
    as location_model;

class LiveTrackingScreen extends StatelessWidget {
  static const String route = '/live-tracking-screen';
  const LiveTrackingScreen({super.key});

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return time;
  }

  location_model.LocationData? _convertPickupAddressToLocationData(
    PickupAddress? pickupAddress,
  ) {
    if (pickupAddress == null) return null;
    if (pickupAddress.coordinates == null) return null;

    final coords = pickupAddress.coordinates!;
    if (coords.coordinates == null || coords.coordinates!.length < 2) {
      return null;
    }

    // Coordinates in NextTrip are [lng, lat]
    final lng = coords.coordinates![0];
    final lat = coords.coordinates![1];

    return location_model.LocationData(
      placeId: pickupAddress.placeId ?? '',
      description: pickupAddress.description ?? '',
      coordinates: location_model.Coordinates(
        type: coords.type ?? 'Point',
        coordinates: [lng, lat],
      ),
    );
  }

  String _getVehicleName(NextTrip? trip) {
    if (trip?.vehicle?.make != null && trip?.vehicle?.model != null) {
      return '${trip!.vehicle!.make} ${trip.vehicle!.model}';
    } else if (trip?.vehicle?.make != null) {
      return trip!.vehicle!.make!;
    }
    return 'N/A';
  }

  String _getVehicleDetails(NextTrip? trip) {
    final parts = <String>[];
    if (trip?.vehicle?.registrationNumber != null) {
      parts.add(trip!.vehicle!.registrationNumber!);
    }
    if (trip?.vehicle?.manufacturingYear != null) {
      parts.add('${trip!.vehicle!.manufacturingYear} Model');
    }
    return parts.isEmpty ? 'N/A' : parts.join(' - ');
  }

  String _getDriverName(NextTrip? trip) {
    return trip?.driver?.fullName ?? 'N/A';
  }

  String _getChildName(NextTrip? trip) {
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      return trip.assignedChildren!.first.child?.name ?? 'N/A';
    }
    return 'N/A';
  }

  String _getPickupOrder(NextTrip? trip) {
    // This would need to come from the trip data if available
    // For now, return a placeholder
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      final totalChildren = trip.assignedChildren!.length;
      // Assuming we're showing the first child's order
      return '1 of $totalChildren';
    }
    return 'N/A';
  }

  String _getPickupTime(NextTrip? trip) {
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      return trip.assignedChildren!.first.pickupTime ?? 'N/A';
    }
    if (trip?.scheduledPickupTime != null) {
      if (trip!.scheduledPickupTime is String) {
        return trip.scheduledPickupTime as String;
      }
    }
    return 'N/A';
  }

  String _getDropOffTime(NextTrip? trip) {
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      return trip.assignedChildren!.first.dropOffTime ??
          trip.dropOffTime ??
          'N/A';
    }
    return trip?.dropOffTime ?? 'N/A';
  }

  String _getPickupAddress(NextTrip? trip) {
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      return trip.assignedChildren!.first.pickupAddress?.description ?? 'N/A';
    }
    return 'N/A';
  }

  String _getDropOffAddress(NextTrip? trip) {
    if (trip?.assignedChildren != null && trip!.assignedChildren!.isNotEmpty) {
      return trip.assignedChildren!.first.child?.dropOffAddress?.description ??
          trip.assignedChildren!.first.child?.school ??
          'N/A';
    }
    return 'N/A';
  }

  String _getDistance(NextTrip? trip) {
    // This would need to come from the trip/route data
    // For now, return a placeholder
    return '12.5 KM';
  }

  String _getEstimatedTime(NextTrip? trip) {
    // This would need to come from the trip/route data
    // For now, return a placeholder
    return '45 Mints';
  }

  @override
  Widget build(BuildContext context) {
    final trip = Get.arguments as NextTrip?;

    if (trip == null) {
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
            'Live Tracking',
            style: poppinFonts(
              fontSize: lg,
              color: AppColor.headingFontColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'No trip data available',
            style: poppinFonts(
              fontSize: base,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
        ),
      );
    }

    final pickupLocation = _convertPickupAddressToLocationData(
      trip.assignedChildren?.isNotEmpty == true
          ? trip.assignedChildren!.first.pickupAddress
          : null,
    );

    final dropOffLocation =
        trip.assignedChildren?.isNotEmpty == true &&
            trip.assignedChildren!.first.child?.dropOffAddress != null
        ? _convertPickupAddressToLocationData(
            trip.assignedChildren!.first.child!.dropOffAddress,
          )
        : null;

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
          trip.tripId ?? 'Live Tracking',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map View - Top 40% of screen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: pickupLocation != null || dropOffLocation != null
                  ? RouteMapWidget(
                      pickupLocation: pickupLocation,
                      dropOffLocation: dropOffLocation,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Text(
                          'No location data available',
                          style: poppinFonts(
                            fontSize: base,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          // Trip Details Card - Bottom Sheet Style
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: const Color(0xffECF4E9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                border: Border.all(color: AppColor.darkPrimary),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Container(
                      margin: EdgeInsets.only(top: 12.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColor.darkPrimary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Vehicle Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _getVehicleName(trip),
                                    style: poppinFonts(
                                      fontSize: base,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SpaceHelper(h: 4.h),
                                  // Vehicle Details
                                  Text(
                                    _getVehicleDetails(trip),
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
                          SpaceHelper(h: 16.h),
                          // Driver and Child Info - Two Columns
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Driver',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _getDriverName(trip),
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 12.h),
                                    Text(
                                      'Pickup Order',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _getPickupOrder(trip),
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 12.h),
                                    Text(
                                      'Pickup Time',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _formatTime(_getPickupTime(trip)),
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SpaceHelper(w: 24.w),
                              // Right Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Child',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _getChildName(trip),
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 12.h),
                                    Text(
                                      'Pickup Area',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _getPickupAddress(trip),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 12.h),
                                    Text(
                                      'Drop-off Time',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      _formatTime(_getDropOffTime(trip)),
                                      style: poppinFonts(
                                        fontSize: base,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SpaceHelper(h: 16.h),
                          // Route Details Card
                          RouteEntryWidget(
                            pickupAddress: _getPickupAddress(trip),
                            schoolName: _getDropOffAddress(trip),
                            isLast: true,
                          ),

                          SpaceHelper(h: 12.h),
                          // Distance and Estimated Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distance',
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.textLightBlackColor4A4A4A,
                                    ),
                                  ),
                                  SpaceHelper(h: 4.h),
                                  Text(
                                    _getDistance(trip),
                                    style: poppinFonts(
                                      fontSize: base,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Estimated Time',
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.textLightBlackColor4A4A4A,
                                    ),
                                  ),
                                  SpaceHelper(h: 4.h),
                                  Text(
                                    _getEstimatedTime(trip),
                                    style: poppinFonts(
                                      fontSize: base,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SpaceHelper(h: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
