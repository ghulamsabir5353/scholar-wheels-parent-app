import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/contract_controller.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/screens/contracts/widgets/booking_contract_card.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/space_helper.dart';

class BookingContractScreen extends StatefulWidget {
  const BookingContractScreen({super.key});

  @override
  State<BookingContractScreen> createState() => _BookingContractScreenState();
}

class _BookingContractScreenState extends State<BookingContractScreen> {
  late ContractController contractController;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    contractController = Get.find<ContractController>();
  }

  List<ContractModel> _getFilteredContracts(List<ContractModel> contracts) {
    if (selectedFilter == 'All') {
      return contracts;
    }
    return contracts.where((contract) {
      final status = (contract.status ?? '').toLowerCase();
      switch (selectedFilter) {
        case 'Active':
          return status == 'active';
        case 'Completed':
          return status == 'completed';
        case 'Cancelled':
          return status == 'cancelled';
        default:
          return true;
      }
    }).toList();
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
        title: Text(
          'Contracts',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(() {
        final state = contractController.contractsState.value;

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
                      ? 'No contracts found'
                      : emptyState.message,
                  style: poppinFonts(
                    fontSize: base,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
                SpaceHelper(h: 12.h),
                ElevatedButton(
                  onPressed: () {
                    contractController.refreshContracts();
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
                  'Failed to load contracts',
                  style: poppinFonts(fontSize: base, color: Colors.red),
                ),
                SpaceHelper(h: 12.h),
                ElevatedButton(
                  onPressed: () {
                    contractController.refreshContracts();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is DataState<List<ContractModel>>) {
          final contracts = state.data;
          final filteredContracts = _getFilteredContracts(contracts);

          return Column(
            children: [
              // Filter Tabs
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                    _buildFilterTab('All'),
                    SpaceHelper(w: 8.w),
                    _buildFilterTab('Active'),
                    SpaceHelper(w: 8.w),
                    _buildFilterTab('Completed'),
                    SpaceHelper(w: 8.w),
                    _buildFilterTab('Cancelled'),
                  ],
                ),
              ),
              // Contracts List
              Expanded(
                child: filteredContracts.isEmpty
                    ? Center(
                        child: Text(
                          'No contracts available',
                          style: poppinFonts(
                            fontSize: base,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await contractController.getContracts();
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
                                ...filteredContracts.map((contract) {
                                  return BookingContractCard(
                                    contract: contract,
                                  );
                                }).toList(),
                              ],
                            ),
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

  Widget _buildFilterTab(String label) {
    final isSelected = selectedFilter == label;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
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
              label,
              style: poppinFonts(
                fontSize: sm,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColor.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
