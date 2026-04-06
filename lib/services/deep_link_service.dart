import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:flutter/material.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';

/// Service to generate deep links for payment success and cancel URLs
/// Uses native App Links (Android) and Universal Links (iOS)
/// This is the modern alternative to deprecated Firebase Dynamic Links
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  AppLinks? _appLinks;
  bool _initialized = false;

  /// Origin for generated payment URLs (must match verified App Link / Universal Link host).
  static String get baseDomain => AppConstants.appLinksBaseUrl;

  static bool _isHttpsAppLinkHost(String host) =>
      AppConstants.appLinksVerifiedHosts.contains(host);

  /// Initialize deep link service
  /// Call this in your main.dart or app initialization
  Future<void> initialize() async {
    if (_initialized) {
      log('Deep link service already initialized');
      return;
    }

    try {
      _appLinks = AppLinks();
      _initialized = true;

      log('Setting up deep link listeners...');
      log('Base domain: $baseDomain');

      // Handle deep links when app is running (foreground/background)
      _appLinks!.uriLinkStream.listen(
        (Uri uri) {
          log('Deep link received (app running): $uri');
          _handleDeepLink(uri);
        },
        onError: (error) {
          log('Error in deep link stream: $error');
        },
        cancelOnError: false,
      );

      // Handle deep link when app is opened from terminated state
      try {
        final initialUri = await _appLinks!.getInitialLink();
        if (initialUri != null) {
          log('Deep link received (app terminated): $initialUri');
          // Delay to ensure app is fully initialized
          Future.delayed(const Duration(milliseconds: 500), () {
            _handleDeepLink(initialUri);
          });
        } else {
          log('No initial deep link found');
        }
      } catch (e) {
        log('Error getting initial link: $e');
      }

      log('Deep link service initialized successfully');
    } catch (e) {
      log('Error initializing deep link service: $e');
      _initialized = false;
    }
  }

  /// Generate a deep link URL for payment success
  ///
  /// [subscriptionPlanId] - The subscription plan ID for context
  /// Returns a deep link URL that can be used as successUrl
  /// Uses HTTPS App Links/Universal Links - opens app directly when clicked
  static String generatePaymentSuccessLink({String? subscriptionPlanId}) {
    final String deepLink =
        '$baseDomain/payment/success?planId=${subscriptionPlanId ?? ''}';
    log('Payment success deep link generated: $deepLink');
    return deepLink;
  }

  /// Generate a deep link URL for payment cancellation
  ///
  /// [subscriptionPlanId] - The subscription plan ID for context
  /// Returns a deep link URL that can be used as cancelUrl
  /// Uses HTTPS App Links/Universal Links - opens app directly when clicked
  static String generatePaymentCancelLink({String? subscriptionPlanId}) {
    final String deepLink =
        '$baseDomain/payment/cancel?planId=${subscriptionPlanId ?? ''}';
    log('Payment cancel deep link generated: $deepLink');
    return deepLink;
  }

  /// Handle deep link routing
  void _handleDeepLink(Uri uri) {
    log('=== Deep Link Handler ===');
    log('Full URI: $uri');
    log('Scheme: ${uri.scheme}');
    log('Host: ${uri.host}');
    log('Path: ${uri.path}');
    log('Query: ${uri.query}');
    log('Query Parameters: ${uri.queryParameters}');

    // Handle both HTTPS (App Links/Universal Links) and custom scheme URLs
    String path = uri.path;

    // HTTPS App Links / Universal Links (host must be in AppConstants.appLinksVerifiedHosts)
    if (uri.scheme == 'https' && _isHttpsAppLinkHost(uri.host)) {
      path = uri.path;
      log('Handling HTTPS App Link/Universal Link: $path');
    }
    // For custom scheme (scholarwheels://payment/success?planId=xxx)
    else if (uri.scheme == 'scholarwheels') {
      // Custom scheme format: scholarwheels://payment/success?planId=xxx
      // Host is "payment", path is "/success" or "success"
      if (uri.host == 'payment') {
        // Ensure path starts with /payment/
        path = uri.path.startsWith('/')
            ? '/payment${uri.path}'
            : '/payment/${uri.path}';
      } else {
        // Fallback: use full path
        path = uri.path;
      }
      log('Handling custom scheme deep link: $path');
    }

    final Map<String, String> queryParams = uri.queryParameters;

    // Wait a bit to ensure GetX / Navigator are fully ready, then navigate
    Future.delayed(const Duration(milliseconds: 300), () {
      if (path.contains('/payment/success')) {
        final planId = queryParams['planId'];
        log('✅ Payment successful for plan: $planId');

        _navigateToSubscriptionPlans();

        // Show success message
        Future.delayed(const Duration(milliseconds: 500), () {
          customToaster('Payment successful!', color: Colors.green);
        });
      } else if (path.contains('/payment/cancel')) {
        final planId = queryParams['planId'];
        log('❌ Payment cancelled for plan: $planId');

        _navigateToSubscriptionPlans();

        // Show cancel message
        Future.delayed(const Duration(milliseconds: 500), () {
          customToaster('Payment cancelled', color: Colors.orange);
        });
      } else {
        log('⚠️ Unknown deep link path: $path');
      }
    });
  }

  /// Safely navigate to the subscription plans screen without hitting
  /// Navigator's `_debugLocked` assertion.
  void _navigateToSubscriptionPlans() {
    const targetRoute = SubscriptionPlansScreen.route;

    // Avoid pushing the same route again
    if (Get.currentRoute == targetRoute) {
      log('Already on subscription plans screen, skipping navigation');
      return;
    }

    // Schedule navigation for the next microtask to ensure the current
    // navigation frame is finished before we push a new route.
    Future.microtask(() {
      try {
        Get.offAllNamed(targetRoute);
        log('Navigated to subscription plans screen');
      } catch (e) {
        log('Error navigating to $targetRoute: $e');
      }
    });
  }

  /// Get the AppLinks instance (for advanced usage)
  AppLinks? get appLinks => _appLinks;

  /// Manually handle a deep link (useful for testing or manual triggers)
  void handleDeepLinkManually(Uri uri) {
    log('Manually handling deep link: $uri');
    _handleDeepLink(uri);
  }

  /// Check if deep link service is initialized
  bool get isInitialized => _initialized;
}
