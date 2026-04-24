import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_outline_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/screens/home/notification_screen.dart';
import 'package:scholarwheels/screens/home/schedule_ride_screen.dart';
import 'package:scholarwheels/controllers/notification_controller.dart';
import 'package:scholarwheels/screens/home/widgets/manage_ride_modal.dart';
import 'package:scholarwheels/screens/settings/setting_screen.dart';
import 'package:scholarwheels/screens/home/tracking/live_tracking_screen.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/services/api_state.dart';

Color? getStatusColor(String? status) {
  switch (status) {
    case 'scheduled':
    case 'active':
      return AppColor.primary;
    case 'cancelled':
      return AppColor.notCompletedStatusColor;
    default:
      return AppColor.yellowText;
  }
}

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final mainController = Get.find<MainController>();
    mainController.getDashboardData();
  }

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

  String _formatTime(String? time, {DateTime? referenceDate}) {
    return AppDateTimeFormatter.formatStringTime(
      time,
      referenceDate: referenceDate,
    );
  }

  String _formatDate(DateTime? date) {
    return AppDateTimeFormatter.format(date, pattern: 'dd MMM, yyyy');
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
    // Initialize notification controller to start unread count polling
    Get.put(NotificationController(), permanent: true);

    return KeyboardNavigator(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          centerTitle: false,
          titleSpacing: 0,

          leading: InkWell(
            onTap: () =>
                bottomController.rootScaffoldKey.currentState?.openDrawer(),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Icon(
                Icons.menu,
                color: AppColor.headingFontColor,
                size: 32.w,
              ),
            ),
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
                    child: Obx(() {
                      final user = BaseHelper.currentUser.value;
                      final profileImageUrl =
                          user.profileImagePresignedUrl ?? user.profileImage;
                      final initials = _getFullName()
                          .substring(0, 1)
                          .toUpperCase();

                      return Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? Colors.transparent
                              : AppColor.darkPrimary,
                        ),
                        child:
                            profileImageUrl != null &&
                                profileImageUrl.isNotEmpty
                            ? ClipOval(
                                child: CustomNetworkImageWidget(
                                  imageUrl: profileImageUrl,
                                  width: 36,
                                  height: 36,
                                  borderRadius: 18,
                                  fit: BoxFit.cover,
                                  errorWidget: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.darkPrimary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        initials,
                                        style: poppinFonts(
                                          color: AppColor.appColorWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  initials,
                                  style: poppinFonts(
                                    color: AppColor.appColorWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      );
                    }),
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
                          'Hi, ${_getFullName()} 👋',
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: md,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Obx(() {
              final notificationController = Get.find<NotificationController>();
              final count = notificationController.unreadCount.value;
              return Semantics(
                label: 'Notifications',
                hint: count > 0
                    ? 'Tap to view notifications. You have $count unread ${count == 1 ? 'notification' : 'notifications'}'
                    : 'Tap to view notifications',
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
                      showBadge: count > 0,
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: AppColor.redColor,
                        padding: EdgeInsets.all(6),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      badgeContent: Semantics(
                        label:
                            '$count unread ${count == 1 ? 'notification' : 'notifications'}',
                        child: Text(
                          count > 99 ? '99+' : '$count',
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
              );
            }),
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
            final hasActiveRideToday = _hasActiveRideToday(
              dashboard.activeRides,
            );
            final hasUpcomingRides =
                dashboard.nextTrip != null &&
                dashboard.nextTrip!.isNotEmpty &&
                _hasUpcomingRidesAfterFilter(dashboard);
            final hasAnyRides = hasActiveRideToday || hasUpcomingRides;
            final hasContracts =
                dashboard.recentContracts != null &&
                dashboard.recentContracts!.isNotEmpty;

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

                      // Upcoming Rides Section (list of cards)
                      if (dashboard.nextTrip != null &&
                          dashboard.nextTrip!.isNotEmpty)
                        _buildUpcomingRidesSection(
                          context,
                          dashboard.nextTrip!,
                        ),

                      // Empty state when no rides (new parent / no bookings)
                      if (!hasAnyRides) _buildDashboardEmptyState(context),

                      // Active Contracts Section
                      if (dashboard.recentContracts != null &&
                          dashboard.recentContracts!.isNotEmpty)
                        _buildActiveContractsSection(
                          dashboard.recentContracts!,
                        ),

                      // Empty state for no contracts (if no rides and no contracts)
                      if (!hasAnyRides && !hasContracts)
                        _buildNoContractMessage(context),
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

  bool _hasActiveRideToday(NextTrip? activeRides) {
    if (activeRides == null || activeRides.serviceDate == null) return false;
    if (activeRides.status?.toLowerCase() != 'active') return false;
    final today = DateTime.now();
    final tripDate = DateTime(
      activeRides.serviceDate!.year,
      activeRides.serviceDate!.month,
      activeRides.serviceDate!.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);
    return tripDate == todayDate;
  }

  bool _hasUpcomingRidesAfterFilter(DashboardModel dashboard) {
    final nextTrips = dashboard.nextTrip;
    if (nextTrips == null || nextTrips.isEmpty) return false;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final hasAny = nextTrips.any((trip) {
      if (trip.serviceDate == null) return true;
      final tripDate = DateTime(
        trip.serviceDate!.year,
        trip.serviceDate!.month,
        trip.serviceDate!.day,
      );
      if (tripDate == todayDate && trip.status?.toLowerCase() == 'active') {
        return false;
      }
      return true;
    });
    return hasAny;
  }

  Widget _buildDashboardEmptyState(BuildContext context) {
    final bottomController = Get.find<BottomTabController>();
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColor.cardBgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.borderGreen, width: 1),
        ),
        child: Column(
          children: [
            // Icon(
            //   Icons.directions_car_outlined,
            //   size: 48.w,
            //   color: AppColor.textLightBlackColor4A4A4A,
            // ),
            SpaceHelper(h: 16.h),
            Text(
              'No ride is scheduled today.',
              textAlign: TextAlign.center,
              style: poppinFonts(
                fontSize: base,
                fontWeight: FontWeight.w600,
                color: AppColor.headingFontColor,
              ),
            ),
            SpaceHelper(h: 6.h),
            Text(
              'No upcoming rides.',
              textAlign: TextAlign.center,
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 20.h),
            CustomButton(
              title: 'Request a booking for your child',
              onPressed: () {
                bottomController.setTabIndex(2);
                Get.until((route) => route.settings.name == '/tab_screen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoContractMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Center(
        child: Text(
          'No active contract.',
          style: poppinFonts(
            fontSize: sm,
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.cardBorderColorGrey),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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

  Widget _buildUpcomingRidesSection(
    BuildContext context,
    List<NextTrip> nextTrips,
  ) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Filter out trips that are already shown in Today's Active Rides
    final filtered = nextTrips.where((trip) {
      if (trip.serviceDate == null) return true;
      final tripDate = DateTime(
        trip.serviceDate!.year,
        trip.serviceDate!.month,
        trip.serviceDate!.day,
      );
      if (tripDate == todayDate && trip.status?.toLowerCase() == 'active') {
        return false; // Already shown in active rides
      }
      return true;
    }).toList();

    if (filtered.isEmpty) return SizedBox.shrink();

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
        ...filtered.map(
          (trip) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildUpcomingRideCard(context, trip),
          ),
        ),
        SpaceHelper(h: 24.h),
      ],
    );
  }

  Widget _buildActiveContractsSection(List<dynamic> contracts) {
    final bottomController = Get.find<BottomTabController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Active Contracts',
          'View and manage your transport contracts',
          onViewAll: () {
            // Navigate to contracts tab (4th tab, index 3)
            bottomController.setTabIndex(3);
            // Navigate to tab screen if not already there
            Get.until((route) => route.settings.name == '/tab_screen');
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
    // get parent child from parent id
    final parentID = BaseHelper.currentUser.value.roleData?.id;
    final firstChild = trip.assignedChildren?.firstWhere(
      (child) => child.child?.parentId == parentID,
    );
    if (firstChild == null) return SizedBox.shrink();
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
        firstChild?.pickupStatusUpdatedAt ?? firstChild?.pickupTime ?? 'N/A';
    final dropoffTime =
        firstChild?.dropOffStatusUpdatedAt ?? trip?.dropOffTime ?? 'N/A';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColorGreen.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Info and Status
          // Row(
          //   children: [
          //     CircleAvatar(
          //       radius: 20.r,
          //       backgroundColor: AppColor.darkPrimary,
          //       child: Text(
          //         _getInitials(childName),
          //         style: poppinFonts(
          //           color: AppColor.white,
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     SpaceHelper(w: 12.w),
          //     Expanded(
          //       child: Text(
          //         childName,
          //         style: poppinFonts(
          //           color: AppColor.black,
          //           fontSize: base,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          //       decoration: BoxDecoration(
          //         color: getStatusColor(trip.status),
          //         borderRadius: BorderRadius.circular(16.r),
          //       ),
          //       child: Text(
          //         trip.status?.capitalizeFirst ?? 'Active',
          //         style: poppinFonts(
          //           color: AppColor.white,
          //           fontSize: sm,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: getStatusColor(trip.status),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  trip.status?.capitalizeFirst ?? 'Scheduled',
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
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Color(0xffECF4E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.borderGreen, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColor.cardShadowColorGreen.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
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
                          _formatTime(
                            pickupTime.toString(),
                            referenceDate: trip.serviceDate,
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
                            referenceDate: trip.serviceDate,
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
                SpaceHelper(h: 12.h),

                // Live Tracking Button - disabled if ride is not scheduled for today
                CustomButton(
                  width: double.infinity,
                  title: 'Live Tracking',
                  onPressed: trip.isScheduledForToday
                      ? () {
                          Get.toNamed(
                            LiveTrackingScreen.route,
                            arguments: trip,
                          );
                        }
                      : null,
                  gradient: trip.isScheduledForToday
                      ? null
                      : const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
              ],
            ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColorGreen.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: getStatusColor(trip.status),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  trip.status?.capitalizeFirst ?? 'Scheduled',
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
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Color(0xffECF4E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.borderGreen, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColor.cardShadowColorGreen.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
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
                          _formatTime(
                            pickupTime.toString(),
                            referenceDate: trip.serviceDate,
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
                            referenceDate: trip.serviceDate,
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
                SpaceHelper(h: 12.h),

                // Manage Ride Button
                // Container(
                //   height: 50.h,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: AppColor.white,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(color: AppColor.secondary, width: 1),
                //   ),
                //   child: TextButton(
                // onPressed: () {
                //   _showManageRideModal(context, trip);
                // },
                //     child: Text(
                //       'Manage Ride',
                //       style: poppinFonts(
                //         color: AppColor.primary,
                //         fontSize: md,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                CustomOutlineButton(
                  title: "Manage Ride",
                  onPressed: () {
                    _showManageRideModal(context, trip);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractCard(ContractModel contract) {
    final bottomController = Get.find<BottomTabController>();
    // Handle both ContractModel and Map
    String? contractId;
    String? contractDuration;
    String? monthlyFee;
    String? status;

    contractId = contract.contractId ?? contract.id;
    contractDuration = contract.contractDuration;
    monthlyFee = contract.monthlyPayment?.toString();
    status = contract.status;

    return GestureDetector(
      onTap: () {
        // Navigate to contracts tab (4th tab, index 3)
        bottomController.setTabIndex(3);
        // Navigate to tab screen if not already there
        Get.until((route) => route.settings.name == '/tab_screen');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColor.cardBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderGreen),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadowColorGreen.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${contract.transportOwner?.businessName}',
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
                        "${contractDuration} Days",
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
                        'R ${monthlyFee ?? '0'}',
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
      ),
    );
  }
}
