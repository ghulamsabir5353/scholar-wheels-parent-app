import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/models/room_model.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';

import '../../../core/helper.constants/font_sized.dart';
import '../../../core/helper.constants/textStyle.dart';
import '../../../core/helper.widgets/space_helper.dart';

class RoomCard extends StatelessWidget {
  final Chat room;

  const RoomCard({super.key, required this.room});

  /// Get opponent (the other participant, not the current user)
  ParticipantDetail? _getOpponent() {
    if (room.participantDetails == null || room.participantDetails!.isEmpty) {
      return null;
    }

    final currentUserId = BaseHelper.currentUser.value.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      // If no current user ID, return first participant if available
      if (room.participantDetails!.isNotEmpty) {
        return room.participantDetails!.first;
      }
      return null;
    }

    // Find the participant who is NOT the current user
    for (var participant in room.participantDetails!) {
      if (participant.id != currentUserId) {
        return participant;
      }
    }

    // If all participants are the current user (shouldn't happen), return null
    // or first participant if list is not empty
    if (room.participantDetails!.isNotEmpty) {
      return room.participantDetails!.first;
    }
    return null;
  }

  /// Get initials for avatar
  String _getInitials() {
    final opponent = _getOpponent();
    if (opponent == null) {
      return 'C';
    }

    final name = '${opponent.firstName ?? ''} ${opponent.lastName ?? ''}'
        .trim();
    if (name.isNotEmpty) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length > 1) {
        final first = parts[0].isNotEmpty ? parts[0][0] : '';
        final second = parts[1].isNotEmpty ? parts[1][0] : '';
        if (first.isNotEmpty && second.isNotEmpty) {
          return '$first$second'.toUpperCase();
        }
        if (first.isNotEmpty) {
          return first.toUpperCase();
        }
      }
      if (name.isNotEmpty) {
        return name[0].toUpperCase();
      }
    }
    if (opponent.email != null && opponent.email!.isNotEmpty) {
      return opponent.email![0].toUpperCase();
    }
    return 'C';
  }

  /// Get chat title
  String _getChatTitle() {
    final opponent = _getOpponent();
    if (opponent == null) {
      return 'Chat';
    }

    // Priority: businessName > firstName + lastName > email
    if (opponent.businessName != null && opponent.businessName!.isNotEmpty) {
      return opponent.businessName!;
    }

    final name = '${opponent.firstName ?? ''} ${opponent.lastName ?? ''}'
        .trim();
    if (name.isNotEmpty) {
      return name;
    }

    if (opponent.email != null && opponent.email!.isNotEmpty) {
      return opponent.email!;
    }

    return 'Chat';
  }

  /// Format time as relative time (now, X minutes ago, X hours ago, X days ago)
  String _formatTime(String? time) {
    if (time == null) {
      return 'N/A';
    }

    DateTime? messageTime;

    // Handle both String and DateTime types
    if (time.isEmpty) {
      return 'N/A';
    }
    try {
      messageTime = DateTime.parse(time);
    } catch (e) {
      return 'N/A';
    }

    final now = DateTime.now();
    final difference = now.difference(messageTime);

    // Less than 1 minute ago
    if (difference.inMinutes < 1) {
      return 'now';
    }

    // Less than 1 hour ago
    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    // Less than 24 hours ago
    if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    // More than 24 hours ago
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: InkWell(
        onTap: () {
          Get.toNamed(ChatRoomScreen.route, arguments: room);
        },
        child: Card(
          elevation: 1,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.darkPrimary,
                  radius: 24,
                  child: Text(
                    _getInitials(),
                    style: poppinFonts(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SpaceHelper(w: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getChatTitle(),
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (room.contractId != null)
                        Text(
                          'Contract: ${room.contractDetails?.status}',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      if (room.lastMessage != null)
                        Text(
                          room.lastMessage ?? '',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (room.lastMessageAt != null)
                      Text(
                        _formatTime(room.lastMessageAt),
                        style: poppinFonts(
                          fontSize: xs,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                    if (room.unreadCount != null && room.unreadCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,

                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${room.unreadCount}',
                          style: poppinFonts(
                            color: AppColor.primary,
                            fontSize: sm,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
