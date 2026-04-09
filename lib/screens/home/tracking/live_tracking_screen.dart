import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:scholarwheels/controllers/live_tracking_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/location_permission_map_gate.dart';
import 'package:scholarwheels/core/helper.widgets/route_map_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/models/location_data_model.dart'
    as location_model;

class LiveTrackingScreen extends StatefulWidget {
  static const String route = '/live-tracking-screen';
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  /// When GPS speed is missing or very low, assume typical urban driving (km/h).
  static const double _fallbackSpeedKmh = 32.0;
  static const double _minReportedSpeedKmh = 5.0;

  late final LiveTrackingController controller;
  NextTrip? initialTrip;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LiveTrackingController>();
    initialTrip = Get.arguments as NextTrip?;
    controller.configureWithArguments(initialTrip, forceRefresh: true);
  }

  @override
  void dispose() {
    controller.leaveTrip();
    super.dispose();
  }

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

  /// Same drop-off as the map: last assigned child's drop-off coordinates.
  LatLng? _dropOffLatLng(NextTrip? trip) {
    if (trip?.assignedChildren == null || trip!.assignedChildren!.isEmpty) {
      return null;
    }
    final dropAddr = trip.assignedChildren!.last.child?.dropOffAddress;
    final loc = _convertPickupAddressToLocationData(dropAddr);
    if (loc == null) return null;
    final lat = loc.coordinates.latitude;
    final lng = loc.coordinates.longitude;
    if (lat == 0.0 && lng == 0.0) return null;
    return LatLng(lat, lng);
  }

  String _formatStraightLineDistance(num meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatEtaMinutes(double totalMinutes) {
    if (totalMinutes.isNaN || totalMinutes.isInfinite) return 'N/A';
    if (totalMinutes < 1) return '< 1 min';
    final rounded = totalMinutes.round();
    if (rounded < 60) return '$rounded min';
    final h = rounded ~/ 60;
    final m = rounded % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  /// Prefer socket location; fall back to trip `currentLocation` from dashboard/API.
  Map<String, dynamic>? _effectiveDriverLocation(
    NextTrip? trip,
    Map<String, dynamic>? socketLoc,
  ) {
    final hasSocket =
        socketLoc != null &&
        socketLoc['latitude'] != null &&
        socketLoc['longitude'] != null;
    if (hasSocket) return socketLoc;

    final api = trip?.currentLocationLatLng;
    if (api != null) {
      return <String, dynamic>{
        'latitude': api.latitude,
        'longitude': api.longitude,
        'speed': null,
      };
    }
    return null;
  }

  /// Straight-line distance from driver's live position to drop-off (map route end).
  String _getDistance(NextTrip? trip, Map<String, dynamic>? driverLoc) {
    final drop = _dropOffLatLng(trip);
    if (drop == null) return 'N/A';
    if (driverLoc == null ||
        driverLoc['latitude'] == null ||
        driverLoc['longitude'] == null) {
      return 'N/A';
    }
    final dLat = (driverLoc['latitude'] as num).toDouble();
    final dLng = (driverLoc['longitude'] as num).toDouble();
    final meters = mtk.SphericalUtil.computeDistanceBetween(
      mtk.LatLng(dLat, dLng),
      mtk.LatLng(drop.latitude, drop.longitude),
    );
    return _formatStraightLineDistance(meters);
  }

  /// ETA using distance ÷ speed (driver GPS km/h when reliable, else typical speed).
  String _getEstimatedTime(NextTrip? trip, Map<String, dynamic>? driverLoc) {
    final drop = _dropOffLatLng(trip);
    if (drop == null) return 'N/A';
    if (driverLoc == null ||
        driverLoc['latitude'] == null ||
        driverLoc['longitude'] == null) {
      return 'N/A';
    }
    final dLat = (driverLoc['latitude'] as num).toDouble();
    final dLng = (driverLoc['longitude'] as num).toDouble();
    final meters = mtk.SphericalUtil.computeDistanceBetween(
      mtk.LatLng(dLat, dLng),
      mtk.LatLng(drop.latitude, drop.longitude),
    ).toDouble();
    if (meters <= 0) return '< 1 min';

    final rawSpeed = (driverLoc['speed'] as num?)?.toDouble();
    final speedKmh = (rawSpeed != null && rawSpeed >= _minReportedSpeedKmh)
        ? rawSpeed
        : _fallbackSpeedKmh;
    final km = meters / 1000.0;
    final hours = km / speedKmh;
    final minutes = hours * 60;
    return _formatEtaMinutes(minutes);
  }

  Widget _buildDriverLocationChip(Map<String, dynamic>? driverLoc) {
    if (driverLoc == null) return const SizedBox.shrink();

    final lat = (driverLoc['latitude'] as num?)?.toDouble();
    final lng = (driverLoc['longitude'] as num?)?.toDouble();
    final speed = (driverLoc['speed'] as num?)?.toDouble();

    if (lat == null || lng == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Driver is live',
            style: poppinFonts(
              fontSize: sm,
              fontWeight: FontWeight.w600,
              color: AppColor.headingFontColor,
            ),
          ),
          SpaceHelper(h: 4.h),
          Text(
            'Lat ${lat.toStringAsFixed(4)}, Lng ${lng.toStringAsFixed(4)}',
            style: poppinFonts(
              fontSize: sm,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
          if (speed != null)
            Text(
              'Speed ${(speed).toStringAsFixed(1)} km/h',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trip = controller.trip ?? initialTrip ?? Get.arguments as NextTrip?;
      // Socket updates this Rx → distance/ETA refresh; API snapshot used until then.
      final socketLoc = controller.driverLocation.value;
      final driverLoc = _effectiveDriverLocation(trip, socketLoc);
      final LatLng? driverLatLng =
          driverLoc != null &&
              driverLoc['latitude'] != null &&
              driverLoc['longitude'] != null
          ? LatLng(
              (driverLoc['latitude'] as num).toDouble(),
              (driverLoc['longitude'] as num).toDouble(),
            )
          : null;

      if (trip == null) {
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

      // Do not show map or allow tracking if ride is not scheduled for today
      if (!trip.isScheduledForToday) {
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
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'This ride is not scheduled for today. Live tracking is only available on the day of the ride.',
                textAlign: TextAlign.center,
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            ),
          ),
        );
      }

      // Collect all pickup locations from all assigned children
      List<location_model.LocationData>? allPickupLocations;
      if (trip.assignedChildren != null && trip.assignedChildren!.isNotEmpty) {
        allPickupLocations = <location_model.LocationData>[];
        for (var assignedChild in trip.assignedChildren!) {
          if (assignedChild.pickupAddress != null) {
            final pickupLoc = _convertPickupAddressToLocationData(
              assignedChild.pickupAddress,
            );
            if (pickupLoc != null &&
                pickupLoc.coordinates.latitude != 0.0 &&
                pickupLoc.coordinates.longitude != 0.0) {
              allPickupLocations.add(pickupLoc);
            }
          }
        }
      }

      // First pickup location (for backward compatibility)
      final pickupLocation = allPickupLocations?.isNotEmpty == true
          ? allPickupLocations!.first
          : _convertPickupAddressToLocationData(
              trip.assignedChildren?.isNotEmpty == true
                  ? trip.assignedChildren!.first.pickupAddress
                  : null,
            );

      // Final dropoff location (use the last child's dropoff or first if only one)
      final dropOffLocation =
          trip.assignedChildren?.isNotEmpty == true &&
              trip.assignedChildren!.last.child?.dropOffAddress != null
          ? _convertPickupAddressToLocationData(
              trip.assignedChildren!.last.child!.dropOffAddress,
            )
          : null;

      final hasPickupCoords =
          (allPickupLocations != null && allPickupLocations.isNotEmpty) ||
          (pickupLocation != null &&
              pickupLocation.coordinates.latitude != 0.0 &&
              pickupLocation.coordinates.longitude != 0.0);
      final hasDropCoords =
          dropOffLocation != null &&
          dropOffLocation.coordinates.latitude != 0.0 &&
          dropOffLocation.coordinates.longitude != 0.0;
      final mapReady =
          (hasPickupCoords || hasDropCoords) &&
          (driverLatLng != null || (hasPickupCoords && hasDropCoords));

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
                height: MediaQuery.of(context).size.height * 0.78,
                width: double.infinity,
                child: mapReady
                    ? LocationPermissionMapGate(
                        child: RouteMapWidget(
                          pickupLocation: pickupLocation,
                          dropOffLocation: dropOffLocation,
                          driverLocation: driverLatLng,
                          pickupLocations: allPickupLocations,
                          coveredPath: controller.driverPath.isNotEmpty
                              ? controller.driverPath.toList()
                              : null,
                          remainingPath: controller.buildRemainingPath(),
                          height: MediaQuery.of(context).size.height * 0.78,
                          width: double.infinity,
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            'Map will appear when route is ready',
                            style: poppinFonts(
                              fontSize: base,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            // if (driverLoc != null)
            //   Positioned(
            //     top: 12.h,
            //     right: 12.w,
            //     child: _buildDriverLocationChip(driverLoc),
            //   ),
            // Trip Details Card - Bottom Sheet Style
            DraggableScrollableSheet(
              initialChildSize: 0.125,
              minChildSize: 0.125,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.cardBgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    border: Border(
                      top: BorderSide(color: AppColor.primary, width: 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Handle
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                  // Driver and Child Info - Paired rows (prevents misalignment on wrapping text)
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Driver',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
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
                                              ],
                                            ),
                                          ),
                                          SpaceHelper(w: 24.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Child',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SpaceHelper(h: 12.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pickup Order',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
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
                                              ],
                                            ),
                                          ),
                                          SpaceHelper(w: 24.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pickup Area',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
                                                  ),
                                                ),
                                                SpaceHelper(h: 4.h),
                                                Text(
                                                  _getPickupAddress(trip),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                      SpaceHelper(h: 12.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pickup Time',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
                                                  ),
                                                ),
                                                SpaceHelper(h: 4.h),
                                                Text(
                                                  _formatTime(
                                                    _getPickupTime(trip),
                                                  ),
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
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Drop-off Time',
                                                  style: poppinFonts(
                                                    fontSize: sm,
                                                    color: AppColor
                                                        .textLightBlackColor4A4A4A,
                                                  ),
                                                ),
                                                SpaceHelper(h: 4.h),
                                                Text(
                                                  _formatTime(
                                                    _getDropOffTime(trip),
                                                  ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Distance',
                                            style: poppinFonts(
                                              fontSize: sm,
                                              color: AppColor
                                                  .textLightBlackColor4A4A4A,
                                            ),
                                          ),
                                          SpaceHelper(h: 4.h),
                                          Text(
                                            _getDistance(trip, driverLoc),
                                            style: poppinFonts(
                                              fontSize: base,
                                              color: AppColor.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Estimated Time',
                                            style: poppinFonts(
                                              fontSize: sm,
                                              color: AppColor
                                                  .textLightBlackColor4A4A4A,
                                            ),
                                          ),
                                          SpaceHelper(h: 4.h),
                                          Text(
                                            _getEstimatedTime(trip, driverLoc),
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
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
