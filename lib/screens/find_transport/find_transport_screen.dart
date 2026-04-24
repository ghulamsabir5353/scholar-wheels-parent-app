import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/controllers/route_controller.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/route_model.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/find_transport/find_transport_filter_screen.dart';
import 'package:scholarwheels/screens/find_transport/widgets/transport_card.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/models/popular_route_model.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';

class FindTransportScreen extends StatefulWidget {
  static const route = '/find-transport';
  const FindTransportScreen({super.key});

  @override
  State<FindTransportScreen> createState() => _FindTransportScreenState();
}

class _FindTransportScreenState extends State<FindTransportScreen> {
  bool showMainSection = true;
  late RouteController routeController;

  // Filter state
  Map<String, dynamic>? activeFilters;
  List<RouteModel> filteredRoutes = [];

  @override
  void initState() {
    super.initState();
    // Get or create RouteController
    routeController = Get.put(RouteController());
  }

  @override
  Widget build(BuildContext context) {
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
            if (showMainSection) {
              Get.find<BottomTabController>().setTabIndex(0);
            } else {
              setState(() {
                showMainSection = true;
              });
            }
          },
        ),
        title: Text(
          'Find Transport',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              // Pass current filters to filter screen to restore them
              final result = await Get.toNamed(
                FindTransportFilterScreen.route,
                arguments: activeFilters,
              );
              if (result != null && result is Map<String, dynamic>) {
                // Data already fetched in filter screen
                setState(() {
                  activeFilters = result;
                  showMainSection = false;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset('assets/images/svg/filter-button.svg'),
            ),
          ),
        ],
      ),
      body: showMainSection
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                // add column in card
                child: Card(
                  elevation: 2,
                  shadowColor: AppColor.cardShadowColor,
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Text(
                          'Search Transport',
                          style: poppinFonts(
                            fontSize: base,
                            color: AppColor.headingFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SpaceHelper(h: 2.h),
                        Text(
                          'Find available rides near you',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                        SpaceHelper(h: 20.h),
                        // Popular Routes Section
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColor.lightSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Popular Routes Title with icon
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/svg/location.svg',
                                    width: 16.w,
                                    height: 16.w,
                                  ),
                                  SpaceHelper(w: 6.w),
                                  Text(
                                    'Popular Routes',
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SpaceHelper(h: 12.h),
                              // Popular routes content
                              Obx(() {
                                final popState =
                                    routeController.popularRoutesState.value;
                                if (popState is LoadingState) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      child: const CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (popState is ExceptionState) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Text(
                                      'Failed to load popular routes',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                                if (popState is EmptyState) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Text(
                                      'No popular routes yet',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                  );
                                }
                                if (popState
                                    is DataState<List<PopularRouteModel>>) {
                                  final list = popState.data;
                                  return Column(
                                    children: [
                                      ...list.asMap().entries.map((entry) {
                                        final idx = entry.key;
                                        final item = entry.value;
                                        return InkWell(
                                          onTap: () async {
                                            // Show results view and fetch routes for this transport owner
                                            setState(() {
                                              showMainSection = false;
                                              activeFilters =
                                                  null; // clear chips
                                            });
                                            await routeController.getRoutes(
                                              query: {
                                                'transportOwnerId':
                                                    item.transportOwnerId,
                                              },
                                            );
                                          },
                                          child: RouteEntryWidget(
                                            pickupAddress:
                                                item.suburbDescription ?? '',
                                            schoolName:
                                                item.dropOffPointDescription ??
                                                '',
                                            isLast: idx == list.length - 1,
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            ],
                          ),
                        ),
                        SpaceHelper(h: 24.h),
                        // Find Your Route Button
                        Obx(
                          () => CustomButton(
                            onPressed: routeController.isLoading.value
                                ? null
                                : () async {
                                    // Navigate to filter screen first
                                    final result = await Get.toNamed(
                                      FindTransportFilterScreen.route,
                                      arguments: activeFilters,
                                    );
                                    if (result != null &&
                                        result is Map<String, dynamic>) {
                                      // Data already fetched in filter screen
                                      setState(() {
                                        activeFilters = result;
                                        showMainSection = false;
                                      });
                                    }
                                  },
                            title: "Find Your Route",
                            width: double.infinity,

                            isLoading: routeController.isLoading.value,
                            style: poppinFonts(
                              fontSize: base,
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Obx(() {
              final state = routeController.routesState.value;

              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is EmptyState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (state as EmptyState).message,
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      SpaceHelper(h: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          // Clear all filters and fetch all routes
                          setState(() {
                            activeFilters = null;
                            filteredRoutes = [];
                          });
                          routeController.getRoutes();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ExceptionState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load routes',
                        style: poppinFonts(fontSize: base, color: Colors.red),
                      ),
                      SpaceHelper(h: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          // Clear all filters and fetch all routes
                          setState(() {
                            activeFilters = null;
                            filteredRoutes = [];
                          });
                          routeController.getRoutes();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DataState<List<RouteModel>>) {
                final routes = state.data;
                final displayRoutes = routes;

                return Column(
                  children: [
                    // Filter Chips Section with Search Icon
                    Container(
                      color: AppColor.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.appColorWhite,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            // Search Icon
                            Padding(
                              padding: EdgeInsets.all(1.w),
                              child: SvgPicture.asset(
                                'assets/images/svg/search.svg',
                                width: 20.w,
                                height: 20.w,
                                colorFilter: ColorFilter.mode(
                                  AppColor.textLightBlackColor4A4A4A,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SpaceHelper(w: 12.w),
                            // Filter chips or search prompt
                            if (activeFilters != null)
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: _buildFilterChips(),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Get.toNamed(
                                        FindTransportFilterScreen.route,
                                        arguments: activeFilters,
                                      );
                                      if (result != null &&
                                          result is Map<String, dynamic>) {
                                        setState(() {
                                          activeFilters = result;
                                          showMainSection = false;
                                        });
                                        // Data is fetched in filter screen
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0.h,
                                      ),
                                      child: Text(
                                        'Search routes',
                                        style: poppinFonts(
                                          fontSize: base,
                                          color: AppColor.bgGray979797,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Results count
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${displayRoutes.length} results found',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    // Routes List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          child: Column(
                            children: [
                              ...displayRoutes.map((route) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: TransportCard(route: route),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            }),
    );
  }

  /// Build API query map from filter selections
  Map<String, dynamic> _buildQueryFromFilters(Map<String, dynamic> selected) {
    final Map<String, dynamic> query = {};

    final vehicleType = (selected['vehicleType'] ?? '').toString();
    if (vehicleType.isNotEmpty && vehicleType != 'Any') {
      query['vehicleType'] = vehicleType.toLowerCase();
    }

    final capacity = (selected['capacity'] ?? '').toString();
    if (capacity.isNotEmpty && capacity != 'Any') {
      query['capacity'] = capacity.toLowerCase();
    }

    final pickup = (selected['pickupLocation'] ?? '').toString();
    if (pickup.isNotEmpty) {
      query['suburb'] = pickup.toLowerCase();
    }

    final dropOff = (selected['dropOffLocation'] ?? '').toString();
    if (dropOff.isNotEmpty) {
      query['dropOffPoint'] = dropOff.toLowerCase();
    }

    return query;
  }

  /// Build filter chips for display in search bar
  List<Widget> _buildFilterChips() {
    final List<Widget> chips = [];

    if (activeFilters == null) return chips;

    // Pickup Location chip
    if (activeFilters!['pickupLocation'] != null &&
        activeFilters!['pickupLocation'].toString().isNotEmpty) {
      chips.add(
        _buildFilterChip(activeFilters!['pickupLocation'], 'pickupLocation'),
      );
    }

    // Drop-off Location chip
    if (activeFilters!['dropOffLocation'] != null &&
        activeFilters!['dropOffLocation'].toString().isNotEmpty) {
      chips.add(
        _buildFilterChip(activeFilters!['dropOffLocation'], 'dropOffLocation'),
      );
    }

    // Vehicle Type chip
    if (activeFilters!['vehicleType'] != null &&
        activeFilters!['vehicleType'] != 'Any' &&
        activeFilters!['vehicleType'].toString().isNotEmpty) {
      chips.add(_buildFilterChip(activeFilters!['vehicleType'], 'vehicleType'));
    }

    // Capacity chip
    if (activeFilters!['capacity'] != null &&
        activeFilters!['capacity'] != 'Any' &&
        activeFilters!['capacity'].toString().isNotEmpty) {
      chips.add(
        _buildFilterChip('${activeFilters!['capacity']} seats', 'capacity'),
      );
    }

    return chips;
  }

  /// Build individual filter chip widget with close button
  Widget _buildFilterChip(String label, String filterKey) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: AppColor.lightSecondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: poppinFonts(
              fontSize: xs,
              color: AppColor.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          SpaceHelper(w: 4.w),
          InkWell(
            onTap: () {
              // Remove this filter
              setState(() {
                if (filterKey == 'capacity') {
                  activeFilters!['capacity'] = null;
                } else {
                  activeFilters![filterKey] = null;
                }
                // Remove null values
                activeFilters!.removeWhere(
                  (key, value) =>
                      value == null || value == '' || value == 'Any',
                );
                // Check if all filters are empty, then clear activeFilters
                if (activeFilters!.isEmpty ||
                    activeFilters!.values.every(
                      (v) => v == null || v == '' || v == 'Any',
                    )) {
                  activeFilters = null;
                  filteredRoutes = [];
                  // All filters cleared: fetch full routes list again
                  routeController.getRoutes();
                } else {
                  // Re-fetch with updated filters
                  final query = _buildQueryFromFilters(activeFilters!);
                  routeController.getRoutes(query: query);
                }
              });
            },
            child: Icon(Icons.close, size: 16.sp, color: AppColor.primary),
          ),
        ],
      ),
    );
  }
}
