import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    if (contract.contractDuration != null &&
        contract.contractDuration!.isNotEmpty) {
      return contract.contractDuration!;
    }
    return 'N/A';
  }

  String _getMonthlyPay() {
    if (contract.monthlyPayment != null) {
      final amount = contract.monthlyPayment.toString();
      return 'R$amount';
    }
    return 'R0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.textFieldBorderColor),
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
                  border: Border.all(color: AppColor.secondary),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle Name (top left)
                        Text(
                          _getVehicleName(),
                          style: poppinFonts(
                            color: AppColor.black,
                            fontSize: base,
                            fontWeight: FontWeight.w500,
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
                          pickupAddress: contract.route?.suburb ?? 'N/A',
                          schoolName: contract.route?.dropOffPoint ?? 'N/A',
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
                          color: AppColor.lightSecondary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          contract.status?.capitalizeFirst ?? 'N/A',
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
              ),
              SpaceHelper(h: 16.h),
              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          BookingDetailScreen.route,
                          arguments: contract,
                        );
                      },
                      child: Container(
                        height: 32.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.secondary),
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
                      height: 32.h,
                      onPressed: () {},
                      title: "Chat",
                      style: poppinFonts(
                        fontSize: sm,
                        fontWeight: FontWeight.w500,
                        color: AppColor.white,
                      ),
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
