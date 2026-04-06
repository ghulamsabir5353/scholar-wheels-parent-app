import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/models/trip_model.dart';
import '../services/api_services.dart';
import '../services/api_exception.dart';
import '../services/api_state.dart';
import '../models/dashboard_model.dart';
import '../controllers/base.helper.controller.dart';
import '../core/helper.widgets/custom_toaster.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  final ApiService apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final Rx<ViewState<DashboardModel>> dashboardState =
      Rx<ViewState<DashboardModel>>(LoadingState());

  /// Holds the list of logbook trips (history) for the driver
  final Rx<ViewState<List<TripModel>>> logbookTripsState =
      Rx<ViewState<List<TripModel>>>(LoadingState());
  final RxString selectedFilter = 'Daily'.obs;

  /// Holds a single trip detail for logbook detail screen
  final Rx<ViewState<TripModel>> tripDetailState = Rx<ViewState<TripModel>>(
    LoadingState(),
  );
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
      showApiError(e, logLabel: 'getDashboardData');
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

  /// Current schedule-ride screen filter (daily, weekly, monthly). Used when refreshing after manage-ride.
  final RxString scheduleRideFilter = 'daily'.obs;

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
      showApiError(e, logLabel: 'getTrips');
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
      showApiError(e, logLabel: 'manageRide');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh logbook trips with current filter
  Future<void> refreshLogbookTrips({String? filter}) async {
    // Use provided filter or current selected filter
    final filterToUse = filter ?? selectedFilter.value;
    await getLogbookTrips(filter: filterToUse);
  }

  /// Fetch logbook trips (history) for the logged-in driver
  Future<void> getLogbookTrips({String? filter}) async {
    try {
      final parentId = BaseHelper.currentUser.value.roleData?.id;

      if (parentId == null) {
        logbookTripsState.value = ErrorState('Parent ID not found');
        return;
      }

      logbookTripsState.value = LoadingState();

      // Update selected filter if provided
      if (filter != null && filter.isNotEmpty) {
        selectedFilter.value = filter;
      }

      final queryParams = <String, dynamic>{'parentId': parentId};

      // Use selectedFilter from controller (or provided filter)
      final filterToUse = filter ?? selectedFilter.value;
      if (filterToUse.isNotEmpty) {
        queryParams['filterType'] = filterToUse.toLowerCase();
        queryParams['presigned'] = true;
      }

      final response = await apiService.fetchData(
        '/trips/history',
        query: queryParams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        log('Logbook trips response: $data');

        List<TripModel> tripsList = [];

        if (data is Map<String, dynamic>) {
          // Handle different response formats
          if (data['data'] != null) {
            if (data['data'] is List) {
              tripsList = (data['data'] as List)
                  .map(
                    (item) => TripModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
            } else if (data['data'] is Map<String, dynamic> &&
                (data['data'] as Map<String, dynamic>)['data'] != null) {
              final nestedData = (data['data'] as Map<String, dynamic>)['data'];
              if (nestedData is List) {
                tripsList = nestedData
                    .map(
                      (item) =>
                          TripModel.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();
              }
            }
          } else if (data is List) {
            tripsList = (data as List<dynamic>)
                .map((item) => TripModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
        }

        logbookTripsState.value = tripsList.isEmpty
            ? EmptyState(message: 'No trips found in logbook')
            : DataState(data: tripsList);
      } else {
        logbookTripsState.value = ErrorState(
          response.data['message'] ?? 'Failed to load logbook trips',
        );
        customToaster('Failed to load logbook trips', color: Colors.red);
      }
    } catch (e) {
      logbookTripsState.value = ExceptionState(Exception(e.toString()));
      showApiError(e, logLabel: 'getLogbookTrips');
    }
  }

  /// Fetch single trip detail by id for logbook detail screen
  Future<void> getTripDetail(String tripId) async {
    try {
      tripDetailState.value = LoadingState();
      final response = await apiService.fetchData('/trips/$tripId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        log('Trip detail response: $data');

        TripModel? trip;

        if (data is Map<String, dynamic>) {
          // Handle different response formats
          if (data['trip'] != null) {
            trip = TripModel.fromJson(data['trip'] as Map<String, dynamic>);
          } else if (data['data'] != null) {
            if (data['data'] is Map<String, dynamic>) {
              trip = TripModel.fromJson(data['data'] as Map<String, dynamic>);
            }
          } else {
            // Try parsing the whole response as a trip
            trip = TripModel.fromJson(data);
          }
        }

        if (trip != null) {
          tripDetailState.value = DataState(data: trip);
        } else {
          tripDetailState.value = ErrorState(
            'Invalid trip detail format from server',
          );
        }
      } else {
        tripDetailState.value = ErrorState(
          response.data['message'] ?? 'Failed to load trip detail',
        );
        customToaster('Failed to load trip detail', color: Colors.red);
      }
    } catch (e) {
      tripDetailState.value = ExceptionState(Exception(e.toString()));
      showApiError(e, logLabel: 'getTripDetail');
    }
  }
}
