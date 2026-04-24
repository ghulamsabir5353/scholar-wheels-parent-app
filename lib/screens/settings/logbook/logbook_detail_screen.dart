import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/location_permission_map_gate.dart';
import 'package:scholarwheels/core/helper.widgets/route_map_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/trip_model.dart';
import 'package:scholarwheels/screens/tab_screen.dart';
import 'package:scholarwheels/services/api_state.dart';

class LogBookDetailScreen extends StatefulWidget {
  static const route = '/logbook_detail';
  const LogBookDetailScreen({super.key});

  @override
  State<LogBookDetailScreen> createState() => _LogBookDetailScreenState();
}

class _LogBookDetailScreenState extends State<LogBookDetailScreen> {
  bool _isInteractingWithMap = false;
  int _mapPointerCount = 0;
  late final MainController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(MainController());
    final arguments = Get.arguments as Map<String, dynamic>?;
    final id = arguments?['_id']?.toString();

    if (id != null && id.isNotEmpty) {
      _controller.getTripDetail(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final tripId = arguments?['tripId']?.toString() ?? '';
    late final String? status = arguments?['status']?.toString();
    late final String? childId = arguments?['childId']?.toString();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 0.5,
        shadowColor: Colors.grey,
        leading: backButton(onTap: () => Get.back()),
        titleSpacing: 0,

        title: Text(
          tripId.isEmpty ? 'Trip Detail' : tripId,
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final state = _controller.tripDetailState.value;

        if (state is LoadingState<TripModel>) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (state is ErrorState<TripModel>) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: poppinFonts(color: Colors.red, fontSize: sm),
                  ),
                  SpaceHelper(h: 16.h),
                  OutlinedButton(
                    onPressed: () {
                      if (tripId.isNotEmpty) {
                        _controller.getTripDetail(tripId);
                      }
                    },
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
              ),
            ),
          );
        }

        if (state is ExceptionState<TripModel>) {
          return Center(
            child: Text(
              'Something went wrong',
              style: poppinFonts(color: Colors.red, fontSize: sm),
            ),
          );
        }

        if (state is! DataState<TripModel>) {
          return const SizedBox.shrink();
        }

        final trip = state.data;
        final vehicle = trip.vehicle;
        final driver = trip.driver;
        final assignedChildren = trip.assignedChildren ?? [];
        final pickupTime = trip.pickupStatusUpdatedAt ?? trip.pickupTime;
        final dropOffTime =
            trip.dropOffStatusUpdatedAt ?? trip.dropOffTime?.toString();

        String formatDate(DateTime? date) {
          return AppDateTimeFormatter.format(date, pattern: 'MMMM d, yyyy');
        }

        String formatTime(String? time) {
          return AppDateTimeFormatter.formatStringTime(
            time,
            referenceDate: trip.serviceDate ?? trip.createdAt,
          );
        }

        // make sure it returns the duration in hours and minutes ans seconds 2 h 3min 5 sec
        String formatDurationInHoursMinutesSeconds(
          DateTime? start,
          DateTime? end,
        ) {
          if (status?.toLowerCase() == 'cancelled') {
            return 'N/A';
          }
          if (start == null || end == null) {
            return 'N/A';
          }

          try {
            final diff = end.difference(start);
            final hours = diff.inHours;
            final minutes = diff.inMinutes % 60;
            final seconds = diff.inSeconds % 60;

            return '${hours}h ${minutes > 0 ? '${minutes}min ' : ''} ${seconds > 0 ? '${seconds}sec' : ''}';
          } catch (e) {
            return 'N/A';
          }
        }

        final vehicleName = vehicle != null
            ? '${vehicle.make ?? ''} ${vehicle.model ?? ''}'.trim()
            : 'N/A';
        final vehicleReg = vehicle?.registrationNumber ?? 'N/A';
        final vehicleColor = vehicle?.color ?? 'N/A';
        final vehicleType = vehicle?.vehicleType ?? 'N/A';
        final vehicleYear = vehicle?.manufacturingYear?.toString() ?? 'N/A';

        final driverName =
            driver?.fullName ??
            '${trip.transportOwner?.firstName ?? ''} ${trip.transportOwner?.surName ?? ''}'
                .trim();
        final driverDisplay = driverName.isEmpty ? 'N/A' : driverName;

        final firstChild = assignedChildren.isNotEmpty
            ? assignedChildren.firstWhere((child) => child.child?.id == childId)
            : null;
        final childPickupDisplayTime = () {
          final raw =
              firstChild?.pickupStatusUpdatedAt ??
              firstChild?.pickupTime ??
              trip.pickupTime ??
              trip.scheduledPickupTime;
          if (raw == null || raw.trim().isEmpty) {
            return AppDateTimeFormatter.format(
              trip.startTime,
              pattern: 'h:mm a',
            );
          }
          return formatTime(raw);
        }();
        final pickupAddress =
            firstChild?.pickupAddress?.description ??
            firstChild?.child?.pickUpAddress?.description ??
            'N/A';
        final school =
            firstChild?.child?.school ??
            firstChild?.child?.dropOffAddress?.description ??
            'N/A';

        // final status = trip.status ?? 'N/A';
        final dateText = formatDate(trip.serviceDate ?? trip.createdAt);
        final distanceKm = trip.route?.estimatedDistance;
        final distanceText = distanceKm != null ? '$distanceKm Kms' : 'N/A';

        final transportOwner = trip.transportOwner;
        final ownerName = transportOwner?.businessName?.isNotEmpty == true
            ? transportOwner!.businessName!
            : '${transportOwner?.firstName ?? ''} ${transportOwner?.surName ?? ''}'
                  .trim();
        final ownerDisplay = ownerName.isEmpty ? 'N/A' : ownerName;
        final fullName =
            '${transportOwner?.user?.firstName ?? ''} ${transportOwner?.user?.surName ?? ''}'
                .trim();
        final fullNameDisplay = fullName.isEmpty ? 'N/A' : fullName;
        final email = transportOwner?.user?.email ?? 'N/A';
        final phone = transportOwner?.user?.phone ?? 'N/A';
        final rating = transportOwner?.averageRating;
        final totalRatings = transportOwner?.totalRatings ?? 0;
        final ratingText = rating != null
            ? '${rating.toStringAsFixed(0)} (${totalRatings.toStringAsFixed(0)} reviews)'
            : 'N/A';
        final isVerified = transportOwner?.isVerified ?? false;

        final pickupLoc =
            firstChild?.pickupAddress ?? firstChild?.child?.pickUpAddress;
        final dropOffLoc = firstChild?.child?.dropOffAddress;

        // Match list + header: absent child is shown as Cancelled; use N/A for ride/pickup times.
        final showRideTimesAsNa =
            status?.toLowerCase() == 'cancelled' ||
            trip.status?.toLowerCase() == 'cancelled' ||
            firstChild?.pickupStatus?.toLowerCase() == 'absent';

        return SingleChildScrollView(
          physics: _isInteractingWithMap
              ? const NeverScrollableScrollPhysics()
              : null,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeading('Ride Overview', status: status),
              SpaceHelper(h: 12.h),
              _buildRideOverviewCard(
                dateText: dateText,
                startTime: showRideTimesAsNa
                    ? 'N/A'
                    : AppDateTimeFormatter.format(
                        trip.startTime,
                        pattern: 'h:mm a',
                      ),
                childPickupTime: showRideTimesAsNa
                    ? 'N/A'
                    : childPickupDisplayTime,
                endTime: showRideTimesAsNa
                    ? 'N/A'
                    : AppDateTimeFormatter.format(
                        trip.endTime,
                        pattern: 'h:mm a',
                      ),
                distance: distanceText,
                duration: formatDurationInHoursMinutesSeconds(
                  trip.startTime,
                  trip.endTime,
                ),
              ),
              SpaceHelper(h: 20.h),

              _buildSectionHeading('Driver & Vehicle Info'),
              SpaceHelper(h: 12.h),
              _buildDriverVehicleCard(
                driverName: driverDisplay,
                vehicle: vehicleName,
                registration: vehicleReg,
                vehicleType: vehicleType.capitalizeFirst ?? vehicleType,
                model: vehicleYear,
                color: vehicleColor,
              ),
              SpaceHelper(h: 20.h),

              _buildSectionHeading('Child Detail'),
              SpaceHelper(h: 12.h),
              _buildChildDetailCard(
                name: firstChild?.child?.name ?? 'N/A',
                age: firstChild?.child?.age,
              ),
              SpaceHelper(h: 20.h),

              _buildSectionHeading('Route Details'),
              SpaceHelper(h: 12.h),
              _buildRouteDetailsCard(
                pickupTime: formatTime(pickupTime),
                dropOffTime: formatTime(dropOffTime),
                pickupAddress: pickupAddress,
                schoolName: school,
              ),
              SpaceHelper(h: 20.h),

              _buildSectionHeading('Route Map'),
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
                        if (pickupLoc != null && dropOffLoc != null)
                          LocationPermissionMapGate(
                            child: RouteMapWidget(
                              pickupLocation: pickupLoc,
                              dropOffLocation: dropOffLoc,
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                            ),
                          )
                        else
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Map not available',
                                style: poppinFonts(
                                  fontSize: sm,
                                  color: AppColor.textLightBlackColor4A4A4A,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SpaceHelper(h: 20.h),

              _buildSectionHeading('Transport Owner Details'),
              SpaceHelper(h: 12.h),
              _buildTransportOwnerCard(
                name: ownerDisplay,
                fullName: fullNameDisplay,
                email: email,
                phone: phone,
                ratingText: ratingText,
                isVerified: isVerified,
              ),
              SpaceHelper(h: 80.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeading(String title, {String? status}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: poppinFonts(
            fontSize: base,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        if (status != null && status.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: status.toLowerCase() == 'completed'
                  ? AppColor.primary
                  : status.toLowerCase() == 'cancelled'
                  ? AppColor.notCompletedStatusColor
                  : AppColor.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status.capitalizeFirst ?? status,
              style: poppinFonts(
                fontSize: xs,
                fontWeight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRideOverviewCard({
    required String dateText,
    required String startTime,
    required String childPickupTime,
    required String endTime,
    required String distance,
    required String duration,
  }) {
    return _buildWhiteCard(
      child: Column(
        children: [
          _buildLabelValueRow('Date:', dateText),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Ride Start Time:', startTime),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Child Picked At:', childPickupTime),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Ride End Time:', endTime),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Distance:', distance),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Ride Duration:', duration),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: poppinFonts(
            fontSize: sm,
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
        Text(
          value,
          style: poppinFonts(
            fontSize: sm,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverVehicleCard({
    required String driverName,
    required String vehicle,
    required String registration,
    required String vehicleType,
    required String model,
    required String color,
  }) {
    return _buildWhiteCard(
      child: Column(
        children: [
          _buildLabelValueRow('Driver Name:', driverName),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Vehicle:', vehicle),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Registration no.', registration),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Vehicle Type:', vehicleType),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Model:', model),
          SpaceHelper(h: 12.h),
          _buildLabelValueRow('Color:', color),
        ],
      ),
    );
  }

  Widget _buildChildDetailCard({required String name, int? age}) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return _buildWhiteCard(
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: AppColor.darkPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: poppinFonts(
                  fontSize: lg,
                  fontWeight: FontWeight.w600,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
          SpaceHelper(w: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: poppinFonts(
                    fontSize: base,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                if (age != null) ...[
                  Text(
                    'Age $age',
                    style: poppinFonts(
                      fontSize: sm,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDetailsCard({
    required String pickupTime,
    required String dropOffTime,
    required String pickupAddress,
    required String schoolName,
  }) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.cardShadowColor,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColor.secondary),
      ),
      color: AppColor.cardBgColor,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: _buildDetailRow('Pickup Time :', pickupTime)),
                Flexible(
                  child: _buildDetailRow('Drop Off Time :', dropOffTime),
                ),
              ],
            ),
            SpaceHelper(h: 12.h),
            // Pickup and School Info
            RouteEntryWidget(
              pickupAddress: pickupAddress,
              schoolName: schoolName,
              isLast: true,
              backgroundColor: Colors.white,
            ),
          ],
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

  Widget _buildTransportOwnerCard({
    required String name,
    required String fullName,
    required String email,
    required String phone,
    required String ratingText,
    required bool isVerified,
  }) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return _buildWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: AppColor.darkPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: poppinFonts(
                      fontSize: lg,
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              SpaceHelper(w: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: poppinFonts(
                              fontSize: base,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        if (isVerified)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightSecondary,
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 14.w,
                                  color: AppColor.black,
                                ),
                                SpaceHelper(w: 4.w),
                                Text(
                                  'Verified',
                                  style: poppinFonts(
                                    fontSize: xs,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SpaceHelper(h: 4.h),
                    Text(
                      ratingText,
                      style: poppinFonts(
                        fontSize: sm,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SpaceHelper(h: 16.h),
          _buildLabelValueRow('Full Name:', fullName),
          SpaceHelper(h: 8.h),
          _buildLabelValueRow('Email:', email),
          SpaceHelper(h: 8.h),
          _buildLabelValueRow('Phone:', phone),
          SpaceHelper(h: 16.h),
          CustomButton(
            onPressed: () {
              Get.until((route) => route.settings.name == TabScreen.route);
              Get.find<BottomTabController>().setTabIndex(4);
            },
            title: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: AppColor.cardShadow,
      ),
      child: child,
    );
  }
}
