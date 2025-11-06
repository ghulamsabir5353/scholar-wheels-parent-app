import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/models/contract_model.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/space_helper.dart';

class BookingDetailScreen extends StatelessWidget {
  static const String route = '/contract-detail-screen';
  const BookingDetailScreen({super.key});

  String _getContractId(ContractModel? contract) {
    if (contract?.contractId != null) return contract!.contractId!;
    if (contract?.id != null) return contract!.id!;
    return 'N/A';
  }

  String _getBusinessName(ContractModel? contract) {
    if (contract?.transportOwner?.businessName != null &&
        contract!.transportOwner!.businessName!.isNotEmpty) {
      return contract.transportOwner!.businessName!;
    }
    return _getTransportOwnerName(contract);
  }

  String _getTransportOwnerName(ContractModel? contract) {
    if (contract?.transportOwner == null) return 'N/A';
    final firstName = contract!.transportOwner!.firstName ?? '';
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

  String _getFullName(ContractModel? contract) {
    if (contract?.transportOwner == null) return 'N/A';
    final firstName = contract!.transportOwner!.firstName ?? '';
    final surName = contract.transportOwner!.surName ?? '';
    if (firstName.isNotEmpty && surName.isNotEmpty) {
      return '$firstName $surName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (surName.isNotEmpty) {
      return surName;
    }
    return 'N/A';
  }

  String _getAverageRating(ContractModel? contract) {
    if (contract?.transportOwner?.averageRating != null) {
      return contract!.transportOwner!.averageRating.toString();
    }
    return '0.0';
  }

  String _getTotalRatings(ContractModel? contract) {
    if (contract?.transportOwner?.totalRatings != null) {
      return contract!.transportOwner!.totalRatings.toString();
    }
    return '0';
  }

  bool _isVerified(ContractModel? contract) {
    return contract?.transportOwner?.isVerified ?? false;
  }

  String _getInitial(String name) {
    if (name.isNotEmpty && name != 'N/A') {
      return name[0].toUpperCase();
    }
    return 'T';
  }

  String _getDriverName(ContractModel? contract) {
    // Driver name not directly available, show assigned status
    if (contract?.route?.assignedDriver != null) {
      return 'Driver Assigned';
    }
    return 'N/A';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    // Format time if it's in 24h format
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return time;
  }

  String _getDateRange(ContractModel? contract) {
    if (contract?.startDate != null && contract?.endDate != null) {
      final startFormat = DateFormat('MMM yyyy').format(contract!.startDate!);
      final endFormat = DateFormat('MMM yyyy').format(contract.endDate!);
      return '$startFormat - $endFormat';
    } else if (contract?.startDate != null) {
      return DateFormat('MMM yyyy').format(contract!.startDate!);
    }
    return 'N/A';
  }

  String _getFee(ContractModel? contract) {
    if (contract?.monthlyPayment != null) {
      return '${contract!.monthlyPayment}\$';
    } else if (contract?.totalPayment != null) {
      return '${contract!.totalPayment}\$';
    }
    return '0.00\$';
  }

  @override
  Widget build(BuildContext context) {
    final contract = Get.arguments as ContractModel?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,

        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        title: Text(
          contract?.contractId ?? 'N/A',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contract Detail Section
              Text(
                'Contract Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getDateRange(contract),
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightSecondary,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              contract?.status?.capitalizeFirst ?? 'Active',
                              style: poppinFonts(
                                color: AppColor.primary,
                                fontSize: sm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Color(0xffECF4E9),
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDetailRow(
                              'Created On:',
                              contract?.createdAt != null
                                  ? _formatDate(contract!.createdAt)
                                  : 'N/A',
                              fontSize: sm,
                            ),
                            SpaceHelper(h: 8.h),
                            _buildDetailRow(
                              'Renewal Date:',
                              _getContractId(contract),
                              fontSize: sm,
                            ),
                            SpaceHelper(h: 8.h),
                            _buildDetailRow(
                              'Fee:',
                              _getFee(contract),
                              fontSize: sm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SpaceHelper(h: 8.h),
              Text(
                'Transport Owner Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Section with Avatar, Business Name, Rating, and Verified Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            backgroundColor: AppColor.darkPrimary,
                            radius: 24.r,
                            child: Text(
                              _getInitial(_getBusinessName(contract)),
                              style: poppinFonts(
                                color: Colors.white,
                                fontSize: base,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SpaceHelper(w: 12.w),
                          // Business Name and Rating
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Business Name
                                Text(
                                  _getBusinessName(contract),
                                  style: poppinFonts(
                                    fontSize: base,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SpaceHelper(h: 4.h),
                                // Rating with Star Icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16.sp,
                                      color: AppColor.darkSecondary,
                                    ),
                                    SpaceHelper(w: 4.w),
                                    Text(
                                      '${_getAverageRating(contract)} (${_getTotalRatings(contract)} reviews)',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Verified Badge
                          if (_isVerified(contract))
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightSecondary,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 14.sp,
                                    color: AppColor.primary,
                                  ),
                                  SpaceHelper(w: 4.w),
                                  Text(
                                    'Verified',
                                    style: poppinFonts(
                                      fontSize: xs,
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SpaceHelper(h: 16.h),
                      // Contact Information Section
                      _buildContactRow('Full Name:', _getFullName(contract)),
                      SpaceHelper(h: 8.h),
                      _buildContactRow(
                        'Email:',
                        contract?.transportOwner?.user?.email ?? 'N/A',
                      ),
                      SpaceHelper(h: 8.h),
                      _buildContactRow(
                        'Phone:',
                        contract?.transportOwner?.user?.phone ?? 'N/A',
                      ),
                      SpaceHelper(h: 16.h),
                      // Chat Button
                      CustomButton(
                        height: 32.h,
                        onPressed: () {
                          // Navigate to chat
                        },
                        title: "Chat",
                        style: poppinFonts(
                          fontSize: sm,
                          fontWeight: FontWeight.w500,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SpaceHelper(h: 8.h),
              // Driver & Vehicle Info Section
              Text(
                'Driver & Vehicle Info',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getDriverName(contract),
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      SpaceHelper(h: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Color(0xffECF4E9),
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: _buildDetailRow(
                                    'Vehicle:',
                                    contract?.route?.routeName ?? 'N/A',
                                  ),
                                ),
                                Expanded(
                                  child: _buildDetailRow(
                                    'Number Plate:',
                                    'N/A', // Not available in Route model
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: _buildDetailRow(
                                    'Vehicle Color:',
                                    'N/A', // Not available in model
                                  ),
                                ),
                                Expanded(
                                  child: _buildDetailRow(
                                    'Distance:',
                                    contract?.route?.estimatedDistance != null
                                        ? '${contract!.route!.estimatedDistance} km'
                                        : 'N/A',
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: _buildDetailRow(
                                    'Stops:',
                                    contract?.children?.length.toString() ??
                                        '0',
                                  ),
                                ),
                                Expanded(
                                  child: _buildDetailRow(
                                    'Student:',
                                    contract?.children?.length.toString() ??
                                        '0',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 8.h),

              // Route Details Section
              Text(
                'Route Details',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pickup Time: ',
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              _formatTime(contract?.pickUpTime),
                              style: poppinFonts(
                                fontSize: sm,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Drop Off Time: ',
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              _formatTime(contract?.knockOffTime),
                              style: poppinFonts(
                                fontSize: sm,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SpaceHelper(h: 12.h),
                      RouteEntryWidget(
                        pickupAddress: contract?.route?.suburb ?? 'N/A',
                        schoolName: contract?.route?.dropOffPoint ?? 'N/A',
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 8.h),

              // Route Map Section
              Text(
                'Route Map',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 12.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Color(0xffECF4E9),
                          border: Border.all(color: AppColor.secondary),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Image.asset('assets/images/png/map.png'),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 20.h),

              // Children Detail Section
              Text(
                'Children Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (contract?.children != null &&
                          contract!.children!.isNotEmpty)
                        ...contract.children!.map((child) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.darkPrimary,
                                  radius: 20.r,
                                  child: Text(
                                    (child.name?.isNotEmpty == true
                                        ? child.name![0].toUpperCase()
                                        : 'C'),
                                    style: poppinFonts(
                                      color: AppColor.appColorWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SpaceHelper(w: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      child.name ?? 'N/A',
                                      style: poppinFonts(
                                        color: AppColor.black,
                                        fontSize: base,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Age ${child.age ?? 'N/A'}${child.schoolDescription != null ? ' • ${child.schoolDescription}' : ''}',
                                      style: poppinFonts(
                                        fontSize: sm,
                                        color:
                                            AppColor.textLightBlackColor4A4A4A,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList()
                      else
                        Text(
                          'No children assigned',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SpaceHelper(h: 8.h),

              // Transport Owner Detail Section
              Text(
                'Transport Owner Detail',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper(h: 8.h),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.textFieldBorderColor),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.darkPrimary,
                                  radius: 24.r,
                                  child: Text(
                                    _getTransportOwnerName(
                                              contract,
                                            ).isNotEmpty &&
                                            _getTransportOwnerName(contract) !=
                                                'N/A'
                                        ? _getTransportOwnerName(
                                            contract,
                                          )[0].toUpperCase()
                                        : 'T',
                                    style: poppinFonts(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SpaceHelper(w: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getTransportOwnerName(contract),
                                        style: poppinFonts(
                                          fontSize: base,
                                          color: AppColor.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        contract?.transportOwner?.user?.email ??
                                            'N/A',
                                        style: poppinFonts(
                                          fontSize: sm,
                                          color: AppColor
                                              .textLightBlackColor4A4A4A,
                                        ),
                                      ),
                                      Text(
                                        contract?.transportOwner?.user?.phone ??
                                            'N/A',
                                        style: poppinFonts(
                                          fontSize: sm,
                                          color: AppColor
                                              .textLightBlackColor4A4A4A,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SpaceHelper(w: 8.w),
                          CustomButton(
                            height: 32.h,
                            width: 60.w,
                            onPressed: () {
                              // Navigate to chat
                            },
                            title: "Chat",
                            style: poppinFonts(
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SpaceHelper(h: 8.h),

              // Download Contract Button
              CustomButton(
                height: 36.h,

                onPressed: () {
                  // Download contract PDF
                },
                title: "Download Contract pdf",
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                  color: AppColor.white,
                ),
              ),
              SpaceHelper(h: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: poppinFonts(
              fontSize: sm,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                value,
                textAlign: TextAlign.right,
                style: poppinFonts(
                  fontSize: sm,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {double? fontSize}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: poppinFonts(
            fontSize: fontSize ?? sm,
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SpaceHelper(w: 8.w),
        Expanded(
          child: Text(
            value,
            style: poppinFonts(
              fontSize: fontSize ?? sm,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
        ),
      ],
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
