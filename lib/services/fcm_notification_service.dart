import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/chat_controller.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';

class FCMNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final ApiService _apiService = Get.find<ApiService>();
  static String? _fcmToken;

  /// Initialize FCM service
  static Future<void> initialize() async {
    try {
      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted notification permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('User granted provisional notification permission');
      } else {
        log('User declined or has not accepted notification permission');
        return;
      }

      // Get FCM token
      await _getFCMToken();

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps (when app is in background or terminated)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification (terminated state)
      RemoteMessage? initialMessage = await _firebaseMessaging
          .getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Handle token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        log('FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        _saveTokenToBackend(newToken);
      });

      log('FCM Notification Service initialized successfully');
    } catch (e) {
      log('Error initializing FCM: $e');
    }
  }

  /// Get FCM token
  static Future<String?> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        log('FCM Token: $_fcmToken');
        await _saveTokenToBackend(_fcmToken!);
      }
      return _fcmToken;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  /// Save FCM token to backend
  static Future<void> _saveTokenToBackend(String token) async {
    try {
      if (!BaseHelper.isLogin.value) {
        log('User not logged in, skipping token save');
        return;
      }

      final userId = BaseHelper.currentUser.value.id;
      if (userId == null || userId.isEmpty) {
        log('User ID not available, skipping token save');
        return;
      }

      // Determine platform
      String platform;
      if (GetPlatform.isAndroid) {
        platform = 'android';
      } else if (GetPlatform.isIOS) {
        platform = 'ios';
      } else {
        platform = 'web';
      }

      // Register token endpoint - POST /user/fcm-token/register
      final endpoint = 'user/fcm-token/register';
      final response = await _apiService.createData(endpoint, {
        'fcmToken': token,
        'platform': platform,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('FCM token registered to backend successfully');
      } else {
        log('Failed to register FCM token: ${response.statusCode}');
      }
    } catch (e) {
      log('Error registering FCM token to backend: $e');
    }
  }

  /// Handle foreground messages (when app is open)
  static void _handleForegroundMessage(RemoteMessage message) {
    log('Received foreground message: ${message.messageId}');
    log('Message data: ${message.data}');
    log('Message notification: ${message.notification?.title}');

    // Show local notification or update UI
    if (message.data['type'] == 'chat' || message.data['chatId'] != null) {
      _handleChatNotification(message, isForeground: true);
    }
  }

  /// Handle notification tap (when app is in background or terminated)
  static void _handleNotificationTap(RemoteMessage message) {
    log('Notification tapped: ${message.messageId}');
    log('Message data: ${message.data}');

    if (message.data['type'] == 'chat' || message.data['chatId'] != null) {
      _handleChatNotification(message, isForeground: false);
    }
  }

  /// Handle chat-specific notifications
  static void _handleChatNotification(
    RemoteMessage message, {
    required bool isForeground,
  }) {
    try {
      final chatId = message.data['chatId'];

      if (chatId == null) {
        log('Chat notification without chatId');
        return;
      }

      log('Handling chat notification for chatId: $chatId');

      // If app is in foreground, update chat controller
      if (isForeground) {
        // Check if we have chat controller
        if (Get.isRegistered<ChatController>()) {
          final chatController = Get.find<ChatController>();

          // If we're in the same chat room, don't show notification
          if (chatController.currentChatId == chatId) {
            log('Message received in current chat room, skipping notification');
            return;
          }

          // Update chat rooms list
          chatController.refreshRooms();
        }
      } else {
        // App was opened from notification - navigate to chat
        _navigateToChat(chatId);
      }
    } catch (e) {
      log('Error handling chat notification: $e');
    }
  }

  /// Navigate to chat room
  static void _navigateToChat(String chatId) {
    try {
      // Wait a bit for app to be ready
      Future.delayed(const Duration(milliseconds: 500), () {
        // Navigate to chat room
        Get.toNamed(ChatRoomScreen.route, arguments: {'chatId': chatId});
      });
    } catch (e) {
      log('Error navigating to chat: $e');
    }
  }

  /// Get current FCM token
  static String? get fcmToken => _fcmToken;

  /// Refresh FCM token
  static Future<String?> refreshToken() async {
    return await _getFCMToken();
  }

  /// Delete FCM token (on logout)
  static Future<void> deleteToken() async {
    try {
      if (!BaseHelper.isLogin.value) {
        log('User not logged in, skipping token removal');
        return;
      }

      // Get the current token before deleting
      final tokenToRemove = _fcmToken ?? 'any';

      // Remove token from backend - POST /user/fcm-token/remove
      final endpoint = 'user/fcm-token/remove';
      try {
        final response = await _apiService.createData(endpoint, {
          'fcmToken': tokenToRemove,
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          log('FCM token removed from backend successfully');
        } else {
          log('Failed to remove FCM token: ${response.statusCode}');
        }
      } catch (e) {
        log('Error removing FCM token from backend: $e');
      }

      // Also delete token from Firebase
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      log('FCM token deleted locally');
    } catch (e) {
      log('Error deleting FCM token: $e');
    }
  }
}
