import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/models/room_model.dart';
import 'package:scholarwheels/screens/chat/chat_room_screen.dart';

import '../../../core/helper.constants/font_sized.dart';
import '../../../core/helper.constants/textStyle.dart';
import '../../../core/helper.widgets/space_helper.dart';

class RoomCard extends StatelessWidget {
  final Chat room;

  const RoomCard({super.key, required this.room});

  /// Get initials for avatar
  String _getInitials() {
    if (room.participantDetails != null &&
        room.participantDetails!.isNotEmpty) {
      final firstParticipant = room.participantDetails!.first;
      final name =
          '${firstParticipant.firstName ?? ''} ${firstParticipant.lastName ?? ''}'
              .trim();
      if (name.isNotEmpty) {
        final parts = name.split(' ');
        if (parts.length > 1) {
          return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        }
        return name[0].toUpperCase();
      }
      if (firstParticipant.email != null &&
          firstParticipant.email!.isNotEmpty) {
        return firstParticipant.email![0].toUpperCase();
      }
    }
    return 'C';
  }

  /// Get chat title
  String _getChatTitle() {
    if (room.participantDetails != null &&
        room.participantDetails!.isNotEmpty) {
      final firstParticipant = room.participantDetails!.first;
      final name =
          '${firstParticipant.firstName ?? ''} ${firstParticipant.lastName ?? ''}'
              .trim();
      if (name.isNotEmpty) {
        return name;
      }
      if (firstParticipant.email != null &&
          firstParticipant.email!.isNotEmpty) {
        return firstParticipant.email!;
      }
      if (firstParticipant.businessName != null &&
          firstParticipant.businessName!.isNotEmpty) {
        return firstParticipant.businessName!;
      }
    }
    return 'Chat';
  }

  /// Format time
  String _formatTime(dynamic time) {
    // Handle time formatting if needed
    return 'now';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      Card(
                        color: AppColor.secondary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Text(
                            '${room.unreadCount}',
                            style: poppinFonts(color: AppColor.primary),
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
