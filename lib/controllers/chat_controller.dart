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

  /// Getter to access messages list from state
  List<MessageModel> get messages {
    final state = messagesState.value;
    if (state is DataState<List<MessageModel>>) {
      return state.data;
    }
    return [];
  }

  // Current active chat
  String? currentChatId;

  // Typing indicator
  final RxBool isOtherUserTyping = false.obs;
  final RxString typingUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getChatRooms();

    // Initialize socket connection if user is already logged in (app open case)
    if (BaseHelper.isLogin.value) {
      initializeSocket();
    }
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
          // Sort rooms by lastMessageAt (most recent first)
          _sortRoomsByLastMessage(rooms);
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

          // Sort messages oldest to newest (index 0 = oldest, last index = newest)
          // With reverse: true ListView, newest messages appear at bottom
          parsedMessages.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return aTime.compareTo(bTime);
          });

          if (parsedMessages.isEmpty) {
            messagesState.value = EmptyState();
          } else {
            messagesState.value = DataState(data: parsedMessages);
          }
          log('Loaded ${parsedMessages.length} messages for chat $chatId');
        } else {
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

  /// Sort rooms list by lastMessageAt (most recent first)
  void _sortRoomsByLastMessage(List<Chat> rooms) {
    rooms.sort((a, b) {
      DateTime? aTime;
      DateTime? bTime;

      // Parse lastMessageAt - it can be String (ISO8601) or DateTime
      if (a.lastMessageAt != null) {
        if (a.lastMessageAt is String) {
          try {
            aTime = DateTime.parse(a.lastMessageAt as String);
          } catch (e) {
            aTime = null;
          }
        } else if (a.lastMessageAt is DateTime) {
          aTime = a.lastMessageAt as DateTime;
        }
      }

      if (b.lastMessageAt != null) {
        if (b.lastMessageAt is String) {
          try {
            bTime = DateTime.parse(b.lastMessageAt as String);
          } catch (e) {
            bTime = null;
          }
        } else if (b.lastMessageAt is DateTime) {
          bTime = b.lastMessageAt as DateTime;
        }
      }

      // Sort descending (most recent first)
      // If both have times, compare them
      if (aTime != null && bTime != null) {
        return bTime.compareTo(aTime);
      }
      // If only one has time, prioritize it
      if (aTime != null) return -1;
      if (bTime != null) return 1;
      // If neither has time, maintain order
      return 0;
    });
  }

  /// Update chat room when a new message is received
  void _updateChatRoomForNewMessage({
    required String chatId,
    required String message,
    required DateTime messageAt,
    String? senderId,
    bool incrementUnreadCount = true,
  }) {
    try {
      final currentState = roomsState.value;
      if (currentState is DataState<List<Chat>>) {
        final rooms = currentState.data;
        final roomIndex = rooms.indexWhere((room) => room.id == chatId);

        if (roomIndex != -1) {
          // Found the chat room - update it
          final currentUnreadCount = rooms[roomIndex].unreadCount ?? 0;
          final updatedRoom = rooms[roomIndex].copyWith(
            lastMessage: message,
            lastMessageAt: messageAt.toIso8601String(),
            lastMessageSender: senderId,
            unreadCount: incrementUnreadCount
                ? currentUnreadCount + 1
                : currentUnreadCount,
            updatedAt: DateTime.now(),
          );

          // Create new list with updated room
          final updatedRooms = List<Chat>.from(rooms);
          updatedRooms[roomIndex] = updatedRoom;

          // Sort rooms by lastMessageAt (most recent first)
          _sortRoomsByLastMessage(updatedRooms);

          // Update state to trigger UI refresh
          roomsState.value = DataState(data: updatedRooms);
          log(
            'Updated chat room $chatId with new message${incrementUnreadCount ? ' and incremented unread count' : ''} and sorted rooms list',
          );
        } else {
          log('Chat room $chatId not found in rooms list');
        }
      }
    } catch (e) {
      log('Error updating chat room for new message: $e');
    }
  }

  /// Clear unread count for a specific chat room
  void _clearUnreadCountForChatRoom(String chatId) {
    try {
      final currentState = roomsState.value;
      if (currentState is DataState<List<Chat>>) {
        final rooms = currentState.data;
        final roomIndex = rooms.indexWhere((room) => room.id == chatId);

        if (roomIndex != -1 && (rooms[roomIndex].unreadCount ?? 0) > 0) {
          // Found the chat room and it has unread messages - clear the count
          final updatedRoom = rooms[roomIndex].copyWith(unreadCount: 0);

          // Create new list with updated room
          final updatedRooms = List<Chat>.from(rooms);
          updatedRooms[roomIndex] = updatedRoom;

          // Update state to trigger UI refresh
          roomsState.value = DataState(data: updatedRooms);
          log('Cleared unread count for chat room $chatId');
        }
      }
    } catch (e) {
      log('Error clearing unread count for chat room: $e');
    }
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
        final message = MessageModel.fromJson(data);
        final messageChatId = message.chatId ?? data['chatId'];

        if (messageChatId == null) {
          log('Received message without chatId');
          return;
        }

        // If message is for current chat room, add to messages list
        if (messageChatId == currentChatId) {
          final currentMessages = List<MessageModel>.from(messages);
          // Check if message already exists
          final existingIndex = currentMessages.indexWhere(
            (m) => m.id == message.id,
          );
          if (existingIndex == -1) {
            currentMessages.add(message);
            // Sort messages oldest to newest
            currentMessages.sort((a, b) {
              final aTime = a.createdAt ?? DateTime(1970);
              final bTime = b.createdAt ?? DateTime(1970);
              return aTime.compareTo(bTime);
            });
            // Always update state to DataState when we have messages
            messagesState.value = DataState(data: currentMessages);
            log(
              'Added new received message to chat. Total: ${currentMessages.length}',
            );
          }
          // Update last message info but don't increment unread count (we're in same room)
          _updateChatRoomForNewMessage(
            chatId: messageChatId,
            message: message.message ?? '',
            messageAt: message.createdAt ?? DateTime.now(),
            senderId: message.senderId,
            incrementUnreadCount: false,
          );
        } else {
          // Message is for a different chat room - update unread count
          _updateChatRoomForNewMessage(
            chatId: messageChatId,
            message: message.message ?? '',
            messageAt: message.createdAt ?? DateTime.now(),
            senderId: message.senderId,
            incrementUnreadCount: true,
          );
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
        final messageId = data['_id'];

        if (messageId != null) {
          final currentMessages = List<MessageModel>.from(messages);
          // Check if message already exists
          final existingIndex = currentMessages.indexWhere(
            (m) => m.id == messageId,
          );

          if (existingIndex != -1) {
            // Update existing message delivery status
            currentMessages[existingIndex] = currentMessages[existingIndex]
                .copyWith(
                  delivered: data['delivered'] ?? true,
                  deliveredAt: data['deliveredAt'] != null
                      ? DateTime.parse(data['deliveredAt'])
                      : DateTime.now(),
                );
            messagesState.value = DataState(data: currentMessages);
          } else {
            // Parse message from clean data
            final message = MessageModel.fromJson(data);
            final messageChatId = message.chatId ?? data['chatId'];

            // Only add if it belongs to current chat
            if (messageChatId == currentChatId) {
              currentMessages.add(message);
              // Sort messages oldest to newest
              currentMessages.sort((a, b) {
                final aTime = a.createdAt ?? DateTime(1970);
                final bTime = b.createdAt ?? DateTime(1970);
                return aTime.compareTo(bTime);
              });
              // Always update state to DataState when we have messages
              messagesState.value = DataState(data: currentMessages);
              log(
                'Added new sent message to chat. Total: ${currentMessages.length}',
              );
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
          final currentMessages = List<MessageModel>.from(messages);
          final index = currentMessages.indexWhere((m) => m.id == messageId);
          if (index != -1) {
            currentMessages[index] = currentMessages[index].copyWith(
              read: true,
              readAt: DateTime.now(),
            );
            messagesState.value = DataState(data: currentMessages);
          }

          // Clear unread count for current chat room when messages are read
          if (currentChatId != null) {
            _clearUnreadCountForChatRoom(currentChatId!);
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
    // Clear unread count when opening chat room
    _clearUnreadCountForChatRoom(chatId);
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
