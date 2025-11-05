// ignore_for_file: file_names, library_prefixes

import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ConnectStatus { disconnected, connecting, connected, authenticated }

class SocketIntilized extends GetxService {
  IO.Socket? socket;

  // Callbacks for socket events
  Function(Map<String, dynamic>)? onAuthenticated;
  Function(Map<String, dynamic>)? onReceiveMessage;
  Function(Map<String, dynamic>)? onMessageSent;
  Function(Map<String, dynamic>)? onUserTyping;
  Function(Map<String, dynamic>)? onMessageRead;
  Function(dynamic)? onError;

  ConnectStatus _connectionStatus = ConnectStatus.disconnected;

  ConnectStatus get connectionStatus => _connectionStatus;

  /// Initialize socket connection and authenticate
  Future<void> initlizedsocket() async {
    socket = IO.io(
      AppConstants.baseUrlIp,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _connectionStatus = ConnectStatus.connecting;
    socket?.connect();

    socket?.onConnect((_) {
      print('Socket connected');
      _connectionStatus = ConnectStatus.connected;
      // Authenticate after connection
      authenticate();
    });

    socket?.onError((data) {
      print('Socket Error===>>$data');
      _connectionStatus = ConnectStatus.disconnected;
      onError?.call(data);
    });

    socket?.onDisconnect((_) {
      print('Socket disconnected');
      _connectionStatus = ConnectStatus.disconnected;
    });

    socket?.onConnectError((err) {
      print('Socket connect error: $err');
      _connectionStatus = ConnectStatus.disconnected;
      onError?.call(err);
    });

    // Listen to incoming socket events
    _setupEventListeners();
  }

  /// Setup listeners for all socket events
  void _setupEventListeners() {
    // authenticated - Confirmation that socket is successfully authenticated
    socket?.on('authenticated', (data) {
      print('Socket authenticated: $data');
      _connectionStatus = ConnectStatus.authenticated;
      if (data is Map<String, dynamic>) {
        onAuthenticated?.call(data);
      } else if (data != null) {
        onAuthenticated?.call({'data': data});
      } else {
        onAuthenticated?.call({});
      }
    });

    // receiveMessage - New message received from another user
    socket?.on('receiveMessage', (data) {
      print('Received message: $data');
      if (data is Map<String, dynamic>) {
        onReceiveMessage?.call(data);
      }
    });

    // messageSent - Confirmation that message was processed by server
    socket?.on('messageSent', (data) {
      print('Message sent confirmation: $data');
      if (data is Map<String, dynamic>) {
        onMessageSent?.call(data);
      }
    });

    // userTyping - Show typing indicator
    socket?.on('userTyping', (data) {
      print('User typing: $data');
      if (data is Map<String, dynamic>) {
        onUserTyping?.call(data);
      }
    });

    // messageRead - Update message status to "read"
    socket?.on('messageRead', (data) {
      print('Message read: $data');
      if (data is Map<String, dynamic>) {
        onMessageRead?.call(data);
      }
    });

    // error - Handle connection or authentication errors
    socket?.on('error', (data) {
      print('Socket error event: $data');
      onError?.call(data);
    });
  }

  /// Authenticate the socket connection with JWT token
  void authenticate() {
    final token = BaseHelper.accessToken.value;
    if (token.isNotEmpty) {
      socket?.emit('authenticate', {'token': token});
      print('Socket authenticated with token');
    } else {
      print('No token available for socket authentication');
    }
  }

  /// Join a chat room
  void joinChat(String chatId) {
    socket?.emit('joinChat', chatId);
    print('Joined chat: $chatId');
  }

  /// Leave a chat room
  void leaveChat(String chatId) {
    socket?.emit('leaveChat', chatId);
    print('Left chat: $chatId');
  }

  /// Send a message
  void sendMessage({
    required String chatId,
    required String receiverId,
    required String message,
  }) {
    socket?.emit('sendMessage', {
      'chatId': chatId,
      'receiverId': receiverId,
      'message': message,
    });
    print('Sent message to chat: $chatId');
  }

  /// Send typing indicator
  void typing({required String chatId, required bool isTyping}) {
    socket?.emit('typing', {'chatId': chatId, 'isTyping': isTyping});
  }

  /// Mark message as read
  void markAsRead(String messageId) {
    socket?.emit('markAsRead', {'messageId': messageId});
    print('Marked message as read: $messageId');
  }

  /// Disconnect socket
  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    print('Socket disconnected and disposed');
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
