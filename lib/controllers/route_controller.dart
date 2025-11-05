import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/models/route_model.dart';
import 'package:scholarwheels/models/popular_route_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class RouteController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final Rx<ViewState<List<RouteModel>>> routesState =
      Rx<ViewState<List<RouteModel>>>(LoadingState());
  final Rx<ViewState<List<PopularRouteModel>>> popularRoutesState =
      Rx<ViewState<List<PopularRouteModel>>>(LoadingState());

  @override
  void onInit() {
    super.onInit();
    // Don't auto-load routes on init, wait for user to click "Find Your Route"
    // But load popular routes for the main section
    fetchPopularRoutes();
  }

  /// Get list of routes
  Future<void> getRoutes({Map<String, dynamic>? query}) async {
    try {
      isLoading.value = true;
      routesState.value = LoadingState();
      final response = await apiService.fetchData(
        AppConstants.route,
        query: query,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Routes response: ${response.data}');

        // Parse routes from response.data['data']
        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];

          // Check if data is a list or contains a list
          List<dynamic> routesList;
          if (data is List) {
            routesList = data;
          } else if (data is Map && data['routes'] != null) {
            routesList = data['routes'] as List<dynamic>;
          } else {
            routesList = [];
          }

          if (routesList.isEmpty) {
            routesState.value = EmptyState(
              message: 'No routes available. Please try again later.',
            );
          } else {
            final List<RouteModel> parsedRoutes = routesList
                .map(
                  (json) => RouteModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

            routesState.value = DataState(data: parsedRoutes);
            log('Loaded ${parsedRoutes.length} routes');
          }
        } else {
          routesState.value = EmptyState(message: 'No routes found');
        }
      } else {
        routesState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch routes',
        );
        customToaster('Failed to load routes', color: Colors.red);
      }
    } catch (e) {
      routesState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error loading routes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh routes list
  void refreshRoutes() {
    getRoutes();
  }

  /// Get top 3 popular routes
  Future<void> fetchPopularRoutes() async {
    try {
      popularRoutesState.value = LoadingState();

      final response = await apiService.fetchData(AppConstants.popularRoutes);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final List<dynamic> list = response.data['data'] as List<dynamic>;
          if (list.isEmpty) {
            popularRoutesState.value = EmptyState(message: '');
          } else {
            final parsed = list
                .map(
                  (e) => PopularRouteModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
            popularRoutesState.value = DataState(data: parsed);
          }
        } else {
          popularRoutesState.value = EmptyState(message: '');
        }
      } else {
        popularRoutesState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch popular routes',
        );
      }
    } catch (e) {
      popularRoutesState.value = ExceptionState(Exception(e.toString()));
    }
  }

  /// Request booking for a route
  Future<void> requestBooking({
    required String parentId,
    required String transportOwnerId,
    required String routeId,
    required String childId,
    required DateTime startDate,
    required DateTime endDate,
    required String pickUpTime,
    required String knockOffTime,
    required int contractDuration,
  }) async {
    try {
      isLoading.value = true;

      final requestBody = {
        "parentId": parentId,
        "transportOwnerId": transportOwnerId,
        "routeId": routeId,
        "childIds": [childId],
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "pickUpTime": pickUpTime,
        "knockOffTime": knockOffTime,
        "contractDuration": contractDuration,
      };

      log('Request booking body: $requestBody');

      final response = await apiService.createData(
        AppConstants.requestBooking,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Booking request successful: ${response.data}');
        customToaster(
          response.data['message'] ?? 'Booking request sent successfully!',
          color: Colors.green,
        );
        return;
      } else {
        final errorMessage =
            response.data['message'] ?? 'Failed to send booking request';
        customToaster(errorMessage, color: Colors.red);
        throw Exception(errorMessage);
      }
    } catch (e) {
      log('Booking request error: $e');
      customToaster(
        'Something went wrong. Please try again.',
        color: Colors.red,
      );
      throw e;
    } finally {
      isLoading.value = false;
    }
  }
}
