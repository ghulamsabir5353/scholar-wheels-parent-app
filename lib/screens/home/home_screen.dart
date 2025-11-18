import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import 'package:scholarwheels/screens/home/notification_screen.dart';
import 'package:scholarwheels/screens/home/schedule_ride_screen.dart';
import 'package:scholarwheels/screens/home/widgets/manage_ride_modal.dart';
import 'package:scholarwheels/screens/settings/setting_screen.dart';
import 'package:scholarwheels/screens/home/tracking/live_tracking_screen.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/services/api_state.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  /// Get greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Get full name with surname
  String _getFullName() {
    final user = BaseHelper.currentUser.value;
    final firstName = user.firstName ?? '';
    final surName = user.surName ?? '';

    if (firstName.isNotEmpty && surName.isNotEmpty) {
      return '$firstName $surName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (surName.isNotEmpty) {
      return surName;
    } else {
      return 'User';
    }
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1].split(' ').first; // Remove any AM/PM if present
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return time;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM, yyyy').format(date);
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _showManageRideModal(BuildContext context, NextTrip trip) {
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
    final bottomController = Get.find<BottomTabController>();
    final mainController = Get.find<MainController>();

    return KeyboardNavigator(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          centerTitle: false,
          leadingWidth: 25,
          leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            icon: const Icon(Icons.menu),
            color: AppColor.headingFontColor,
            onPressed: () =>
                bottomController.rootScaffoldKey.currentState?.openDrawer(),
          ),
          title: Row(
            children: [
              Semantics(
                label: 'Profile settings',
                hint: 'Tap to open settings',
                button: true,
                onTap: () {
                  Get.toNamed(SettingScreen.route);
                },
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(SettingScreen.route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: CircleAvatar(
                      backgroundColor: AppColor.darkPrimary,
                      radius: 18,
                      child: Text(
                        _getFullName().substring(0, 1).toUpperCase(),
                        style: poppinFonts(
                          color: AppColor.appColorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SpaceHelper(w: 6.w),
              Expanded(
                child: Semantics(
                  label: 'Welcome message and dashboard title',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          '${_getGreeting()}, ${_getFullName()} 👋',
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Parent Dashboard',
                        style: poppinFonts(
                          color: AppColor.textLightBlackColor4A4A4A,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Semantics(
              label: 'Notifications',
              hint: 'Tap to view notifications. You have 1 unread notification',
              button: true,
              onTap: () {
                Get.toNamed(NotificationScreen.route);
              },
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(NotificationScreen.route);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 8),
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -6, end: -2),
                    showBadge: true,
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: AppColor.redColor,
                      padding: EdgeInsets.all(6),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    badgeContent: Semantics(
                      label: '1 unread notification',
                      child: Text(
                        '1',
                        style: poppinFonts(
                          color: AppColor.appColorWhite,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    child: Container(
                      width: 28,
                      height: 28,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        "assets/images/svg/notification.svg",
                        width: 12,
                        height: 12,
                        colorFilter: const ColorFilter.mode(
                          AppColor.appBlackColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          final state = mainController.dashboardState.value;

          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is ErrorState<DashboardModel>) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: poppinFonts(color: Colors.red)),
                  SpaceHelper(h: 16.h),
                  CustomButton(
                    title: 'Retry',
                    onPressed: () => mainController.getDashboardData(),
                  ),
                ],
              ),
            );
          }

          if (state is EmptyState<DashboardModel>) {
            return Center(
              child: Text(
                state.message,
                style: poppinFonts(color: AppColor.textLightBlackColor4A4A4A),
              ),
            );
          }

          if (state is DataState<DashboardModel>) {
            final dashboard = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                await mainController.getDashboardData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(12.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              'Active Rides',
                              dashboard.counts?.activeRides ?? 0,
                            ),
                          ),
                          SpaceHelper(w: 12.w),
                          Expanded(
                            child: _buildSummaryCard(
                              'Active Contracts',
                              dashboard.counts?.totalContracts ?? 0,
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 24.h),

                      // Today Active Rides Section
                      if (dashboard.activeRides != null)
                        _buildTodayActiveRidesSection(dashboard.activeRides!),

                      // Upcoming Rides Section
                      if (dashboard.nextTrip != null)
                        _buildUpcomingRidesSection(
                          context,
                          dashboard.nextTrip!,
                        ),

                      // Active Contracts Section
                      if (dashboard.recentContracts != null &&
                          dashboard.recentContracts!.isNotEmpty)
                        _buildActiveContractsSection(
                          dashboard.recentContracts!,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE7E7E7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: poppinFonts(
              color: AppColor.darkPrimary,
              fontSize: sm,
              fontWeight: FontWeight.w500,
            ),
          ),
          SpaceHelper(h: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: poppinFonts(
                color: AppColor.primary,
                fontSize: sm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayActiveRidesSection(NextTrip activeRide) {
    // Check if it's today's active ride
    final today = DateTime.now();
    final isTodayActive =
        activeRide.serviceDate != null &&
        activeRide.status?.toLowerCase() == 'active';

    if (!isTodayActive) return SizedBox.shrink();

    final tripDate = DateTime(
      activeRide.serviceDate!.year,
      activeRide.serviceDate!.month,
      activeRide.serviceDate!.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);

    if (tripDate != todayDate) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Today Active Rides',
          'Track your child\'s current ride in real-time',
          onViewAll: () {
            Get.toNamed(ScheduleRideScreen.route, arguments: 'active');
          },
        ),
        SpaceHelper(h: 12.h),
        _buildActiveRideCard(activeRide),
        SpaceHelper(h: 24.h),
      ],
    );
  }

  Widget _buildUpcomingRidesSection(BuildContext context, NextTrip nextTrip) {
    // Check if it's not today's active ride
    final today = DateTime.now();
    if (nextTrip.serviceDate != null) {
      final tripDate = DateTime(
        nextTrip.serviceDate!.year,
        nextTrip.serviceDate!.month,
        nextTrip.serviceDate!.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      if (tripDate == todayDate && nextTrip.status?.toLowerCase() == 'active') {
        return SizedBox.shrink(); // Already shown in active rides
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Upcoming Rides',
          'Manage upcoming rides',
          onViewAll: () {
            Get.toNamed(ScheduleRideScreen.route, arguments: 'scheduled');
          },
        ),
        SpaceHelper(h: 12.h),
        _buildUpcomingRideCard(context, nextTrip),
        SpaceHelper(h: 24.h),
      ],
    );
  }

  Widget _buildActiveContractsSection(List<dynamic> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Active Contracts',
          'View and manage your transport contracts',
          onViewAll: () {
            // Navigate to all contracts
          },
        ),
        SpaceHelper(h: 12.h),
        ...contracts.map((contract) => _buildContractCard(contract)),
        SpaceHelper(h: 24.h),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle, {
    VoidCallback? onViewAll,
  }) {
    return GestureDetector(
      onTap: onViewAll,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SpaceHelper(h: 4.h),
                Text(
                  subtitle,
                  style: poppinFonts(
                    fontSize: sm,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ],
            ),
          ),
          if (onViewAll != null)
            SvgPicture.asset("assets/images/svg/forward_button.svg"),
        ],
      ),
    );
  }

  Widget _buildActiveRideCard(NextTrip trip) {
    final firstChild = trip.assignedChildren?.isNotEmpty == true
        ? trip.assignedChildren!.first
        : null;
    final childName = firstChild?.child?.name ?? 'Child';
    final vehicle = trip.vehicle;
    final driver = trip.driver;
    final vehicleName = vehicle != null
        ? '${vehicle.make ?? ''} ${vehicle.model ?? ''}'.trim()
        : 'N/A';
    final vehicleDetails = vehicle?.registrationNumber ?? '';
    final driverName = driver?.fullName ?? 'N/A';
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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xffECF4E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.secondary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Info and Status
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.darkPrimary,
                child: Text(
                  _getInitials(childName),
                  style: poppinFonts(
                    color: AppColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SpaceHelper(w: 12.w),
              Expanded(
                child: Text(
                  childName,
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  'Active',
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

          // Vehicle & Driver
          Row(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Driver',
                    style: poppinFonts(
                      color: AppColor.textLightBlackColor4A4A4A,
                      fontSize: sm,
                    ),
                  ),
                  Text(
                    driverName,
                    style: poppinFonts(
                      color: AppColor.black,
                      fontSize: base,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpaceHelper(h: 16.h),

          // Route Details
          RouteEntryWidget(
            pickupAddress: pickupAddress,
            schoolName: schoolName,
          ),
          SpaceHelper(h: 8.h),

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
                    _formatTime(pickupTime.toString()),
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
                    _formatTime(dropoffTime.toString()),
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

          // Live Tracking Button
          CustomButton(
            width: double.infinity,
            title: 'Live Tracking',
            onPressed: () {
              Get.toNamed(LiveTrackingScreen.route, arguments: trip);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingRideCard(BuildContext context, NextTrip trip) {
    final firstChild = trip.assignedChildren?.isNotEmpty == true
        ? trip.assignedChildren!.first
        : null;
    final childName = firstChild?.child?.name ?? 'Child';
    final vehicle = trip.vehicle;
    final driver = trip.driver;
    final vehicleName = vehicle != null
        ? '${vehicle.make ?? ''} ${vehicle.model ?? ''}'.trim()
        : 'N/A';
    final vehicleDetails = vehicle?.registrationNumber ?? '';
    final driverName = driver?.fullName ?? 'N/A';
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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xffECF4E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.secondary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Info and Status
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.darkPrimary,
                child: Text(
                  _getInitials(childName),
                  style: poppinFonts(
                    color: AppColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SpaceHelper(w: 8.w),
              Expanded(
                child: Text(
                  childName,
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  trip.status ?? 'Scheduled',
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

          // Vehicle & Driver
          Row(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Driver',
                    style: poppinFonts(
                      color: AppColor.textLightBlackColor4A4A4A,
                      fontSize: sm,
                    ),
                  ),
                  Text(
                    driverName,
                    style: poppinFonts(
                      color: AppColor.black,
                      fontSize: base,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpaceHelper(h: 16.h),

          // Route Details
          RouteEntryWidget(
            pickupAddress: pickupAddress,
            schoolName: schoolName,
          ),
          SpaceHelper(h: 12.h),

          // Schedule Date
          if (trip.serviceDate != null)
            Row(
              children: [
                Text('Schedule Date: '),
                Text(
                  ' ${_formatDate(trip.serviceDate)}',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          SpaceHelper(h: 8.h),

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
                    _formatTime(pickupTime.toString()),
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
                    _formatTime(dropoffTime.toString()),
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

          // Manage Ride Button
          Container(
            height: 36.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.secondary, width: 1),
            ),
            child: TextButton(
              onPressed: () {
                _showManageRideModal(context, trip);
              },
              child: Text(
                'Manage Ride',
                style: poppinFonts(
                  color: AppColor.primary,
                  fontSize: sm,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractCard(dynamic contract) {
    // Handle both ContractModel and Map
    String? contractId;
    String? contractDuration;
    String? monthlyFee;
    String? status;

    if (contract is Map<String, dynamic>) {
      contractId = contract['contractId'] ?? contract['_id'];
      contractDuration = contract['contractDuration'];
      monthlyFee = contract['monthlyPayment']?.toString();
      status = contract['status'];
    } else {
      // Assume it's ContractModel
      try {
        contractId = contract.contractId ?? contract.id;
        contractDuration = contract.contractDuration;
        monthlyFee = contract.monthlyPayment?.toString();
        status = contract.status;
      } catch (e) {
        // Fallback
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.secondary),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'School Transport',
                  style: poppinFonts(
                    color: AppColor.black,
                    fontSize: base,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SpaceHelper(h: 8.h),
                Row(
                  children: [
                    Text(
                      'Contract# ',
                      style: poppinFonts(
                        color: AppColor.textLightBlackColor4A4A4A,
                        fontSize: sm,
                      ),
                    ),
                    Text(
                      contractId ?? 'N/A',
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
                      'Contract Duration: ',
                      style: poppinFonts(
                        color: AppColor.textLightBlackColor4A4A4A,
                        fontSize: sm,
                      ),
                    ),
                    Text(
                      contractDuration ?? 'N/A',
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
                      'Monthly Fee: ',
                      style: poppinFonts(
                        color: AppColor.textLightBlackColor4A4A4A,
                        fontSize: sm,
                      ),
                    ),
                    Text(
                      monthlyFee ?? '0',
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
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status?.capitalizeFirst ?? 'Active',
              style: poppinFonts(
                color: AppColor.white,
                fontSize: sm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
