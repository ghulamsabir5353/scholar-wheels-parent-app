import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isSent});
  final MessageModel message;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSent
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 4.h),
          child: Builder(
            builder: (context) {
              return Container(
                constraints: BoxConstraints(
                  minWidth: context.width * 0.3,
                  maxWidth: context.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: isSent
                      ? AppColor.primary
                      : AppColor.recieverBubbleColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message ?? '',
                      style: poppinFonts(
                        fontSize: sm,

                        color: isSent ? Colors.white : AppColor.black,
                      ),
                    ),
                    SpaceHelper(h: 4.h),
                    Row(
                      mainAxisAlignment: isSent
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDateTime(message.createdAt),
                          style: poppinFonts(
                            fontSize: xs,
                            color: isSent
                                ? Colors.white70
                                : AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                        // Show read receipts for sent messages
                        if (isSent) ...[
                          SpaceHelper(w: 4.w),
                          Text(
                            message.read == true
                                ? '✓✓'
                                : (message.delivered == true ? '✓' : ''),
                            style: poppinFonts(
                              fontSize: 10.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Show time if it's today
      return DateFormat('h:mm a').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Show "Yesterday" if it's yesterday
      return 'Yesterday ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      // Show date and time for older messages
      return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    }
  }
}
