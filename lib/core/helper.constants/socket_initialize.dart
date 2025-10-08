// // ignore_for_file: file_names, library_prefixes

// import 'package:get/get.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketIntilized {
//   IO.Socket? socket;
//   IO.Socket? chatSocket;

//   initlizedsocket() async {
//     socket = IO.io(
//         BaseHelper.socketBaseUrl(),
//         IO.OptionBuilder().setTransports(['websocket']).setQuery(
//             {"auth_token": BaseHelper.user.value.userId}).build());
//     chatSocket = IO.io(
//       '${BaseHelper.socketBaseUrl()}/chatRoom',
//     );

// // Connect to the socket
//     // if (socket?.connected ?? false) {
//     //   socket?.disconnect();
//     // }
//     socket?.connect();
//     socket?.onConnect((_) {
//       print('connect');
//     });
//     chatSocket?.connect();
//     chatSocket?.onConnect((_) {
//       chatSocket?.emit('joinRoom', BaseHelper.user.value.room?.id);
//       print('chatSocket');
//     });

//     //When an event recieved from server, data is added to the stream
//     // socket.on('event', (data) => streamSocket.addResponse);
//     socket?.onError((data) {
//       print('Error===>>$data');
//     });

//     socket?.onDisconnect((_) => print('disconnect'));
//     socket?.onConnectError((err) => print(err));
//     chatSocket?.onDisconnect((_) => print('disconnect'));
//     chatSocket?.onConnectError((err) => print(err));

//     socket?.on('updatePortion', (data) {
//       print(data);
//       if (data.containsKey('type')) {
//         if (data['type'] == 0) {
//           // if ((data.containsKey("food_id") && data.containsKey("Portion"))) {
//           //   Get.find<MainController>().updateLocalPortion(
//           //       foodId: data['food_id'],
//           //       portion: double.parse(data['Portion'].toString()));
//           // }
//         }
//         if (data['type'] == 1) {
//           // if (data.containsKey("food_id") && data.containsKey("Portion")) {
//           //   Get.find<MainController>().updateModerateLocalPortion(
//           //       foodId: data['food_id'],
//           //       portion: double.parse(data['Portion'].toString()));
//           // }
//         }
//       }
//     });

//     //
//     socket?.on('update_water_portion', (data) {
//       print('water_portion =>>>> $data');
//       if (data.containsKey("water_intake")) {
//         WaterIntake waterIntake = WaterIntake.fromJson(data['water_intake']);
//         Get.find<MainController>()
//             .updateWaterPortionLocal(waterIntake: waterIntake);
//       }
//     });

//     // update message list
//     socket?.on('updated_message_list', (data) {
//       BaseHelper.unreadCount(data['unreadCount']);
//       Get.find<ChatController>().updateMessageList(data);
//     });
//     socket?.on('block_updated', (data) {
//       if (BaseHelper.user.value.room?.id.toString() ==
//               data['chat_room_id'].toString() &&
//           BaseHelper.user.value.userId.toString() ==
//               data['customerId'].toString()) {
//         BaseHelper.user(BaseHelper.user.value.copyWith(
//             room: BaseHelper.user.value.room
//                 ?.copyWith(isBlock: data['isBlock'])));
//       }
//     });
//     socket?.on('message_delivered', (data) {
//       if (data is Map<String, dynamic>) {
//         final int messageId = data['message_id'];
//         final int userId = int.parse(data['user_id'].toString());

//         Get.find<ChatController>().updateMessageStatus(
//           messageId: messageId,
//           userId: userId,
//           newStatus: 1, // 1 = delivered
//         );
//       }
//     });

//     socket?.on('message_read', (data) {
//       if (data is Map<String, dynamic>) {
//         final int messageId = data['message_id'];
//         final int userId = int.parse(data['user_id'].toString());
//         Get.find<ChatController>().updateMessageStatus(
//           messageId: messageId,
//           userId: userId,
//           newStatus: 2, // 2 = read
//         );
//       }
//     });

//     chatSocket?.on('receiveMessage', (data) {
//       Message message = Message.fromJson(data);

//       if (message.chatRoomId == BaseHelper.user.value.room?.id) {
//         Get.find<ChatController>().messages.insert(0, message);
//         if (Get.currentRoute == ChatScreen.route) {
//           if (BaseHelper.user.value.userId != message.sender?.userId) {
//             Get.find<ChatController>().markAsSeen();
//           }
//         } else {
//           if (BaseHelper.user.value.userId != message.sender?.userId) {
//             BaseHelper.unreadCount(BaseHelper.unreadCount.value + 1);

//             socketIntilized.chatSocket?.emit('message_delivered', {
//               "message_id": message.messageId,
//               "user_id": BaseHelper.user.value.userId
//             });
//           }
//         }
//       }
//     });
//   }
// }
