import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/models/subscription.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/services/deep_link_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  /// True while requestPayment API is in progress (subscribe button).
  final RxBool isRequestingPayment = false.obs;
  final Rx<ViewState<List<Subscriptions>>> subscriptionsState =
      Rx<ViewState<List<Subscriptions>>>(LoadingState());

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlans();
  }

  /// Get list of subscription plans
  Future<void> getSubscriptionPlans({String role = 'parent'}) async {
    try {
      isLoading.value = true;
      subscriptionsState.value = LoadingState();

      final response = await apiService.fetchData(
        AppConstants.subscriptionPlans,
        query: {'role': role},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Subscription plans response: ${response.data}');

        final subscriptionsResponse = SubscriptionsResponse.fromJson(
          response.data,
        );
        final subscriptions = subscriptionsResponse.subscriptions ?? [];

        if (subscriptions.isEmpty) {
          subscriptionsState.value = EmptyState(
            message: 'No subscription plans available',
          );
        } else {
          subscriptionsState.value = DataState(data: subscriptions);
        }
      } else {
        subscriptionsState.value = ErrorState(
          'Failed to load subscription plans',
        );
        customToaster('Failed to load subscription plans', color: Colors.red);
      }
    } catch (e) {
      subscriptionsState.value = ErrorState(
        'Error loading subscription plans: ${e.toString()}',
      );
      showApiError(e, logLabel: 'getSubscriptionPlans');
    } finally {
      isLoading.value = false;
    }
  }

  /// Getter to access subscriptions list from state
  List<Subscriptions> get subscriptions {
    final state = subscriptionsState.value;
    if (state is DataState<List<Subscriptions>>) {
      return state.data;
    }
    return [];
  }

  /// Request payment for subscription
  Future<void> requestPayment({
    required String subscriptionPlanId,
    String? successUrl,
    String? cancelUrl,
    String platform = "mobile",
    String renewalType = "new",
  }) async {
    try {
      isRequestingPayment.value = true;

      // Generate deep links for success and cancel URLs
      final String generatedSuccessUrl =
          successUrl ??
          DeepLinkService.generatePaymentSuccessLink(
            subscriptionPlanId: subscriptionPlanId,
          );

      final String generatedCancelUrl =
          cancelUrl ??
          DeepLinkService.generatePaymentCancelLink(
            subscriptionPlanId: subscriptionPlanId,
          );

      final requestBody = {
        "subscriptionPlanId": subscriptionPlanId,
        "successUrl": generatedSuccessUrl,
        "cancelUrl": generatedCancelUrl,
        "platform": platform,
        "renewalType": renewalType,
      };

      log('Payment request body: $requestBody');
      log('Success URL: $generatedSuccessUrl');
      log('Cancel URL: $generatedCancelUrl');

      final response = await apiService.createData(
        AppConstants.subscriptionPaymentRequest,
        requestBody,
      );

      // Response structure:
      // 0 = "status" -> 200
      // 1 = "message" -> "Payment request created successfully"
      // 2 = "paymentData" -> Map (19 items)
      // 3 = "processUrl" -> "https://sandbox.payfast.co.za/eng/process"
      // 4 = "userSubscriptionId" -> "US12"
      // 5 = "mPaymentId" -> "SUB-1770196515112-bef889a9-e2d9-4978-a2fb-0861c06640a5"

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Payment request response: ${response.data}');
        print('Payment request response: ${response.data}');

        // Extract processUrl and paymentData from response
        final responseData = response.data;
        final String? processUrl = responseData['processUrl'] as String?;
        final Map<String, dynamic>? paymentData =
            responseData['paymentData'] as Map<String, dynamic>?;
        print('processUrl: $processUrl');
        print('paymentData=====>: $paymentData');
        if (processUrl != null && paymentData != null) {
          // Convert paymentData Map to query parameters
          final Uri paymentUri = Uri.parse(
            processUrl,
          ).replace(queryParameters: _convertMapToQueryParams(paymentData));

          log('Opening payment URL: $paymentUri');

          // Launch the payment URL with paymentData as query parameters
          final bool launched = await launchUrl(
            paymentUri,
            mode: LaunchMode.externalApplication,
          );

          if (launched) {
            customToaster(
              'Redirecting to payment gateway...',
              color: Colors.green,
            );
          } else {
            log('Failed to launch payment URL');
            customToaster('Failed to open payment gateway', color: Colors.red);
          }
        } else {
          log('Missing processUrl or paymentData in response');
          customToaster(
            'Payment request sent successfully',
            color: Colors.green,
          );
        }
      } else {
        log('Payment request failed: ${response.data}');
        print('Payment request failed: ${response.data}');
        customToaster('Failed to process payment request', color: Colors.red);
      }
    } catch (e) {
      showApiError(e, logLabel: 'requestPayment');
    } finally {
      isRequestingPayment.value = false;
    }
  }

  /// Convert a Map to query parameters (handles nested values)
  Map<String, String> _convertMapToQueryParams(Map<String, dynamic> data) {
    final Map<String, String> queryParams = {};

    data.forEach((key, value) {
      if (value != null) {
        // Convert value to string
        queryParams[key] = value.toString();
      }
    });

    return queryParams;
  }
}
