import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/route_controller.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/location_field.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/location_data_model.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';

class FindTransportFilterScreen extends StatefulWidget {
  static const route = '/find-transport-filter-screen';
  const FindTransportFilterScreen({super.key});

  @override
  State<FindTransportFilterScreen> createState() =>
      _FindTransportFilterScreenState();
}

class _FindTransportFilterScreenState extends State<FindTransportFilterScreen> {
  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController dropOffLocationController =
      TextEditingController();
  LocationData? pickupLocationData;
  LocationData? dropOffLocationData;
  String? selectedVehicleType;
  String? selectedCapacity;

  // Vehicle Type Options
  final List<String> vehicleTypeOptions = [
    "Any",
    'Bus',
    'Van',
    'Sedan',
    'SUV',
    'Minibus',
    'School Bus',
  ];

  // Capacity Options
  final List<String> capacityOptions = [
    "Any",
    '4',
    '8',
    '12',
    '16',
    '20',
    '25',
    '30',
    '40',
    '50+',
  ];

  @override
  void dispose() {
    pickupLocationController.dispose();
    dropOffLocationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Restore previous filter values if provided
    final previousFilters = Get.arguments as Map<String, dynamic>?;
    if (previousFilters != null) {
      pickupLocationController.text = previousFilters['pickupLocation'] ?? '';
      dropOffLocationController.text = previousFilters['dropOffLocation'] ?? '';
      selectedVehicleType = previousFilters['vehicleType'];
      selectedCapacity = previousFilters['capacity'];

      // Restore location data if available
      if (previousFilters['pickupLocationData'] != null) {
        try {
          pickupLocationData = LocationData.fromJson(
            previousFilters['pickupLocationData'],
          );
        } catch (e) {
          // Ignore parsing errors
        }
      }
      if (previousFilters['dropOffLocationData'] != null) {
        try {
          dropOffLocationData = LocationData.fromJson(
            previousFilters['dropOffLocationData'],
          );
        } catch (e) {
          // Ignore parsing errors
        }
      }
    }
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
            Get.back();
          },
        ),
        title: Text(
          'Filters',
          style: poppinFonts(
            fontSize: xl,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search with Filters',
                style: poppinFonts(
                  fontSize: lg,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.h),
              LocationField(
                label: "Pickup Location",
                hintText: 'Enter Pickup Location',
                controller: pickupLocationController,
                onLocationSelected: (locationData) {
                  setState(() {
                    pickupLocationData = locationData;
                  });
                },
              ),

              LocationField(
                label: "School/Drop-off",
                hintText: 'Enter School/Drop-off',
                controller: dropOffLocationController,
                onLocationSelected: (locationData) {
                  setState(() {
                    dropOffLocationData = locationData;
                  });
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Text(
                            'Vehicle Type',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: md,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          value: selectedVehicleType,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColor.appBlackColor,
                              size: 20.sp,
                            ),
                            fillColor: AppColor.appColorWhite,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                          ),
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: md,
                              color: AppColor.gray,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          items: vehicleTypeOptions
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: poppinFonts(
                                      color: AppColor.appBlackColor,
                                      fontSize: sm,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedVehicleType = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 18.h,
                            padding: EdgeInsets.only(right: 8.w),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: const Color(0xffF7F8F8),
                              size: 24.sp,
                            ),
                            iconSize: 24.sp,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.only(left: 6.w),
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F8F8),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Text(
                            'Capacity',
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: md,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          value: selectedCapacity,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColor.appBlackColor,
                              size: 20.sp,
                            ),
                            fillColor: AppColor.appColorWhite,
                            filled: true,

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColor.textFieldBorderColor,
                                width: 1,
                              ),
                            ),
                          ),
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: md,
                              color: AppColor.gray,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          items: capacityOptions
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    '$item seats',
                                    style: poppinFonts(
                                      color: AppColor.appBlackColor,
                                      fontSize: sm,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCapacity = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 18.h,
                            padding: EdgeInsets.only(right: 8.w),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: const Color(0xffF7F8F8),
                              size: 24.sp,
                            ),
                            iconSize: 24.sp,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            padding: EdgeInsets.only(left: 6.w),
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F8F8),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 24.h),
              Obx(() {
                final routeController = Get.find<RouteController>();
                return CustomButton(
                  onPressed: routeController.isLoading.value
                      ? null
                      : () async {
                          // Build query and fetch routes here
                          final selected = {
                            'pickupLocation':
                                pickupLocationData?.description ??
                                pickupLocationController.text.trim(),
                            'dropOffLocation':
                                dropOffLocationData?.description ??
                                dropOffLocationController.text.trim(),
                            'vehicleType': selectedVehicleType,
                            'capacity': selectedCapacity,
                            'pickupLocationData': pickupLocationData?.toJson(),
                            'dropOffLocationData': dropOffLocationData
                                ?.toJson(),
                          };

                          final query = _buildQueryFromFilters(selected);
                          if (query.isEmpty) {
                            await routeController.getRoutes();
                          } else {
                            await routeController.getRoutes(query: query);
                          }

                          // Return filter data and go back
                          Get.back(result: selected);
                        },
                  title: "Find Transport",
                  isLoading: routeController.isLoading.value,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

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

    // Use description from location data if available, otherwise use text input
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
}
