import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:scholarwheels/controllers/chat_controller.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/chat/widgets/chat_bubble.dart';
import 'package:scholarwheels/models/room_model.dart';
import 'package:scholarwheels/models/message_model.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/textStyle.dart';

class ChatRoomScreen extends StatefulWidget {
  static const route = '/chat-room-screen';
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _chatId;
  Chat? _chat;
  String? _receiverId;
  late ChatController _chatController;
  late String? _currentUserId;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chatController = Get.find<ChatController>();
    _currentUserId = BaseHelper.currentUser.value.id;

    // Get arguments passed from navigation
    final arguments = Get.arguments;
    _chat = arguments is Chat ? arguments : null;
    _chatId = _chat?.id ?? (arguments is Map ? arguments['chatId'] : null);

    // Get receiver ID
    if (_chat != null && _currentUserId != null) {
      _receiverId = _getReceiverId(_chat!, _currentUserId!);
    }

    // Fetch messages and join chat room when screen is built
    if (_chatId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Join the chat room for real-time updates (socket should already be initialized)
        _chatController.joinChatRoom(_chatId!);
        // Fetch existing messages
        _chatController.getMessages(_chatId!);
      });
    }

    // Mark messages as read when they become visible
    _messageController.addListener(_onMessageTextChanged);

    // Listen to messages state changes and scroll to bottom when new messages arrive
    _chatController.messagesState.listen((state) {
      if (state is DataState<List<MessageModel>> && state.data.isNotEmpty) {
        // Small delay to ensure ListView has updated
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      }
    });

    // Scroll to bottom after initial messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // With reverse: true, position 0.0 is at the bottom (where newest messages appear)
          // Use jumpTo for instant scroll when new messages arrive, animateTo for smooth initial scroll
          try {
            _scrollController.jumpTo(0.0);
          } catch (e) {
            // If jumpTo fails, try animateTo
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        }
      });
    }
  }

  void _onMessageTextChanged() {
    final text = _messageController.text;
    if (_chatId != null && text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      _chatController.sendTypingIndicator(chatId: _chatId!, isTyping: true);
    } else if (text.isEmpty && _isTyping) {
      _isTyping = false;
      _chatController.sendTypingIndicator(chatId: _chatId!, isTyping: false);
    }
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _chatId == null || _receiverId == null) {
      return;
    }

    // Send message via socket
    // The message will be added to the list via socket event (messageSent)
    // and auto-scroll will happen via the messages listener
    _chatController.sendMessageSocket(
      chatId: _chatId!,
      receiverId: _receiverId!,
      message: messageText,
    );

    // Clear text field
    _messageController.clear();

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      _chatController.sendTypingIndicator(chatId: _chatId!, isTyping: false);
    }
  }

  String? _getReceiverId(Chat chat, String currentUserId) {
    if (chat.participantDetails != null &&
        chat.participantDetails!.isNotEmpty) {
      // Find the participant who is not the current user
      for (final participant in chat.participantDetails!) {
        if (participant.id != currentUserId) {
          return participant.id;
        }
      }
    }
    return null;
  }

  String _getChatTitle() {
    if (_chat?.participantDetails != null &&
        _chat!.participantDetails!.isNotEmpty &&
        _currentUserId != null) {
      // Find the receiver (transport owner) - the participant who is not the current user
      ParticipantDetail? receiverParticipant;
      for (final participant in _chat!.participantDetails!) {
        if (participant.id != _currentUserId) {
          receiverParticipant = participant;
          break;
        }
      }

      // If we found the receiver, get their name
      if (receiverParticipant != null) {
        // Prefer business name if available
        if (receiverParticipant.businessName != null &&
            receiverParticipant.businessName!.isNotEmpty) {
          return receiverParticipant.businessName!;
        }

        // Otherwise, use first name and last name/surname
        final firstName = receiverParticipant.firstName ?? '';
        final lastName =
            receiverParticipant.lastName ?? receiverParticipant.surName ?? '';
        final fullName = '$firstName $lastName'.trim();
        if (fullName.isNotEmpty) {
          return fullName;
        }

        // Fallback to email if name is not available
        if (receiverParticipant.email != null &&
            receiverParticipant.email!.isNotEmpty) {
          return receiverParticipant.email!;
        }
      }

      // Fallback: use first participant if receiver not found
      final firstParticipant = _chat!.participantDetails!.first;
      if (firstParticipant.businessName != null &&
          firstParticipant.businessName!.isNotEmpty) {
        return firstParticipant.businessName!;
      }
      final name =
          '${firstParticipant.firstName ?? ''} ${firstParticipant.lastName ?? firstParticipant.surName ?? ''}'
              .trim();
      if (name.isNotEmpty) {
        return name;
      }
      if (firstParticipant.email != null &&
          firstParticipant.email!.isNotEmpty) {
        return firstParticipant.email!;
      }
    }
    return 'Chat';
  }

  @override
  void dispose() {
    // Leave chat room when screen is disposed
    if (_chatId != null) {
      _chatController.leaveChatRoom();
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        titleSpacing: 0,
        leading: backButton(
          onTap: () {
            // Leave chat room when navigating back
            if (_chatId != null) {
              _chatController.leaveChatRoom();
            }
            Get.back();
          },
        ),

        title: Text(
          _getChatTitle(),
          style: poppinFonts(
            fontSize: lg,
            color: AppColor.headingFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messagesState = _chatController.messagesState.value;
              final messages = _chatController.messages;

              if (messagesState is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (messagesState is EmptyState ||
                  (messagesState is DataState<List<MessageModel>> &&
                      messagesState.data.isEmpty)) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.chat_bubble_outline_rounded,
                      //   size: 64.w,
                      //   color: AppColor.textLightBlackColor4A4A4A.withOpacity(0.5),
                      // ),
                      SpaceHelper(h: 16.h),
                      Text(
                        'No message found',
                        style: poppinFonts(
                          fontSize: base,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                      ),
                      SpaceHelper(h: 4.h),
                      Text(
                        'Start the conversation by sending a message',
                        style: poppinFonts(
                          fontSize: sm,
                          color: AppColor.textLightBlackColor4A4A4A.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (messagesState is ExceptionState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load messages',
                        style: poppinFonts(fontSize: base, color: Colors.red),
                      ),
                      SpaceHelper(h: 8.h),
                      ElevatedButton(
                        onPressed: () {
                          if (_chatId != null) {
                            _chatController.getMessages(_chatId!);
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse:
                          true, // Show messages from top to bottom (oldest at top, newest at bottom)
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.w,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        // With reverse: true, ListView shows items in reverse order
                        // Index 0 appears at bottom, last index appears at top
                        // Messages are sorted oldest to newest: [oldest, ..., newest]
                        // So we reverse the index to show newest at bottom, oldest at top
                        final reversedIndex = messages.length - 1 - index;
                        final message = messages[reversedIndex];
                        final isSent = message.senderId == _currentUserId;

                        // Mark message as read when visible (if not sent by current user)
                        if (!isSent &&
                            message.read != true &&
                            message.id != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _chatController.markMessageAsRead(message.id!);
                          });
                        }

                        return ChatBubble(message: message, isSent: isSent);
                      },
                    ),
                  ),
                  // Typing indicator
                  Obx(() {
                    if (_chatController.isOtherUserTyping.value) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'typing...',
                          style: poppinFonts(
                            fontSize: xs,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ).copyWith(fontStyle: FontStyle.italic),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              );
            }),
          ),
          SpaceHelper(h: 12.w),
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColor.bgGrayD9D8D8, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColor.cardBorderColorGrey,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          onChanged: (_) => _onMessageTextChanged(),
                          onSubmitted: (_) => _sendMessage(),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                            hintStyle: poppinFonts(
                              fontSize: sm,
                              color: AppColor.gray,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: AppColor.primary,
                      ),
                      child: SvgPicture.asset('assets/images/svg/send.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
