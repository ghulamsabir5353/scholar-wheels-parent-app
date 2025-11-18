import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/controllers/main.controller.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:intl/intl.dart';

enum ManageRideState {
  initial,
  changePickupTime,
  childNotGoing,
  changeDropoffTime,
  contactOwner,
}

class ManageRideModal extends StatefulWidget {
  final NextTrip trip;

  const ManageRideModal({super.key, required this.trip});

  @override
  State<ManageRideModal> createState() => _ManageRideModalState();
}

class _ManageRideModalState extends State<ManageRideModal> {
  final MainController mainController = Get.find<MainController>();
  final BottomTabController bottomTabController =
      Get.find<BottomTabController>();
  ManageRideState currentState = ManageRideState.initial;
  ManageRideState selectedAction =
      ManageRideState.changePickupTime; // Default to first option
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController dropoffTimeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  DateTime? selectedPickupTime;
  DateTime? selectedDropoffTime;
  bool _isLoading = false;

  @override
  void dispose() {
    pickupTimeController.dispose();
    dropoffTimeController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isPickup) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      setState(() {
        if (isPickup) {
          selectedPickupTime = selectedDateTime;
          pickupTimeController.text = DateFormat(
            'h:mm a',
          ).format(selectedDateTime);
        } else {
          selectedDropoffTime = selectedDateTime;
          dropoffTimeController.text = DateFormat(
            'h:mm a',
          ).format(selectedDateTime);
        }
      });
    }
  }

  void _navigateToChat() {
    // Close modal first
    Get.back();

    // Wait a bit for modal to close, then navigate
    Future.delayed(Duration(milliseconds: 300), () {
      // Set chat tab index first (before navigation if needed)
      bottomTabController.setTabIndex(4);

      // If we're on a different route (like ScheduleRideScreen), navigate back to TabScreen
      if (Get.currentRoute != '/tab_screen') {
        // Navigate back to TabScreen - chat tab is already set, so it will show chat directly
        Get.until((route) => route.settings.name == '/tab_screen');
      }
      // If already on TabScreen, the tab is already switched above
    });
  }

  void _handleActionSelection(ManageRideState action) {
    setState(() {
      selectedAction = action;
      // If it's contact owner, navigate immediately
      if (action == ManageRideState.contactOwner) {
        _navigateToChat();
        return;
      }
      // For other actions, just update selection (don't switch screen yet)
    });
  }

  Future<void> _handleConfirm() async {
    // If on initial screen, switch to the selected action's detail screen
    if (currentState == ManageRideState.initial) {
      if (selectedAction == ManageRideState.contactOwner) {
        _navigateToChat();
        return;
      }
      setState(() {
        currentState = selectedAction;
      });
      return;
    }

    // Get trip ID and child ID
    final tripId = widget.trip.id ?? widget.trip.tripId;
    if (tripId == null) {
      Get.snackbar('Error', 'Trip ID not found');
      return;
    }

    // Get first child ID from assigned children
    final firstChild = widget.trip.assignedChildren?.isNotEmpty == true
        ? widget.trip.assignedChildren!.first
        : null;
    final childId = firstChild?.childId;
    if (childId == null || childId.isEmpty) {
      Get.snackbar('Error', 'Child ID not found');
      return;
    }

    // Build API payload based on action
    String? status; // Only set when child not going (cancelled)
    String? pickupTime;
    String? dropOffTime;
    String? reason = reasonController.text.isNotEmpty
        ? reasonController.text
        : null;

    switch (currentState) {
      case ManageRideState.changePickupTime:
        if (selectedPickupTime == null) {
          Get.snackbar('Error', 'Please select a pickup time');
          return;
        }
        pickupTime = DateFormat('HH:mm').format(selectedPickupTime!);
        break;
      case ManageRideState.childNotGoing:
        // Only set status when child not going - set to cancelled
        status = 'cancelled';
        break;
      case ManageRideState.changeDropoffTime:
        if (selectedDropoffTime == null) {
          Get.snackbar('Error', 'Please select a dropoff time');
          return;
        }
        dropOffTime = DateFormat('HH:mm').format(selectedDropoffTime!);
        break;
      case ManageRideState.contactOwner:
        _navigateToChat();
        return;
      case ManageRideState.initial:
        return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Call API - status is only passed when child not going (cancelled)
      final success = await mainController.manageRide(
        tripId: tripId,
        childId: childId,
        status:
            status, // Only set when child not going (cancelled), null otherwise
        pickupTime: pickupTime,
        dropOffTime: dropOffTime,
        reason: reason,
      );

      if (success) {
        // Close modal
        Get.back();

        // Refresh data based on current screen
        _refreshData();
      }
    } finally {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _refreshData() {
    // Check if we're on schedule screen
    final isOnScheduleScreen = Get.currentRoute == '/schedule-ride';

    // Always refresh dashboard
    mainController.getDashboardData();

    // If on schedule screen, also refresh trips with current filter and status
    if (isOnScheduleScreen) {
      // Get status from arguments (passed when navigating to schedule screen)
      final status = Get.arguments as String? ?? 'scheduled';
      // Refresh trips - the schedule screen will show updated data
      // We use 'daily' as default, but the screen will refresh with its own filter when it rebuilds
      Future.delayed(Duration(milliseconds: 500), () {
        mainController.getTrips(
          filterType:
              'daily', // Default, schedule screen will refresh with its own filter
          status: status,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpaceHelper(h: 32.h),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Ride',
                  style: poppinFonts(
                    color: AppColor.primary,
                    fontSize: xl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.primary, width: 2),
                    ),
                    child: Icon(Icons.close, color: AppColor.primary, size: 16),
                  ),
                ),
              ],
            ),
          ),

          // Content based on state
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: _buildContent(),
            ),
          ),

          // Confirm Button - show on initial screen and on detail screens
          if (currentState == ManageRideState.initial ||
              (currentState != ManageRideState.initial &&
                  currentState != ManageRideState.contactOwner))
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomButton(
                title: 'Confirm',
                onPressed: _handleConfirm,

                isLoading: _isLoading,
              ),
            ),
          SpaceHelper(h: 32.h),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (currentState) {
      case ManageRideState.initial:
        return _buildInitialScreen();
      case ManageRideState.changePickupTime:
        return _buildChangePickupTimeScreen();
      case ManageRideState.childNotGoing:
        return _buildChildNotGoingScreen();
      case ManageRideState.changeDropoffTime:
        return _buildChangeDropoffTimeScreen();
      case ManageRideState.contactOwner:
        return SizedBox.shrink();
    }
  }

  Widget _buildInitialScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need to make changes to today\'s ride?',
          style: poppinFonts(color: AppColor.black, fontSize: sm),
        ),
        SpaceHelper(h: 4.h),
        Text(
          'You can update times or let the driver know your child isn\'t going today.',
          style: poppinFonts(
            color: AppColor.textLightBlackColor4A4A4A,
            fontSize: sm,
          ),
        ),
        SpaceHelper(h: 24.h),
        // Change pickup time button - Light green filled (default selected)
        InkWell(
          onTap: () => _handleActionSelection(ManageRideState.changePickupTime),
          child: Container(
            height: 36.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedAction == ManageRideState.changePickupTime
                  ? AppColor.cardBgColor
                  : AppColor.white,
              borderRadius: BorderRadius.circular(8),
              border: selectedAction == ManageRideState.changePickupTime
                  ? null
                  : Border.all(color: Color(0xffE7E7E7), width: 1),
            ),
            child: Center(
              child: Text(
                'Change pickup time',
                style: poppinFonts(
                  color: AppColor.black,
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SpaceHelper(h: 12.h),
        // Child not going today button - White with border
        InkWell(
          onTap: () => _handleActionSelection(ManageRideState.childNotGoing),
          child: Container(
            height: 36.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedAction == ManageRideState.childNotGoing
                  ? AppColor.cardBgColor
                  : AppColor.white,
              borderRadius: BorderRadius.circular(8),
              border: selectedAction == ManageRideState.childNotGoing
                  ? null
                  : Border.all(color: Color(0xffE7E7E7), width: 1),
            ),
            child: Center(
              child: Text(
                'Child not going today',
                style: poppinFonts(
                  color: AppColor.black,
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SpaceHelper(h: 12.h),
        // Change drop-off time button - White with border
        InkWell(
          onTap: () =>
              _handleActionSelection(ManageRideState.changeDropoffTime),
          child: Container(
            height: 36.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedAction == ManageRideState.changeDropoffTime
                  ? AppColor.cardBgColor
                  : AppColor.white,
              borderRadius: BorderRadius.circular(8),
              border: selectedAction == ManageRideState.changeDropoffTime
                  ? null
                  : Border.all(color: Color(0xffE7E7E7), width: 1),
            ),
            child: Center(
              child: Text(
                'Change drop-off time',
                style: poppinFonts(
                  color: AppColor.black,
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SpaceHelper(h: 12.h),
        // Contact Transport Owner or Driver button - White with border
        InkWell(
          onTap: () => _handleActionSelection(ManageRideState.contactOwner),
          child: Container(
            height: 36.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedAction == ManageRideState.contactOwner
                  ? AppColor.cardBgColor
                  : AppColor.white,
              borderRadius: BorderRadius.circular(8),
              border: selectedAction == ManageRideState.contactOwner
                  ? null
                  : Border.all(color: Color(0xffE7E7E7), width: 1),
            ),
            child: Center(
              child: Text(
                'Contact Transport Owner or Driver',
                style: poppinFonts(
                  color: AppColor.black,
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePickupTimeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a time for the change.',
          style: poppinFonts(
            color: AppColor.textLightBlackColor4A4A4A,
            fontSize: sm,
          ),
        ),
        SpaceHelper(h: 24.h),
        // Preferred Pickup Time
        CustomTextField(
          controller: pickupTimeController,
          label: 'Preferred Pickup Time',
          hintText: 'Add Time',
          isReadOnly: true,
          onTap: () => _selectTime(context, true),
          hasSuffixIcon: Icon(
            Icons.access_time,
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
        SpaceHelper(h: 16.h),
        // Reason (Optional)
        CustomTextField(
          controller: reasonController,
          label: 'Reason (Optional)',
          hintText: 'Enter reason',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildChildNotGoingScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter reason why child not going today',
          style: poppinFonts(
            color: AppColor.textLightBlackColor4A4A4A,
            fontSize: sm,
          ),
        ),
        SpaceHelper(h: 24.h),
        // Reason (Optional)
        CustomTextField(
          controller: reasonController,
          label: 'Reason (Optional)',
          hintText: 'Enter reason',
          maxLines: 4,
          height: 100.h,
        ),
      ],
    );
  }

  Widget _buildChangeDropoffTimeScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a time for the change.',
          style: poppinFonts(
            color: AppColor.textLightBlackColor4A4A4A,
            fontSize: sm,
          ),
        ),
        SpaceHelper(h: 24.h),
        // Preferred Dropoff Time
        CustomTextField(
          controller: dropoffTimeController,
          label: 'Preferred Dropoff Time',
          hintText: 'Add Time',
          isReadOnly: true,
          onTap: () => _selectTime(context, false),
          hasSuffixIcon: Icon(
            Icons.access_time,
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
        SpaceHelper(h: 16.h),
        // Reason (Optional)
        CustomTextField(
          controller: reasonController,
          label: 'Reason (Optional)',
          hintText: 'Enter reason',
          maxLines: 4,
        ),
      ],
    );
  }
}
