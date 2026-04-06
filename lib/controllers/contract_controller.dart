import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/contract_rating_model.dart';
import 'package:scholarwheels/models/booking_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_exception.dart';
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
  final RxBool isLoadingContractDetail = false.obs;
  final Rx<ViewState<ContractModel>> contractDetailState =
      Rx<ViewState<ContractModel>>(LoadingState());

  /// Reviews for the contract detail screen (GET /rating?contractId=).
  final RxList<ContractRatingReview> contractRatings =
      <ContractRatingReview>[].obs;
  final RxBool isLoadingRatings = false.obs;
  final RxBool isSubmittingRating = false.obs;

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
        query: {'parentId': parentId, 'presigned': true},
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
      showApiError(e, logLabel: 'getContracts');
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
        query: {'parentId': parentId, 'presigned': true},
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
      showApiError(e, logLabel: 'getBookings');
    } finally {
      isLoadingBookings.value = false;
    }
  }

  /// Refresh bookings list
  void refreshBookings() {
    getBookings();
  }

  List<ContractRatingReview> _parseRatingsResponse(dynamic data) {
    if (data == null) return [];
    List<dynamic>? raw;
    if (data is List) {
      raw = data;
    } else if (data is Map<String, dynamic>) {
      raw =
          data['ratings'] as List<dynamic>? ??
          data['data'] as List<dynamic>? ??
          data['rating'] as List<dynamic>? ??
          data['reviews'] as List<dynamic>?;
    }
    if (raw == null || raw.isEmpty) return [];
    return raw
        .map((e) => ContractRatingReview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /rating?contractId=
  Future<void> fetchRatingsForContract(String contractId) async {
    if (contractId.isEmpty) return;
    try {
      isLoadingRatings.value = true;
      final response = await apiService.fetchData(
        AppConstants.rating,
        query: {
          'contractId': contractId,
          'parentId': BaseHelper.currentUser.value.roleData?.id,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Ratings response: ${response.data}');
        contractRatings.assignAll(_parseRatingsResponse(response.data));
      } else {
        contractRatings.clear();
      }
    } catch (e) {
      contractRatings.clear();
      showApiError(e, logLabel: 'fetchRatingsForContract');
    } finally {
      isLoadingRatings.value = false;
    }
  }

  /// POST /rating — body: contractId, rating (string), comment, parentId
  Future<bool> createContractRating({
    required String contractId,
    required int rating,
    required String comment,
  }) async {
    final parentId = BaseHelper.currentUser.value.roleData?.id;
    if (parentId == null || parentId.isEmpty) {
      customToaster('Parent ID not found', color: Colors.red);
      return false;
    }
    if (contractId.isEmpty) {
      customToaster('Contract ID not found', color: Colors.red);
      return false;
    }
    try {
      isSubmittingRating.value = true;
      final body = <String, dynamic>{
        'contractId': contractId,
        'rating': rating.toString(),
        'comment': comment,
        'parentId': parentId,
      };
      final response = await apiService.createData(AppConstants.rating, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = response.data is Map && response.data['message'] != null
            ? response.data['message'].toString()
            : 'Review submitted';
        customToaster(msg, color: Colors.green);
        await fetchRatingsForContract(contractId);
        return true;
      } else {
        final msg = response.data is Map && response.data['message'] != null
            ? response.data['message'].toString()
            : 'Failed to submit review';
        customToaster(msg, color: Colors.red);
        return false;
      }
    } catch (e) {
      // Show API message for conflicts like 409 "already rated this month"
      if (e is ApiException) {
        String msg = e.message;
        final details = e.details;
        if (details is Map && details['errors'] is List && details['errors'].isNotEmpty) {
          final first = details['errors'].first;
          if (first != null && first.toString().trim().isNotEmpty) {
            msg = first.toString();
          }
        }
        customToaster(msg, color: Colors.red);
        log('createContractRating: $e');
      } else {
        showApiError(e, logLabel: 'createContractRating');
      }
      return false;
    } finally {
      isSubmittingRating.value = false;
    }
  }

  /// Get single contract by ID
  Future<void> getContractById(String contractId) async {
    try {
      isLoadingContractDetail.value = true;
      contractDetailState.value = LoadingState();
      contractRatings.clear();

      final endpoint = '${AppConstants.contract}/$contractId';
      final response = await apiService.fetchData(
        endpoint,
        query: {'presigned': true},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Contract detail response: ${response.data}');

        // Parse contract from response.data['contract']
        if (response.data != null && response.data['contract'] != null) {
          final contractJson =
              response.data['contract'] as Map<String, dynamic>;
          final contract = ContractModel.fromJson(contractJson);

          contractDetailState.value = DataState(data: contract);
          log('Loaded contract: ${contract.contractId}');

          final idForRating = contract.id ?? contract.contractId ?? contractId;
          if (idForRating.isNotEmpty) {
            fetchRatingsForContract(idForRating);
          }
        } else {
          contractDetailState.value = EmptyState(message: 'Contract not found');
          customToaster('Contract not found', color: Colors.red);
        }
      } else {
        contractDetailState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch contract',
        );
        customToaster('Failed to load contract', color: Colors.red);
      }
    } catch (e) {
      contractDetailState.value = ExceptionState(Exception(e.toString()));
      showApiError(e, logLabel: 'getContractById');
    } finally {
      isLoadingContractDetail.value = false;
    }
  }
}
