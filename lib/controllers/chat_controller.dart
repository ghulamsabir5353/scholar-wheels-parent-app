import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/socket_initialize.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/models/message_model.dart';
import 'package:scholarwheels/models/room_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class ChatController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  SocketIntilized? socketService;

  final RxBool isLoading = false.obs;
  final Rx<ViewState<List<Chat>>> roomsState = Rx<ViewState<List<Chat>>>(
    LoadingState(),
  );

  // Messages state for a specific chat
  final RxBool isLoadingMessages = false.obs;
  final Rx<ViewState<List<MessageModel>>> messagesState =
      Rx<ViewState<List<MessageModel>>>(LoadingState());
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  // Current active chat
  String? currentChatId;

  // Typing indicator
  final RxBool isOtherUserTyping = false.obs;
  final RxString typingUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getChatRooms();
  }

  /// Get list of chat rooms
  Future<void> getChatRooms() async {
    try {
      roomsState.value = LoadingState();

      final response = await apiService.fetchData(AppConstants.chat);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Chat rooms response: ${response.data}');

        // Parse response.data['data'] to RoomDetail and extract chats list
        RoomDetail roomDetail = RoomDetail.fromJson(response.data['data']);
        List<Chat> rooms = roomDetail.chats ?? [];

        if (rooms.isEmpty) {
          roomsState.value = EmptyState();
        } else {
          roomsState.value = DataState(data: rooms);
        }
        log('Loaded ${rooms.length} chat rooms');
      }
    } catch (e) {
      roomsState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    }
  }

  /// Get messages for a specific chat
  Future<void> getMessages(String chatId) async {
    try {
      isLoadingMessages.value = true;
      messagesState.value = LoadingState();

      final endpoint = '${AppConstants.chat}/$chatId/messages';
      final response = await apiService.fetchData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Chat messages response: ${response.data}');

        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];
          final messagesList = data['messages'] as List<dynamic>? ?? [];

          final List<MessageModel> parsedMessages = messagesList
              .map(
                (json) => MessageModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          messages.value = parsedMessages;
          // Sort messages oldest to newest (index 0 = oldest, last index = newest)
          // With reverse: true ListView, newest messages appear at bottom
          messages.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return aTime.compareTo(bTime);
          });

          if (parsedMessages.isEmpty) {
            messagesState.value = EmptyState();
          } else {
            messagesState.value = DataState(data: messages);
          }
          log('Loaded ${messages.length} messages for chat $chatId');
        } else {
          messages.value = [];
          messagesState.value = EmptyState();
        }
      }
    } catch (e) {
      messagesState.value = ExceptionState(Exception(e.toString()));
      customToaster('Failed to load messages', color: Colors.red);
      log('error loading messages: $e');
    } finally {
      isLoadingMessages.value = false;
    }
  }

  /// Refresh chat rooms
  void refreshRooms() {
    getChatRooms();
  }

  /// Refresh messages for current chat
  void refreshMessages(String chatId) {
    getMessages(chatId);
  }

  /// Initialize socket connection (call after login)
  Future<void> initializeSocket() async {
    if (socketService == null) {
      socketService = Get.put(SocketIntilized(), permanent: true);
      await socketService!.initlizedsocket();
      _setupSocketListeners();
    } else if (socketService!.socket == null) {
      await socketService!.initlizedsocket();
      _setupSocketListeners();
    } else {
      _setupSocketListeners();
    }
  }

  /// Setup listeners for socket events
  void _setupSocketListeners() {
    if (socketService == null) return;

    // authenticated - Confirmation that socket is successfully authenticated
    socketService!.onAuthenticated = (data) {
      log('Socket authenticated successfully');
      customToaster('Connected to chat server', color: Colors.green);
    };

    // receiveMessage - New message received from another user
    socketService!.onReceiveMessage = (data) {
      log('Received message event: $data');
      try {
        // Data may have message nested or at top level, with possible chatDetails/timestamp
        final messageData = data['message'] ?? data;

        if (messageData is Map<String, dynamic>) {
          // Create a clean map excluding fields not in MessageModel
          final Map<String, dynamic> cleanMessageData = Map.from(messageData);
          cleanMessageData.remove('chatDetails');
          cleanMessageData.remove('timestamp');

          final message = MessageModel.fromJson(cleanMessageData);
          final messageChatId = message.chatId ?? data['chatId'];

          // Only add message if it belongs to current chat
          if (messageChatId == currentChatId) {
            // Check if message already exists
            final existingIndex = messages.indexWhere(
              (m) => m.id == message.id,
            );
            if (existingIndex == -1) {
              messages.add(message);
              messages.sort((a, b) {
                final aTime = a.createdAt ?? DateTime(1970);
                final bTime = b.createdAt ?? DateTime(1970);
                return aTime.compareTo(bTime);
              });
              // Trigger reactive update
              messages.refresh();
              // Update state if it was empty
              if (messagesState.value is EmptyState) {
                messagesState.value = DataState(data: messages);
              }
              log(
                'Added new received message to chat. Total: ${messages.length}',
              );
            }
          }
        }
      } catch (e) {
        log('Error parsing received message: $e');
      }
    };

    // messageSent - Confirmation that message was processed by server
    socketService!.onMessageSent = (data) {
      log('Message sent confirmation: $data');
      try {
        // The data contains message fields at top level plus chatDetails and timestamp
        // Extract only MessageModel fields (exclude chatDetails and timestamp)
        final messageId = data['_id'] ?? data['messageId'] ?? data['id'];

        if (messageId != null) {
          // Check if message already exists
          final existingIndex = messages.indexWhere((m) => m.id == messageId);

          if (existingIndex != -1) {
            // Update existing message delivery status
            messages[existingIndex] = messages[existingIndex].copyWith(
              delivered: data['delivered'] ?? true,
              deliveredAt: data['deliveredAt'] != null
                  ? DateTime.parse(data['deliveredAt'])
                  : DateTime.now(),
            );
            messages.refresh();
          } else {
            // Create a clean map with only MessageModel fields (exclude chatDetails, timestamp)
            final Map<String, dynamic> messageData = Map.from(data);
            messageData.remove(
              'chatDetails',
            ); // Remove fields not in MessageModel
            messageData.remove('timestamp');

            // Parse message from clean data
            final message = MessageModel.fromJson(messageData);
            final messageChatId = message.chatId ?? data['chatId'];

            // Only add if it belongs to current chat
            if (messageChatId == currentChatId) {
              messages.add(message);
              // Sort messages oldest to newest
              messages.sort((a, b) {
                final aTime = a.createdAt ?? DateTime(1970);
                final bTime = b.createdAt ?? DateTime(1970);
                return aTime.compareTo(bTime);
              });
              messages.refresh(); // Trigger reactive update
              log('Added new sent message to chat. Total: ${messages.length}');
            }
          }
        }
      } catch (e) {
        log('Error handling message sent confirmation: $e');
      }
    };

    // userTyping - Show typing indicator
    socketService!.onUserTyping = (data) {
      log('User typing event: $data');
      try {
        final chatId = data['chatId'];
        final userId = data['userId'];
        final isTyping = data['isTyping'] ?? false;

        // Only show typing if it's for current chat and not current user
        if (chatId == currentChatId &&
            userId != BaseHelper.currentUser.value.id) {
          isOtherUserTyping.value = isTyping;
          typingUserId.value = userId ?? '';
        }
      } catch (e) {
        log('Error handling typing indicator: $e');
      }
    };

    // messageRead - Update message status to "read"
    socketService!.onMessageRead = (data) {
      log('Message read event: $data');
      try {
        final messageId = data['messageId'] ?? data['_id'] ?? data['id'];
        if (messageId != null) {
          final index = messages.indexWhere((m) => m.id == messageId);
          if (index != -1) {
            messages[index] = messages[index].copyWith(
              read: true,
              readAt: DateTime.now(),
            );
            messages.refresh(); // Trigger reactive update
          }
        }
      } catch (e) {
        log('Error handling message read: $e');
      }
    };

    // error - Handle connection or authentication errors
    socketService!.onError = (error) {
      log('Socket error: $error');
      final errorMessage = error is Map
          ? (error['message'] ?? error.toString())
          : error.toString();
      customToaster('Connection error: $errorMessage', color: Colors.red);
    };
  }

  /// Join a chat room and subscribe to real-time events
  void joinChatRoom(String chatId) {
    currentChatId = chatId;
    socketService?.joinChat(chatId);
    log('Joined chat room: $chatId');
  }

  /// Leave the current chat room
  void leaveChatRoom() {
    if (currentChatId != null) {
      socketService?.leaveChat(currentChatId!);
      log('Left chat room: $currentChatId');
      currentChatId = null;
    }
  }

  /// Send a message via socket
  void sendMessageSocket({
    required String chatId,
    required String receiverId,
    required String message,
  }) {
    socketService?.sendMessage(
      chatId: chatId,
      receiverId: receiverId,
      message: message,
    );
    log('Sent message via socket to chat: $chatId');
  }

  /// Send typing indicator
  void sendTypingIndicator({required String chatId, required bool isTyping}) {
    socketService?.typing(chatId: chatId, isTyping: isTyping);
  }

  /// Mark a message as read
  void markMessageAsRead(String messageId) {
    socketService?.markAsRead(messageId);
    log('Marked message as read: $messageId');
  }

  @override
  void onClose() {
    leaveChatRoom();
    super.onClose();
  }
}
