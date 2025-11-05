import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/booking_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';

class ContractController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final Rx<ViewState<List<ContractModel>>> contractsState =
      Rx<ViewState<List<ContractModel>>>(LoadingState());
  final RxBool isLoadingBookings = false.obs;
  final Rx<ViewState<List<BookingModel>>> bookingsState =
      Rx<ViewState<List<BookingModel>>>(LoadingState());

  @override
  void onInit() {
    super.onInit();
    // Auto-load contracts when controller is initialized
    getContracts();
  }

  /// Get list of contracts
  Future<void> getContracts() async {
    try {
      isLoading.value = true;
      contractsState.value = LoadingState();

      // Get parent ID from roleData
      final parentId = BaseHelper.currentUser.value.roleData?.id;
      if (parentId == null) {
        contractsState.value = ErrorState('Parent ID not found');
        customToaster('Parent ID not found', color: Colors.red);
        return;
      }

      final response = await apiService.fetchData(
        AppConstants.contract,
        query: {'parentId': parentId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Contracts response: ${response.data}');

        // Parse contracts from response.data['contracts']
        if (response.data != null && response.data['contracts'] != null) {
          final List<dynamic> contractsList =
              response.data['contracts'] as List<dynamic>;

          if (contractsList.isEmpty) {
            contractsState.value = EmptyState(
              message: 'No contracts available. Please try again later.',
            );
          } else {
            final List<ContractModel> parsedContracts = contractsList
                .map(
                  (json) =>
                      ContractModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

            contractsState.value = DataState(data: parsedContracts);
            log('Loaded ${parsedContracts.length} contracts');
          }
        } else {
          contractsState.value = EmptyState(message: 'No contracts found');
        }
      } else {
        contractsState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch contracts',
        );
        customToaster('Failed to load contracts', color: Colors.red);
      }
    } catch (e) {
      contractsState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error loading contracts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh contracts list
  void refreshContracts() {
    getContracts();
  }

  /// Get list of bookings
  Future<void> getBookings() async {
    try {
      isLoadingBookings.value = true;
      bookingsState.value = LoadingState();

      // Get parent ID from roleData
      final parentId = BaseHelper.currentUser.value.roleData?.id;
      if (parentId == null) {
        bookingsState.value = ErrorState('Parent ID not found');
        customToaster('Parent ID not found', color: Colors.red);
        return;
      }

      final response = await apiService.fetchData(
        AppConstants.booking,
        query: {'parentId': parentId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Bookings response: ${response.data}');

        // Parse bookings from response.data['booking'] or response.data['bookings']
        if (response.data != null) {
          List<dynamic> bookingsList;

          if (response.data['booking'] != null) {
            bookingsList = response.data['booking'] is List
                ? response.data['booking'] as List<dynamic>
                : [response.data['booking']];
          } else if (response.data['bookings'] != null) {
            bookingsList = response.data['bookings'] is List
                ? response.data['bookings'] as List<dynamic>
                : [response.data['bookings']];
          } else {
            bookingsList = [];
          }

          if (bookingsList.isEmpty) {
            bookingsState.value = EmptyState(
              message: 'No bookings available. Please try again later.',
            );
          } else {
            final List<BookingModel> parsedBookings = bookingsList
                .map(
                  (json) => BookingModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

            bookingsState.value = DataState(data: parsedBookings);
            log('Loaded ${parsedBookings.length} bookings');
          }
        } else {
          bookingsState.value = EmptyState(message: 'No bookings found');
        }
      } else {
        bookingsState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch bookings',
        );
        customToaster('Failed to load bookings', color: Colors.red);
      }
    } catch (e) {
      bookingsState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error loading bookings: $e');
    } finally {
      isLoadingBookings.value = false;
    }
  }

  /// Refresh bookings list
  void refreshBookings() {
    getBookings();
  }
}
