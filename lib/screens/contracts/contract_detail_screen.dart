import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/bottom_tab_controller.dart';
import 'package:scholarwheels/controllers/contract_controller.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/route_entry_widget.dart';
import 'package:scholarwheels/core/helper.widgets/location_permission_map_gate.dart';
import 'package:scholarwheels/core/helper.widgets/route_map_widget.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/screens/contracts/widgets/booking_contract_rating_review_section.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/space_helper.dart';

class ContractDetailScreen extends StatefulWidget {
  static const String route = '/contract-detail-screen';
  const ContractDetailScreen({super.key});

  @override
  State<ContractDetailScreen> createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  final ContractController contractController = Get.find<ContractController>();
  String? contractId;

  /// When true, scroll is disabled so map can handle two-finger zoom/pan.
  bool _isInteractingWithMap = false;
  int _mapPointerCount = 0;

  @override
  void initState() {
    super.initState();
    // Get contract ID from arguments
    final args = Get.arguments;
    if (args is String) {
      contractId = args;
    } else if (args is ContractModel) {
      contractId = args.id;
    } else if (args is Map && args['id'] != null) {
      contractId = args['id'] as String;
    }

    // Fetch contract detail if ID is available
    if (contractId != null && contractId!.isNotEmpty) {
      contractController.getContractById(contractId!);
    }
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
    final businessName = contract!.transportOwner!.businessName ?? '';

    if (businessName.isNotEmpty) {
      return '$businessName';
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
    if (contract?.route?.driver?.fullName != null &&
        contract!.route!.driver!.fullName!.isNotEmpty) {
      return contract.route!.driver!.fullName!;
    }
    return 'N/A';
  }

  String _getVehicleName(ContractModel? contract) {
    if (contract?.route?.vehicle?.make != null &&
        contract?.route?.vehicle?.model != null) {
      return '${contract!.route!.vehicle!.make} ${contract.route!.vehicle!.model}';
    } else if (contract?.route?.vehicle?.make != null) {
      return contract!.route!.vehicle!.make!;
    } else if (contract?.route?.routeName != null) {
      return contract!.route!.routeName!;
    }
    return 'N/A';
  }

  String _getRegistrationNumber(ContractModel? contract) {
    return contract?.route?.vehicle?.registrationNumber ?? 'N/A';
  }

  String _getVehicleType(ContractModel? contract) {
    return contract?.route?.vehicle?.vehicleType?.capitalizeFirst ?? 'N/A';
  }

  String _getVehicleModel(ContractModel? contract) {
    if (contract?.route?.vehicle?.manufacturingYear != null) {
      return contract!.route!.vehicle!.manufacturingYear!;
    } else if (contract?.route?.vehicle?.model != null) {
      return contract!.route!.vehicle!.model!;
    }
    return 'N/A';
  }

  String _getVehicleColor(ContractModel? contract) {
    return contract?.route?.vehicle?.color ?? 'N/A';
  }

  String _formatContractDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('d MMM, yyyy').format(date);
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

  String _getContractDuration(ContractModel? contract) {
    if (contract?.startDate != null && contract?.endDate != null) {
      final startDate = contract!.startDate!;
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
    if (contract?.contractDuration != null &&
        contract!.contractDuration!.isNotEmpty) {
      return contract.contractDuration!;
    }

    return 'N/A';
  }

  String _getMonthlyPay(ContractModel? contract) {
    if (contract?.monthlyPayment != null) {
      return 'R ${contract!.monthlyPayment}';
    } else if (contract?.totalPayment != null) {
      return 'R ${contract!.totalPayment}';
    }
    return 'R 0';
  }

  String _formatAmount(int? amount) {
    if (amount == null) return 'R 0';
    // Format with comma separators using NumberFormat
    final formatter = NumberFormat('#,###');
    return 'R ${formatter.format(amount)}';
  }

  String _getTotalPayment(ContractModel? contract) {
    if (contract?.billingHistory?.totalPayment != null) {
      return _formatAmount(contract!.billingHistory!.totalPayment);
    } else if (contract?.totalPayment != null) {
      return _formatAmount(contract!.totalPayment);
    }
    return 'R 0';
  }

  String _getPaidAmount(ContractModel? contract) {
    if (contract?.billingHistory?.paidAmount != null) {
      return _formatAmount(contract!.billingHistory!.paidAmount);
    }
    return 'R 0';
  }

  String _getDueAmount(ContractModel? contract) {
    if (contract?.billingHistory?.dueAmount != null) {
      return _formatAmount(contract!.billingHistory!.dueAmount);
    }
    // Calculate due amount if not available
    final total =
        contract?.billingHistory?.totalPayment ?? contract?.totalPayment ?? 0;
    final paid = contract?.billingHistory?.paidAmount ?? 0;
    return _formatAmount(total - paid);
  }

  ContractModel? _getContract() {
    final state = contractController.contractDetailState.value;
    if (state is DataState<ContractModel>) {
      return state.data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final contract = _getContract();
      final isLoading = contractController.isLoadingContractDetail.value;
      final state = contractController.contractDetailState.value;

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
            contract?.contractId ?? '',
            style: poppinFonts(
              fontSize: lg,
              color: AppColor.headingFontColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: _buildBody(state, isLoading, contract),
      );
    });
  }

  Widget _buildBody(
    ViewState<ContractModel> state,
    bool isLoading,
    ContractModel? contract,
  ) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColor.primary));
    }

    if (state is ErrorState<ContractModel>) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SpaceHelper(h: 16.h),
            Text(
              state.message,
              style: poppinFonts(fontSize: base, color: AppColor.black),
              textAlign: TextAlign.center,
            ),
            SpaceHelper(h: 16.h),
            CustomButton(
              onPressed: () {
                if (contractId != null) {
                  contractController.getContractById(contractId!);
                }
              },
              title: "Retry",
              style: poppinFonts(
                fontSize: base,
                fontWeight: FontWeight.w500,
                color: AppColor.white,
              ),
            ),
          ],
        ),
      );
    }

    if (state is EmptyState<ContractModel>) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
            SpaceHelper(h: 16.h),
            Text(
              state.message,
              style: poppinFonts(
                fontSize: base,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (contract == null) {
      return Center(
        child: Text(
          'No contract data available',
          style: poppinFonts(
            fontSize: base,
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: _isInteractingWithMap
          ? const NeverScrollableScrollPhysics()
          : null,
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
              elevation: 0,
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F9F3),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColor.borderGreen, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.cardShadowColorGreen.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDetailRow(
                            'Contract Duration:',
                            _getContractDuration(contract),
                            fontSize: sm,
                          ),
                        ),
                        SpaceHelper(w: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff0A7A2A),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            contract?.status?.capitalizeFirst ?? 'Active',
                            style: poppinFonts(
                              color: AppColor.white,
                              fontSize: sm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildDetailRow(
                      'Contract Start Date:',
                      _formatContractDate(contract?.startDate),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Contract End Date:',
                      _formatContractDate(contract?.endDate),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Monthly Pay:',
                      _getMonthlyPay(contract),
                      fontSize: sm,
                    ),
                  ],
                ),
              ),
            ),

            SpaceHelper(h: 8.h),
            // Billing History Section
            if (contract.billingHistory != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Billing History',
                    style: poppinFonts(
                      fontSize: base,
                      color: AppColor.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SpaceHelper(h: 8.h),
                  Card(
                    elevation: 2,
                    shadowColor: AppColor.cardShadowColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: AppColor.cardBorderColorGrey),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBillingRow(
                            'Total Payment:',
                            _getTotalPayment(contract),
                          ),
                          SpaceHelper(h: 12.h),
                          _buildBillingRow(
                            'Paid Amount:',
                            _getPaidAmount(contract),
                          ),
                          SpaceHelper(h: 12.h),
                          _buildBillingRow(
                            'Due Amount:',
                            _getDueAmount(contract),
                          ),
                          SpaceHelper(h: 16.h),
                          CustomButton(
                            onPressed: () {
                              // Navigate to invoices screen
                            },
                            title: "View Invoices",
                            style: poppinFonts(
                              fontSize: base,
                              fontWeight: FontWeight.w500,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
              elevation: 2,
              shadowColor: AppColor.cardShadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: AppColor.cardBorderColorGrey),
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
                                SvgPicture.asset(
                                  'assets/images/svg/verified.svg',
                                  width: 14.w,
                                  height: 14.h,
                                ),
                                SpaceHelper(w: 4.w),
                                Text(
                                  'Verified',
                                  style: poppinFonts(
                                    fontSize: xs,
                                    color: AppColor.black,
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
                      onPressed: () {
                        // Navigate to chat
                        Get.find<BottomTabController>().setTabIndex(4);
                        Get.until(
                          (route) => route.settings.name == '/tab_screen',
                        );
                      },
                      title: "Chat",
                    ),
                  ],
                ),
              ),
            ),

            SpaceHelper(h: 8.h),
            BookingContractRatingReviewSection(
              key: ValueKey(
                'contract_review_${contract.id ?? contract.contractId}',
              ),
              contract: contract,
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
              elevation: 2,
              shadowColor: AppColor.cardShadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: AppColor.cardBorderColorGrey),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow(
                      'Driver Name:',
                      _getDriverName(contract),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Vehicle:',
                      _getVehicleName(contract),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Registration no.:',
                      _getRegistrationNumber(contract),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Vehicle Type:',
                      _getVehicleType(contract),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Model:',
                      _getVehicleModel(contract),
                      fontSize: sm,
                    ),
                    SpaceHelper(h: 12.h),
                    _buildDetailRow(
                      'Color:',
                      _getVehicleColor(contract),
                      fontSize: sm,
                    ),
                  ],
                ),
              ),
            ),

            SpaceHelper(h: 8.h),
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
              elevation: 2,
              shadowColor: AppColor.cardShadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: AppColor.cardBorderColorGrey),
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
                          padding: EdgeInsets.only(bottom: 0.h),
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
                                    'Age ${child.age ?? 'N/A'}${child.school != null ? ' • ${child.school}' : ''}',
                                    style: poppinFonts(
                                      fontSize: sm,
                                      color: AppColor.textLightBlackColor4A4A4A,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      })
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
              elevation: 2,
              shadowColor: AppColor.cardShadowColor,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: AppColor.secondary),
              ),
              color: AppColor.cardBgColor,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
                    ),

                    SpaceHelper(h: 12.h),
                    RouteEntryWidget(
                      pickupAddress: contract?.route?.suburbName ?? 'N/A',
                      schoolName: contract?.route?.dropOffPointName ?? 'N/A',
                      isLast: true,
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
            Listener(
              onPointerDown: (_) {
                _mapPointerCount++;
                if (_mapPointerCount >= 2 && !_isInteractingWithMap) {
                  setState(() => _isInteractingWithMap = true);
                }
              },
              onPointerUp: (_) {
                _mapPointerCount--;
                if (_mapPointerCount < 0) _mapPointerCount = 0;
                if (_mapPointerCount < 2 && _isInteractingWithMap) {
                  setState(() => _isInteractingWithMap = false);
                }
              },
              onPointerCancel: (_) {
                _mapPointerCount--;
                if (_mapPointerCount < 0) _mapPointerCount = 0;
                if (_mapPointerCount < 2 && _isInteractingWithMap) {
                  setState(() => _isInteractingWithMap = false);
                }
              },
              child: Card(
                elevation: 2,
                shadowColor: AppColor.cardShadowColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColor.cardBorderColorGrey),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LocationPermissionMapGate(
                        child: RouteMapWidget(
                          pickupLocation: contract?.route?.suburb,
                          dropOffLocation: contract?.route?.dropOffPoint,
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SpaceHelper(h: 20.h),
          ],
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
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: poppinFonts(
              fontSize: sm,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
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
            color: AppColor.textLightBlackColor4A4A4A,
          ),
        ),
        SpaceHelper(w: 8.w),
        Expanded(
          child: Text(
            value,
            style: poppinFonts(
              fontSize: fontSize ?? sm,

              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: poppinFonts(fontSize: sm, color: AppColor.black),
        ),
        Text(
          value,
          style: poppinFonts(
            fontSize: sm,
            color: AppColor.black,
            fontWeight: FontWeight.w500,
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
