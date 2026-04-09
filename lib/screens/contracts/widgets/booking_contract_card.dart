import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/screens/contracts/contract_detail_screen.dart';
import '../../../core/helper.widgets/space_helper.dart';

class BookingContractCard extends StatelessWidget {
  final ContractModel contract;

  const BookingContractCard({super.key, required this.contract});

  String _getTransportOwnerName() {
    if (contract.transportOwner == null) return 'N/A';
    final firstName = contract.transportOwner!.firstName ?? '';
    final surName = contract.transportOwner!.surName ?? '';
    if (firstName.isNotEmpty && surName.isNotEmpty) {
      return '$firstName $surName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (surName.isNotEmpty) {
      return surName;
    } else if (contract.transportOwner!.businessName != null &&
        contract.transportOwner!.businessName!.isNotEmpty) {
      return contract.transportOwner!.businessName!;
    }
    return 'N/A';
  }

  String _getDriverName() {
    // Driver info not directly available in Route, show assignedDriver ID or N/A
    if (contract.route?.assignedDriver != null) {
      return 'Driver Assigned';
    }
    return 'N/A';
  }

  String _getVehicleName() {
    if (contract.route?.routeName != null &&
        contract.route!.routeName!.isNotEmpty) {
      return contract.route!.routeName!;
    }
    return 'Vehicle';
  }

  String _getContractId() {
    return contract.contractId ?? 'N/A';
  }

  String _getContractStartDate() {
    if (contract.startDate != null) {
      return DateFormat('d MMM, yyyy').format(contract.startDate!);
    }
    return 'N/A';
  }

  String _getContractDuration() {
    if (contract.startDate != null && contract.endDate != null) {
      final startDate = contract.startDate!;
      final endDate = contract.endDate!;

      if (endDate.isBefore(startDate)) {
        return 'N/A';
      }

      // Calculate full calendar months
      int years = endDate.year - startDate.year;
      int monthDiff = endDate.month - startDate.month;
      int fullMonths = (years * 12) + monthDiff;

      // Adjust if end day is before start day (partial month)
      if (endDate.day < startDate.day) {
        fullMonths--;
      }

      // Calculate the date after full months
      DateTime dateAfterFullMonths = DateTime(
        startDate.year,
        startDate.month + fullMonths,
        startDate.day,
      );

      // Calculate remaining days
      int remainingDays = endDate.difference(dateAfterFullMonths).inDays;

      // Average days per month (accounts for leap years: 365.25/12)
      const double averageDaysPerMonth = 365.25 / 12;

      // Convert remaining days to fraction of a month
      double monthFraction = remainingDays / averageDaysPerMonth;

      // Total months with decimal precision
      double totalMonths = fullMonths + monthFraction;

      // Format the result
      if (totalMonths >= 1) {
        // Check if it's a whole number (within 0.01 tolerance)
        final rounded = totalMonths.round();
        if ((totalMonths - rounded).abs() < 0.01) {
          return '$rounded ${rounded == 1 ? 'Month' : 'Months'}';
        } else {
          // Show one decimal place
          final formatted = totalMonths.toStringAsFixed(1);
          return '$formatted Months';
        }
      } else {
        // Less than a month, show total days
        final totalDays = endDate.difference(startDate).inDays;
        if (totalDays > 0) {
          return '$totalDays ${totalDays == 1 ? 'Day' : 'Days'}';
        } else {
          return '0 Days';
        }
      }
    }

    // Fallback to contractDuration if available
    if (contract.contractDuration != null &&
        contract.contractDuration!.isNotEmpty) {
      return contract.contractDuration!;
    }

    return 'N/A';
  }

  String _getMonthlyPay() {
    if (contract.monthlyPayment != null) {
      final amount = contract.monthlyPayment.toString();
      return 'R $amount';
    }
    return 'R 0.00';
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = contract.status?.toLowerCase().trim() == 'cancelled';

    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.cardBorderColorGrey),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadowColor.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contract# and Start Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contract#',
                          style: poppinFonts(
                            color: AppColor.textLightBlackColor4A4A4A,
                            fontSize: sm,
                          ),
                        ),
                        SpaceHelper(h: 2.h),
                        Text(
                          _getContractId(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contract Start Date',
                          style: poppinFonts(
                            color: AppColor.textLightBlackColor4A4A4A,
                            fontSize: sm,
                          ),
                        ),
                        SpaceHelper(h: 2.h),
                        Text(
                          _getContractStartDate(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 16.h),
              // Transport Owner Name and Driver Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transport Owner Name',
                          style: poppinFonts(
                            color: AppColor.textLightBlackColor4A4A4A,
                            fontSize: sm,
                          ),
                        ),
                        SpaceHelper(h: 2.h),
                        Text(
                          _getTransportOwnerName(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Driver',
                          style: poppinFonts(
                            color: AppColor.textLightBlackColor4A4A4A,
                            fontSize: sm,
                          ),
                        ),
                        SpaceHelper(h: 2.h),
                        Text(
                          _getDriverName(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: sm,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 16.h),
              // Main Green Content Area
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColor.cardBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.borderGreen),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle Name (top left) - with padding to avoid status badge
                        Padding(
                          padding: EdgeInsets.only(right: 80.w),
                          child: Text(
                            _getVehicleName(),
                            style: poppinFonts(
                              color: AppColor.black,
                              fontSize: base,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SpaceHelper(h: 12.h),
                        // Contract Duration
                        Row(
                          children: [
                            Text(
                              'Contract Duration:',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: sm,
                              ),
                            ),
                            SpaceHelper(w: 2.2),
                            Text(
                              _getContractDuration(),
                              style: poppinFonts(
                                color: AppColor.black,
                                fontSize: sm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SpaceHelper(h: 12.h),
                        // Route Details with Icons and Dotted Line
                        RouteEntryWidget(
                          pickupAddress: contract.route?.suburbName ?? 'N/A',
                          schoolName: contract.route?.dropOffPointName ?? 'N/A',
                        ),
                        SpaceHelper(h: 12.h),
                        // Monthly Pay
                        Row(
                          children: [
                            Text(
                              'Monthly Pay: ',
                              style: poppinFonts(
                                color: AppColor.textLightBlackColor4A4A4A,
                                fontSize: sm,
                              ),
                            ),
                            SpaceHelper(w: 2.w),
                            Text(
                              _getMonthlyPay(),
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
                    // Status Badge
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isCancelled
                              ? AppColor.notCompletedStatusColor
                              : AppColor.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          contract.status?.capitalizeFirst ?? 'N/A',
                          style: poppinFonts(
                            color: AppColor.white,
                            fontSize: sm,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SpaceHelper(h: 16.h),
              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          ContractDetailScreen.route,
                          arguments: contract.id ?? contract.contractId,
                        );
                      },
                      child: Container(
                        height: 36.h.toDouble(),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.borderGreen),
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: poppinFonts(
                              fontWeight: FontWeight.w500,
                              fontSize: sm,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: CustomButton(
                      height: 36.h.toDouble(),
                      onPressed: () {
                        Get.find<BottomTabController>().setTabIndex(4);
                      },
                      title: "Chat",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
