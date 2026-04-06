import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scholarwheels/models/subscription_invoice_model.dart';
import 'package:scholarwheels/models/user_subscription_me_model.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class BillingController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final RxBool isLoadingInvoices = false.obs;
  final RxBool isLoadingMySubscription = false.obs;
  final RxBool isCancelling = false.obs;
  final RxList<SubscriptionInvoice> invoices = <SubscriptionInvoice>[].obs;
  final Rx<UserSubscriptionMeResponse?> mySubscription =
      Rx<UserSubscriptionMeResponse?>(null);

  @override
  void onReady() {
    super.onReady();
    fetchMySubscription();
    fetchInvoices();
  }

  /// GET /usersubscription/me - call when screen opens and when user returns from browser
  Future<void> fetchMySubscription() async {
    try {
      isLoadingMySubscription.value = true;
      final response = await apiService.fetchData(
        AppConstants.userSubscriptionMe,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final parsed = UserSubscriptionMeResponse.fromJson(data);
          mySubscription.value = parsed;
          BaseHelper.mySubscription.value = parsed;
        } else {
          final empty = UserSubscriptionMeResponse(
            hasActiveSubscription: false,
          );
          mySubscription.value = empty;
          BaseHelper.mySubscription.value = empty;
        }
      } else {
        final empty = UserSubscriptionMeResponse(hasActiveSubscription: false);
        mySubscription.value = empty;
        BaseHelper.mySubscription.value = empty;
      }
    } catch (e) {
      log('BillingController.fetchMySubscription: $e');
      if (e is ApiException && e.code == 401) {
        // Session already cleared by handleDioError; do not set "no subscription"
        // or splash will open subscription plans instead of login.
        return;
      }
      showApiError(e, logLabel: 'fetchMySubscription');
      final empty = UserSubscriptionMeResponse(hasActiveSubscription: false);
      mySubscription.value = empty;
      BaseHelper.mySubscription.value = empty;
    } finally {
      isLoadingMySubscription.value = false;
    }
  }

  /// GET /subscription-invoice/
  Future<void> fetchInvoices() async {
    try {
      isLoadingInvoices.value = true;
      final response = await apiService.fetchData(
        AppConstants.subscriptionInvoice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['invoices'] != null) {
          final list = (data['invoices'] as List)
              .map(
                (e) => SubscriptionInvoice.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          invoices.assignAll(list);
        } else {
          invoices.clear();
        }
      } else {
        invoices.clear();
      }
    } catch (e) {
      log('BillingController.fetchInvoices: $e');
      showApiError(e, logLabel: 'fetchInvoices');
      invoices.clear();
    } finally {
      isLoadingInvoices.value = false;
    }
  }

  /// POST /usersubscription/cancel with body { "reason": "..." }
  Future<bool> cancelSubscription({required String reason}) async {
    try {
      isCancelling.value = true;
      final response = await apiService.createData(
        AppConstants.userSubscriptionCancel,
        {'reason': reason},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['cancelUrl'] != null) {
          final cancelUrl = data['cancelUrl'] as String?;
          if (cancelUrl != null && cancelUrl.isNotEmpty) {
            try {
              await launchUrl(
                Uri.parse(cancelUrl),
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {
              log('BillingController.cancelSubscription launchUrl: $e');
            }
          }
        }
        await fetchMySubscription();
        return true;
      } else {
        final msg = response.data is Map
            ? (response.data['message'] ?? 'Failed to cancel subscription')
            : 'Failed to cancel subscription';
        customToaster(msg.toString(), color: Colors.red);
        return false;
      }
    } catch (e) {
      log('BillingController.cancelSubscription: $e');
      showApiError(e, logLabel: 'cancelSubscription');
      return false;
    } finally {
      isCancelling.value = false;
    }
  }
}
