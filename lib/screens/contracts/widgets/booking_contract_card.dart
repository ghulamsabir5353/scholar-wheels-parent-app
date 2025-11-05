import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/screens/contracts/booking_detail_screen.dart';
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

  String _getDateRange() {
    if (contract.startDate != null && contract.endDate != null) {
      final startFormat = DateFormat('MMM yyyy').format(contract.startDate!);
      final endFormat = DateFormat('MMM yyyy').format(contract.endDate!);
      return '$startFormat - $endFormat';
    } else if (contract.startDate != null) {
      return DateFormat('MMM yyyy').format(contract.startDate!);
    }
    return 'N/A';
  }

  String _getFee() {
    if (contract.monthlyPayment != null) {
      return '${contract.monthlyPayment}\$';
    } else if (contract.totalPayment != null) {
      return '${contract.totalPayment}\$';
    }
    return '0.00\$';
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
              // Header Section - Transport Owner Name and Driver
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
                            fontSize: xs,
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
                            fontSize: xs,
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
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xffECF4E9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle and Date Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getVehicleName(),
                                  style: poppinFonts(
                                    color: AppColor.black,
                                    fontSize: base,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SpaceHelper(h: 4.h),
                                Text(
                                  _getDateRange(),
                                  style: poppinFonts(
                                    color: AppColor.textLightBlackColor4A4A4A,
                                    fontSize: xs,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SpaceHelper(h: 16.h),
                        // Route Details with Icons and Dotted Line
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icons Column with Dotted Line
                            Column(
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
                                SizedBox(
                                  height: 24.h,
                                  child: CustomPaint(
                                    painter: DottedLinePainter(),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/svg/school.svg',
                                  width: 20.w,
                                  height: 20.w,
                                  colorFilter: ColorFilter.mode(
                                    AppColor.textLightBlackColor4A4A4A,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(w: 12.w),
                            // Text Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pickup:',
                                    style: poppinFonts(
                                      color: AppColor.black,
                                      fontSize: sm,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SpaceHelper(h: 2.h),
                                  Text(
                                    contract.route?.suburb ?? 'N/A',
                                    style: poppinFonts(
                                      color: AppColor.textLightBlackColor4A4A4A,
                                      fontSize: sm,
                                    ),
                                  ),
                                  SpaceHelper(h: 16.h),
                                  Text(
                                    'School:',
                                    style: poppinFonts(
                                      color: AppColor.black,
                                      fontSize: sm,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SpaceHelper(h: 2.h),
                                  Text(
                                    contract.route?.dropOffPoint ?? 'N/A',
                                    style: poppinFonts(
                                      color: AppColor.textLightBlackColor4A4A4A,
                                      fontSize: sm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SpaceHelper(h: 16.h),
                        // Fee Information
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Fee: ',
                                style: poppinFonts(
                                  color: AppColor.black,
                                  fontSize: sm,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: _getFee(),
                                style: poppinFonts(
                                  color: AppColor.textLightBlackColor4A4A4A,
                                  fontSize: sm,
                                ),
                              ),
                            ],
                          ),
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
                          contract.status ?? 'N/A',
                          style: poppinFonts(
                            color: AppColor.primary,
                            fontSize: xs,
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
                        fontSize: base,
                        fontWeight: FontWeight.w500,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                  SpaceHelper(w: 12.w),
                  Expanded(
                    child: CustomButton(
                      height: 32.h,
                      onPressed: () {},
                      title: "Download",
                      style: poppinFonts(
                        fontSize: base,
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

/// Custom painter for dotted vertical line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.textLightBlackColor4A4A4A
      ..strokeWidth = 1.5;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
