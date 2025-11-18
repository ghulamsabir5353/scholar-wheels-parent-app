import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_services.dart';
import '../services/api_state.dart';
import '../models/dashboard_model.dart';
import '../controllers/base.helper.controller.dart';
import '../core/helper.widgets/custom_toaster.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  final ApiService apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final Rx<ViewState<DashboardModel>> dashboardState =
      Rx<ViewState<DashboardModel>>(LoadingState());

  @override
  void onInit() {
    super.onInit();
    getDashboardData();
  }

  /// Get dashboard data for parent
  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;
      dashboardState.value = LoadingState();

      // Get parent ID from roleData
      final parentId = BaseHelper.currentUser.value.roleData?.id;
      if (parentId == null) {
        dashboardState.value = ErrorState('Parent ID not found');
        return;
      }

      final endpoint = '/dashboard/parent/$parentId';
      final response = await apiService.fetchData(
        endpoint,
        query: {'presigned': true},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Dashboard response: ${response.data}');

        // Parse dashboard data from response.data['data']
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];

          // Check if data is a Map (single object)
          if (data is Map<String, dynamic>) {
            try {
              final dashboardModel = DashboardModel.fromJson(data);
              dashboardState.value = DataState(data: dashboardModel);
              log('Loaded dashboard data successfully');
            } catch (e) {
              log('Error parsing dashboard model: $e');
              dashboardState.value = ErrorState(
                'Failed to parse dashboard data: ${e.toString()}',
              );
            }
          } else {
            dashboardState.value = ErrorState(
              'Invalid dashboard data format. Expected a Map but got ${data.runtimeType}',
            );
          }
        } else {
          dashboardState.value = EmptyState(message: 'No dashboard data found');
        }
      } else {
        dashboardState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch dashboard data',
        );
        customToaster('Failed to load dashboard data', color: Colors.red);
      }
    } catch (e, stackTrace) {
      dashboardState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error loading dashboard data: $e');
      log('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh dashboard data
  void refreshDashboard() {
    getDashboardData();
  }

  // Trips state
  final RxBool isLoadingTrips = false.obs;
  final Rx<ViewState<List<NextTrip>>> tripsState =
      Rx<ViewState<List<NextTrip>>>(LoadingState());

  /// Get trips based on filter type and status
  /// filterType: daily, weekly, monthly
  /// status: scheduled (for upcoming) or active (for active rides)
  Future<void> getTrips({
    required String filterType,
    required String status,
  }) async {
    try {
      isLoadingTrips.value = true;
      tripsState.value = LoadingState();

      // Get parent ID from roleData
      final parentId = BaseHelper.currentUser.value.roleData?.id;
      if (parentId == null) {
        tripsState.value = ErrorState('Parent ID not found');
        return;
      }

      final endpoint = '/trips';
      final query = {
        'filterType': filterType,
        'parentId': parentId,
        'status': status,
        'presigned': true,
      };

      final response = await apiService.fetchData(endpoint, query: query);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Trips response: ${response.data}');

        // Parse trips from response.data['data']
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];

          // Check if data is a list
          List<dynamic> tripsList;
          if (data is List) {
            tripsList = data;
          } else if (data is Map && data['data'] != null) {
            tripsList = data['data'] as List<dynamic>;
          } else {
            tripsList = [];
          }

          if (tripsList.isEmpty) {
            tripsState.value = EmptyState(message: 'No trips available.');
          } else {
            final List<NextTrip> parsedTrips = tripsList
                .map((json) => NextTrip.fromJson(json as Map<String, dynamic>))
                .toList();

            tripsState.value = DataState(data: parsedTrips);
            log('Loaded ${parsedTrips.length} trips');
          }
        } else {
          tripsState.value = EmptyState(message: 'No trips found');
        }
      } else {
        tripsState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch trips',
        );
        customToaster('Failed to load trips', color: Colors.red);
      }
    } catch (e, stackTrace) {
      tripsState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error loading trips: $e');
      log('Stack trace: $stackTrace');
    } finally {
      isLoadingTrips.value = false;
    }
  }

  /// Refresh trips
  void refreshTrips({required String filterType, required String status}) {
    getTrips(filterType: filterType, status: status);
  }

  /// Manage ride - PATCH API
  Future<bool> manageRide({
    required String tripId,
    required String childId,
    String? status, // Only required when child not going (cancelled)
    String? pickupTime,
    String? dropOffTime,
    String? reason,
  }) async {
    try {
      isLoading.value = true;

      // Build request body - childId is always required
      final Map<String, dynamic> body = {'childId': childId};

      // Add status only if provided (when child not going)
      if (status != null && status.isNotEmpty) {
        body['status'] = status;
      }

      // Add optional fields
      if (pickupTime != null && pickupTime.isNotEmpty) {
        body['pickupTime'] = pickupTime;
      }
      if (dropOffTime != null && dropOffTime.isNotEmpty) {
        body['dropOffTime'] = dropOffTime;
      }
      if (reason != null && reason.isNotEmpty) {
        body['reason'] = reason;
      }

      log('Manage Ride API Call - TripId: $tripId, Body: $body');

      final endpoint = '/trips/$tripId/children';
      final response = await apiService.patchData(endpoint, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Manage Ride - Success');
        customToaster('Ride updated successfully', color: Colors.green);
        return true;
      } else {
        customToaster(
          response.data['message'] ?? 'Failed to update ride',
          color: Colors.red,
        );
        return false;
      }
    } catch (e) {
      customToaster('Failed to update ride', color: Colors.red);
      log('error managing ride: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
