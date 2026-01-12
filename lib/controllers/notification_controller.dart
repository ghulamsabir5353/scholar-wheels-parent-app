import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/models/notification_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class NotificationController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final ScrollController scrollController = ScrollController();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<ViewState<List<NotificationModel>>> notificationsState =
      Rx<ViewState<List<NotificationModel>>>(LoadingState());

  // Unread count
  final RxInt unreadCount = 0.obs;
  Timer? _unreadCountTimer;

  // Pagination
  int currentPage = 1;
  int limit = 20;
  bool hasMore = true;

  /// Getter to access notifications list from state
  List<NotificationModel> get notifications {
    final state = notificationsState.value;
    if (state is DataState<List<NotificationModel>>) {
      return state.data;
    }
    return [];
  }

  @override
  void onInit() {
    super.onInit();
    getNotifications();
    _setupScrollListener();
    getUnreadCount();
    _startUnreadCountTimer();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        // Load more when user scrolls to 80% of the list
        if (hasMore && !isLoadingMore.value) {
          loadMoreNotifications();
        }
      }
    });
  }

  /// Get notifications with pagination
  Future<void> getNotifications({bool refresh = false}) async {
    if (!BaseHelper.isLogin.value) return;
    try {
      if (refresh) {
        currentPage = 1;
        hasMore = true;
        notificationsState.value = LoadingState();
      } else {
        isLoading.value = true;
      }

      final endpoint =
          '${AppConstants.notification}?page=${currentPage}&limit=$limit';
      final response = await apiService.fetchData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Notifications response: ${response.data}');

        final notificationResponse = NotificationResponse.fromJson(
          response.data,
        );
        final notificationsList = notificationResponse.notifications ?? [];

        if (refresh) {
          notificationsState.value = notificationsList.isEmpty
              ? EmptyState()
              : DataState(data: notificationsList);
        } else {
          final currentState = notificationsState.value;
          if (currentState is DataState<List<NotificationModel>>) {
            final existingNotifications = currentState.data;
            final updatedNotifications = [
              ...existingNotifications,
              ...notificationsList,
            ];
            notificationsState.value = DataState(data: updatedNotifications);
          } else {
            notificationsState.value = notificationsList.isEmpty
                ? EmptyState()
                : DataState(data: notificationsList);
          }
        }

        // Update pagination info
        if (notificationResponse.pagination != null) {
          hasMore =
              notificationResponse.pagination!.currentPage! <
              notificationResponse.pagination!.totalPages!;
        } else {
          hasMore = notificationsList.length >= limit;
        }

        log(
          'Loaded ${notificationsList.length} notifications. Has more: $hasMore',
        );
      } else {
        notificationsState.value = ExceptionState(
          Exception(response.data['message'] ?? 'Failed to load notifications'),
        );
      }
    } catch (e) {
      log('Error loading notifications: $e');
      notificationsState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMoreNotifications() async {
    if (!hasMore || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final endpoint =
          '${AppConstants.notification}?page=${currentPage}&limit=$limit';
      final response = await apiService.fetchData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final notificationResponse = NotificationResponse.fromJson(
          response.data,
        );
        final newNotifications = notificationResponse.notifications ?? [];

        final currentState = notificationsState.value;
        if (currentState is DataState<List<NotificationModel>>) {
          final existingNotifications = currentState.data;
          final updatedNotifications = [
            ...existingNotifications,
            ...newNotifications,
          ];
          notificationsState.value = DataState(data: updatedNotifications);
        }

        // Update pagination info
        if (notificationResponse.pagination != null) {
          hasMore =
              notificationResponse.pagination!.currentPage! <
              notificationResponse.pagination!.totalPages!;
        } else {
          hasMore = newNotifications.length >= limit;
        }

        log(
          'Loaded ${newNotifications.length} more notifications. Has more: $hasMore',
        );
      }
    } catch (e) {
      log('Error loading more notifications: $e');
      currentPage--; // Revert page increment on error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final endpoint = '${AppConstants.notification}/read-all';
      final response = await apiService.patchData(endpoint, {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local state after successful API call
        final currentState = notificationsState.value;
        if (currentState is DataState<List<NotificationModel>>) {
          final notifications = currentState.data;
          final updatedNotifications = notifications.map((notification) {
            return notification.copyWith(read: true, readAt: DateTime.now());
          }).toList();
          notificationsState.value = DataState(data: updatedNotifications);
        }
        unreadCount.value = 0; // Update unread count
        customToaster('All notifications marked as read', color: Colors.green);
        log('All notifications marked as read successfully');
      } else {
        customToaster(
          response.data['message'] ?? 'Failed to mark all as read',
          color: Colors.red,
        );
      }
    } catch (e) {
      log('Error marking all as read: $e');
      customToaster('Failed to mark all as read', color: Colors.red);
    }
  }

  /// Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Implement mark as read API endpoint
      // For now, just update local state
      final currentState = notificationsState.value;
      if (currentState is DataState<List<NotificationModel>>) {
        final notifications = currentState.data;
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1 && notifications[index].read == false) {
          final updatedNotification = notifications[index].copyWith(
            read: true,
            readAt: DateTime.now(),
          );
          final updatedNotifications = List<NotificationModel>.from(
            notifications,
          );
          updatedNotifications[index] = updatedNotification;
          notificationsState.value = DataState(data: updatedNotifications);
          // Decrease unread count if notification was unread
          if (unreadCount.value > 0) {
            unreadCount.value--;
          }
        }
      }
    } catch (e) {
      log('Error marking notification as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      // Optimistically remove from UI
      final currentState = notificationsState.value;
      if (currentState is DataState<List<NotificationModel>>) {
        final notifications = currentState.data;
        final updatedNotifications = notifications
            .where((n) => n.id != notificationId)
            .toList();
        notificationsState.value = DataState(data: updatedNotifications);
      }

      final endpoint = '${AppConstants.notification}/$notificationId';
      final response = await apiService.deleteData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Notification $notificationId deleted successfully');
        customToaster('Notification deleted', color: Colors.green);

        // Update unread count if deleted notification was unread
        final deletedNotification = notifications.firstWhere(
          (n) => n.id == notificationId,
          orElse: () => NotificationModel(),
        );
        if (deletedNotification.read == false && unreadCount.value > 0) {
          unreadCount.value--;
        }

        // If list becomes empty after deletion, show empty state
        final currentState = notificationsState.value;
        if (currentState is DataState<List<NotificationModel>>) {
          if (currentState.data.isEmpty) {
            notificationsState.value = EmptyState();
          }
        }
      } else {
        // Revert UI on error
        await getNotifications(refresh: true);
        customToaster(
          response.data['message'] ?? 'Failed to delete notification',
          color: Colors.red,
        );
      }
    } catch (e) {
      log('Error deleting notification: $e');
      // Revert UI on error
      await getNotifications(refresh: true);
      customToaster('Failed to delete notification', color: Colors.red);
    }
  }

  /// Get unread notification count
  Future<void> getUnreadCount() async {
    try {
      final endpoint = '${AppConstants.notification}/unread-count';
      final response = await apiService.fetchData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final count =
            response.data['count'] ?? response.data['unreadCount'] ?? 0;
        unreadCount.value = count is int
            ? count
            : (count is String ? int.tryParse(count) ?? 0 : 0);
        log('Unread count: ${unreadCount.value}');
      }
    } catch (e) {
      log('Error fetching unread count: $e');
      // Don't show error to user for background count updates
    }
  }

  /// Start timer to fetch unread count every 5 seconds
  void _startUnreadCountTimer() {
    _unreadCountTimer?.cancel();
    _unreadCountTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      getUnreadCount();
    });
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await getNotifications(refresh: true);
    // Also refresh unread count
    await getUnreadCount();
  }

  @override
  void onClose() {
    _unreadCountTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
