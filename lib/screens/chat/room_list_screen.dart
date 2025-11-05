import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/chat_controller.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/room_model.dart';
import 'package:scholarwheels/screens/chat/widgets/room_card.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        title: Text(
          'Chat',
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(() {
        final state = chatController.roomsState.value;

        if (state is LoadingState) {
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.getChatRooms();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          final errorState = state as ErrorState;
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.getChatRooms();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
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
                        onPressed: () => chatController.getChatRooms(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ExceptionState) {
          final exceptionState = state as ExceptionState;
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.getChatRooms();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text(
                    'Exception: ${exceptionState.exception}',
                    style: poppinFonts(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

        if (state is EmptyState) {
          final emptyState = state as EmptyState;
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.getChatRooms();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80.sp,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                      SpaceHelper(h: 16.h),
                      Text(
                        emptyState.message,
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is DataState<List<Chat>>) {
          final dataState = state;
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.getChatRooms();
            },
            child: dataState.data.isEmpty
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 80.sp,
                              color: AppColor.textLightBlackColor4A4A4A,
                            ),
                            SpaceHelper(h: 16.h),
                            Text(
                              'No chat rooms available',
                              style: poppinFonts(
                                fontSize: base,
                                color: AppColor.textLightBlackColor4A4A4A,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                    children: dataState.data
                        .map(
                          (room) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: RoomCard(room: room),
                          ),
                        )
                        .toList(),
                  ),
          );
        }

        return SizedBox.shrink();
      }),
    );
  }
}
