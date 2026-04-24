import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/controllers/route_controller.dart';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/models/route_model.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';

class RequestBookingScreen extends StatefulWidget {
  static const route = '/request-booking';
  const RequestBookingScreen({super.key});

  @override
  State<RequestBookingScreen> createState() => _RequestBookingScreenState();
}

class _RequestBookingScreenState extends State<RequestBookingScreen> {
  final ChildController childController = Get.put(ChildController());
  final RouteController routeController = Get.put(RouteController());
  ChildModel? selectedChild;
  final TextEditingController preferredPickupTimeController =
      TextEditingController();
  final TextEditingController schoolKnockOffTimeController =
      TextEditingController();
  final TextEditingController contractStartController = TextEditingController();
  final TextEditingController contractEndController = TextEditingController();

  RouteModel? routeModel;

  // Store selected DateTime objects for API formatting
  DateTime? selectedPickupTime;
  DateTime? selectedKnockOffTime;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    // Get route model from arguments if provided
    final arguments = Get.arguments;
    if (arguments is RouteModel) {
      routeModel = arguments;
    } else if (arguments is Map && arguments['route'] is RouteModel) {
      routeModel = arguments['route'] as RouteModel;
    }
  }

  @override
  void dispose() {
    preferredPickupTimeController.dispose();
    schoolKnockOffTimeController.dispose();
    contractStartController.dispose();
    contractEndController.dispose();
    super.dispose();
  }

  String _getTransportOwnerName() {
    if (routeModel?.transportOwner?.businessName != null &&
        routeModel!.transportOwner!.businessName!.isNotEmpty) {
      return routeModel!.transportOwner!.businessName!;
    }
    if (routeModel?.transportOwner?.firstName != null ||
        routeModel?.transportOwner?.surName != null) {
      final firstName = routeModel?.transportOwner?.firstName ?? '';
      final surName = routeModel?.transportOwner?.surName ?? '';
      return '$firstName $surName'.trim();
    }
    return 'SchoolFleet Africa'; // Default as shown in image
  }

  String _getInitial() {
    final name = _getTransportOwnerName();
    if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return 'S';
  }

  String _getRouteDisplay() {
    if (routeModel != null) {
      final suburb = routeModel?.suburbName ?? '';
      final dropOff = routeModel?.dropOffPointName ?? '';
      if (suburb.isNotEmpty && dropOff.isNotEmpty) {
        return '$suburb → $dropOff';
      }
    }
    return ''; // Default as shown in image
  }

  String _getVehicleDisplay() {
    if (routeModel?.vehicle != null) {
      final make = routeModel?.vehicle?.make ?? '';
      final model = routeModel?.vehicle?.model ?? '';
      if (make.isNotEmpty || model.isNotEmpty) {
        return '$make $model'.trim();
      }
    }
    return 'Mercedes Benz S Class'; // Default as shown in image
  }

  List<ChildModel> _getChildrenList() {
    if (childController.childrenState.value is DataState<List<ChildModel>>) {
      final state =
          childController.childrenState.value as DataState<List<ChildModel>>;
      return state.data;
    }
    return [];
  }

  /// Calculate contract duration in days
  int? _calculateContractDuration() {
    if (selectedStartDate != null && selectedEndDate != null) {
      return selectedEndDate!.difference(selectedStartDate!).inDays;
    }
    return null;
  }

  /// Format time to HH:mm format for API
  String? _formatTimeForApi(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Handle request booking API call
  Future<void> _handleRequestBooking() async {
    // Validation
    if (selectedChild == null) {
      customToaster('Please select a child', color: Colors.red);
      return;
    }

    if (selectedPickupTime == null) {
      customToaster('Please select preferred pickup time', color: Colors.red);
      return;
    }

    if (selectedKnockOffTime == null) {
      customToaster('Please select school knock off time', color: Colors.red);
      return;
    }

    if (selectedStartDate == null) {
      customToaster('Please select contract start date', color: Colors.red);
      return;
    }

    if (selectedEndDate == null) {
      customToaster('Please select contract end date', color: Colors.red);
      return;
    }

    if (routeModel == null) {
      customToaster('Route information not found', color: Colors.red);
      return;
    }

    // Get parent ID
    final parentId = BaseHelper.currentUser.value.roleData?.id;
    if (parentId == null) {
      customToaster('Parent ID not found', color: Colors.red);
      return;
    }

    // Get transport owner ID
    final transportOwnerId = routeModel!.transportOwnerId;
    if (transportOwnerId == null) {
      customToaster('Transport owner ID not found', color: Colors.red);
      return;
    }

    // Get route ID
    final routeId = routeModel!.id;
    if (routeId == null) {
      customToaster('Route ID not found', color: Colors.red);
      return;
    }

    // Calculate contract duration
    final contractDuration = _calculateContractDuration();
    if (contractDuration == null || contractDuration < 0) {
      customToaster('Invalid contract dates', color: Colors.red);
      return;
    }

    try {
      await routeController.requestBooking(
        parentId: parentId,
        transportOwnerId: transportOwnerId,
        routeId: routeId,
        childId: selectedChild!.id!,
        startDate: selectedStartDate!,
        endDate: selectedEndDate!,
        pickUpTime: _formatTimeForApi(selectedPickupTime)!,
        knockOffTime: _formatTimeForApi(selectedKnockOffTime)!,
        contractDuration: contractDuration,
      );
      // Navigate to success screen instead of going back
      Get.offNamed('/booking-success');
    } catch (e) {
      // Error is already handled in controller
    }
  }

  @override
  Widget build(BuildContext context) {
    final childrenList = _getChildrenList();

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
          'Request Booking',
          style: poppinFonts(
            fontSize: lg,
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
              // Green Information Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.lightSecondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.borderGreen),
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
                    // Service Provider Info Row
                    Row(
                      children: [
                        // Avatar Circle
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColor.darkPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getInitial(),
                              style: poppinFonts(
                                color: AppColor.white,
                                fontSize: lg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SpaceHelper(w: 12.w),
                        Expanded(
                          child: Text(
                            _getTransportOwnerName(),
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: base,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Verified Badge
                        if (routeModel?.transportOwner?.isVerified ?? false)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/svg/verified.svg',
                                  width: 14.w,
                                  height: 14.w,
                                  colorFilter: ColorFilter.mode(
                                    AppColor.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SpaceHelper(w: 4.w),
                                Text(
                                  'Verified',
                                  style: poppinFonts(
                                    color: AppColor.white,
                                    fontSize: xs,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SpaceHelper(h: 12.w),
                    // Route Details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svg/pickup.svg',
                          width: 20.w,
                          height: 20.w,
                          colorFilter: ColorFilter.mode(
                            AppColor.textLightBlackColor4A4A4A,
                            BlendMode.srcIn,
                          ),
                        ),
                        SpaceHelper(w: 8.w),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Route: ',
                                style: poppinFonts(
                                  color: AppColor.textLightBlackColor4A4A4A,
                                  fontSize: sm,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  _getRouteDisplay(),

                                  style: poppinFonts(
                                    color: AppColor.black,
                                    fontSize: sm,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SpaceHelper(h: 8.h),
                    // Vehicle Details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svg/vahicle.svg',
                          width: 20.w,
                          height: 20.w,
                          colorFilter: ColorFilter.mode(
                            AppColor.textLightBlackColor4A4A4A,
                            BlendMode.srcIn,
                          ),
                        ),
                        SpaceHelper(w: 8.w),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vehicle: ',
                                style: poppinFonts(
                                  color: AppColor.black,
                                  fontSize: sm,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _getVehicleDisplay(),
                                  style: poppinFonts(
                                    color: AppColor.black,
                                    fontSize: sm,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SpaceHelper(h: 16.w),
              // Select Child Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      'Select Child',
                      style: poppinFonts(
                        color: AppColor.black,
                        fontSize: md,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  DropdownButtonFormField2<ChildModel>(
                    isExpanded: true,
                    value: selectedChild,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColor.appBlackColor,
                        size: 20.sp,
                      ),
                      fillColor: AppColor.appColorWhite,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 10.w,
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
                      'Select Child',
                      style: poppinFonts(
                        color: AppColor.gray,
                        fontSize: sm,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    items: childrenList
                        .map(
                          (child) => DropdownMenuItem<ChildModel>(
                            value: child,
                            child: Text(
                              child.name ?? 'Unknown',
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
                        selectedChild = value;
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
              SpaceHelper(h: 12.w),
              // Preferred Pickup Time
              CustomTextField(
                label: "Preferred Pickup Time",
                hintText: "Add Time",
                controller: preferredPickupTimeController,
                isReadOnly: true,
                hasSuffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    'assets/images/svg/clock.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primary,
                            onPrimary: AppColor.white,
                            onSurface: AppColor.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    final now = DateTime.now();
                    selectedPickupTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                    preferredPickupTimeController.text = DateFormat(
                      'h:mm a',
                    ).format(selectedPickupTime!);
                    setState(() {});
                  }
                },
              ),
              SpaceHelper(h: 12.w),
              // Standard School Knock Off Time
              CustomTextField(
                label: "Standard School Knock Off Time",
                hintText: "Add Time",
                controller: schoolKnockOffTimeController,
                isReadOnly: true,
                hasSuffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    'assets/images/svg/clock.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primary,
                            onPrimary: AppColor.white,
                            onSurface: AppColor.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    final now = DateTime.now();
                    selectedKnockOffTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                    schoolKnockOffTimeController.text = DateFormat(
                      'h:mm a',
                    ).format(selectedKnockOffTime!);
                    setState(() {});
                  }
                },
              ),
              SpaceHelper(h: 12.w),
              // Contract Starting from
              CustomTextField(
                label: "Contract Starting from",
                hintText: "Add Date",
                controller: contractStartController,
                isReadOnly: true,
                hasSuffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    'assets/images/svg/calender.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primary,
                            onPrimary: AppColor.white,
                            onSurface: AppColor.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedStartDate = picked;
                    contractStartController.text = DateFormat(
                      'MMM dd, yyyy',
                    ).format(picked);
                    setState(() {});
                  }
                },
              ),
              SpaceHelper(h: 12.w),
              // Contract End On
              CustomTextField(
                label: "Contract End On",
                hintText: "Add Date",
                controller: contractEndController,
                isReadOnly: true,
                hasSuffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    'assets/images/svg/calender.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedStartDate ?? DateTime.now(),
                    firstDate: selectedStartDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primary,
                            onPrimary: AppColor.white,
                            onSurface: AppColor.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedEndDate = picked;
                    contractEndController.text = DateFormat(
                      'MMM dd, yyyy',
                    ).format(picked);
                    setState(() {});
                  }
                },
              ),
              SpaceHelper(h: 20.w),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 36.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.borderGreen),
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColor.white,
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: poppinFonts(
                              fontWeight: FontWeight.w500,
                              fontSize: base,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        height: 36.h,
                        onPressed: routeController.isLoading.value
                            ? null
                            : _handleRequestBooking,
                        title: "Request Sent",
                        isLoading: routeController.isLoading.value,
                      ),
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}
