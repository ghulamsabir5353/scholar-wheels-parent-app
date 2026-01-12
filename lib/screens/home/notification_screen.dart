import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/notification_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/notification_model.dart';
import 'package:scholarwheels/services/api_state.dart';

class NotificationScreen extends StatelessWidget {
  static const route = '/notification';
  const NotificationScreen({super.key});

  void _showDeleteConfirmationDialog(
    BuildContext context,
    NotificationController controller,
    String notificationId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Notification',
            style: poppinFonts(fontSize: base, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to delete this notification?',
            style: poppinFonts(fontSize: sm),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancel',
                style: poppinFonts(
                  fontSize: sm,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.deleteNotification(notificationId);
              },
              child: Text(
                'Delete',
                style: poppinFonts(
                  fontSize: sm,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        centerTitle: false,
        title: Text(
          'Notification',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () => controller.markAllAsRead(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.black),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Mark All as Read",
                style: poppinFonts(color: AppColor.black, fontSize: xs),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.notificationsState.value;
        final notifications = controller.notifications;

        if (state is LoadingState && notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmptyState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80.sp,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
                SpaceHelper(h: 16.h),
                Text(
                  'No notifications yet',
                  style: poppinFonts(
                    fontSize: base,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ErrorState) {
          final errorState = state as ErrorState<List<NotificationModel>>;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
                SpaceHelper(h: 16.h),
                Text(
                  errorState.message,
                  style: poppinFonts(fontSize: base, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SpaceHelper(h: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshNotifications(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ExceptionState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80.sp, color: Colors.red),
                SpaceHelper(h: 16.h),
                Text(
                  'Something went wrong',
                  style: poppinFonts(fontSize: base, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SpaceHelper(h: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshNotifications(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80.sp,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
                SpaceHelper(h: 16.h),
                Text(
                  'No notifications yet',
                  style: poppinFonts(
                    fontSize: base,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshNotifications();
          },
          child: ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            itemCount: notifications.length + (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == notifications.length) {
                // Show loading indicator at the bottom when loading more
                return Obx(() {
                  if (controller.isLoadingMore.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                });
              }

              final notification = notifications[index];
              return _NotificationItem(
                notification: notification,
                onTap: () {
                  controller.markAsRead(notification.id ?? '');
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(
                    context,
                    controller,
                    notification.id ?? '',
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification.read ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: isRead ? AppColor.white : AppColor.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset("assets/images/png/bus-icon.png"),
                      ),
                      SpaceHelper(w: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title ?? 'Notification',
                              style: poppinFonts(
                                fontSize: sm,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // SpaceHelper(h: 4.h),
                            // Text(
                            //   notification.message ?? '',
                            //   style: poppinFonts(
                            //     fontSize: xs,
                            //     color: AppColor.textLightBlackColor4A4A4A,
                            //   ),
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            SpaceHelper(h: 4.h),
                            Text(
                              _formatTime(notification.createdAt),
                              style: poppinFonts(
                                fontSize: 10.sp,
                                color: AppColor.textLightBlackColor4A4A4A,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    "assets/images/svg/delete.svg",
                    width: 16.w,
                    height: 16.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
