import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/contract_controller.dart';
import 'package:scholarwheels/models/booking_model.dart';
import 'package:scholarwheels/screens/bookings/widgets/booking_history_card.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';
import '../../core/helper.widgets/space_helper.dart';

class RequestHistoryScreen extends StatefulWidget {
  static const String route = '/request-history-screen';
  const RequestHistoryScreen({super.key});

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  late ContractController contractController;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    contractController = Get.find<ContractController>();
    // Load bookings when screen initializes
    contractController.getBookings();
  }

  List<BookingModel> _getFilteredBookings() {
    final state = contractController.bookingsState.value;
    if (state is! DataState<List<BookingModel>>) {
      return [];
    }

    final bookings = state.data;
    if (selectedFilter == 'All') {
      return bookings;
    }

    return bookings
        .where(
          (booking) =>
              booking.status?.toLowerCase() == selectedFilter.toLowerCase() ||
              booking.approveStatus?.toLowerCase() ==
                  selectedFilter.toLowerCase(),
        )
        .toList();
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
          'Request History',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(child: _buildFilterButton('All')),
                SpaceHelper(w: 8.w),
                Expanded(child: _buildFilterButton('Pending')),
                SpaceHelper(w: 8.w),
                Expanded(child: _buildFilterButton('Accepted')),
                SpaceHelper(w: 8.w),
                Expanded(child: _buildFilterButton('Rejected')),
              ],
            ),
          ),
          // Bookings List
          Expanded(
            child: Obx(() {
              final state = contractController.bookingsState.value;

              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is EmptyState) {
                final emptyState = state as EmptyState;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emptyState.message.isEmpty
                            ? 'No bookings found'
                            : emptyState.message,
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      SpaceHelper(h: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          contractController.refreshBookings();
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
                        'Failed to load bookings',
                        style: poppinFonts(fontSize: base, color: Colors.red),
                      ),
                      SpaceHelper(h: 12.h),
                      ElevatedButton(
                        onPressed: () {
                          contractController.refreshBookings();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DataState<List<BookingModel>>) {
                final filteredBookings = _getFilteredBookings();

                if (filteredBookings.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${selectedFilter.toLowerCase()} bookings available',
                      style: poppinFonts(
                        fontSize: base,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await contractController.getBookings();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.w,
                      ),
                      child: Column(
                        children: [
                          ...filteredBookings.map((booking) {
                            return BookingHistoryCard(booking: booking);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    final isSelected = selectedFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColor.primary
                : AppColor.textFieldBorderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            filter,
            style: poppinFonts(
              fontSize: sm,
              color: isSelected ? Colors.white : AppColor.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
