import 'package:scholarwheels/models/business_address_model.dart';

class MessageModel {
  String? id;
  String? chatId;
  String? senderId;
  String? receiverId;
  String? message;
  String? messageType;
  bool? read;
  dynamic readAt;
  bool? delivered;
  DateTime? deliveredAt;
  bool? isDeleted;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  SenderDetails? senderDetails;

  MessageModel({
    this.id,
    this.chatId,
    this.senderId,
    this.receiverId,
    this.message,
    this.messageType,
    this.read,
    this.readAt,
    this.delivered,
    this.deliveredAt,
    this.isDeleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.senderDetails,
  });

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? message,
    String? messageType,
    bool? read,
    dynamic readAt,
    bool? delivered,
    DateTime? deliveredAt,
    bool? isDeleted,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    SenderDetails? senderDetails,
  }) => MessageModel(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    message: message ?? this.message,
    messageType: messageType ?? this.messageType,
    read: read ?? this.read,
    readAt: readAt ?? this.readAt,
    delivered: delivered ?? this.delivered,
    deliveredAt: deliveredAt ?? this.deliveredAt,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt ?? this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    senderDetails: senderDetails ?? this.senderDetails,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["_id"],
    chatId: json["chatId"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    message: json["message"],
    messageType: json["messageType"],
    read: json["read"],
    readAt: json["readAt"],
    delivered: json["delivered"],
    deliveredAt: json["deliveredAt"] == null
        ? null
        : DateTime.parse(json["deliveredAt"]),
    isDeleted: json["isDeleted"],
    deletedAt: json["deletedAt"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    senderDetails: json["senderDetails"] == null
        ? null
        : SenderDetails.fromJson(json["senderDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "chatId": chatId,
    "senderId": senderId,
    "receiverId": receiverId,
    "message": message,
    "messageType": messageType,
    "read": read,
    "readAt": readAt,
    "delivered": delivered,
    "deliveredAt": deliveredAt?.toIso8601String(),
    "isDeleted": isDeleted,
    "deletedAt": deletedAt,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "senderDetails": senderDetails?.toJson(),
  };
}

class SenderDetails {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? role;
  BusinessAddress? businessAddress;
  String? businessName;
  String? surName;
  String? registrationNumber;

  SenderDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.role,
    this.businessAddress,
    this.businessName,
    this.surName,
    this.registrationNumber,
  });

  SenderDetails copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profileImage,
    String? role,
    BusinessAddress? businessAddress,
    String? businessName,
    String? surName,
    String? registrationNumber,
  }) => SenderDetails(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profileImage: profileImage ?? this.profileImage,
    role: role ?? this.role,
    businessAddress: businessAddress ?? this.businessAddress,
    businessName: businessName ?? this.businessName,
    surName: surName ?? this.surName,
    registrationNumber: registrationNumber ?? this.registrationNumber,
  );

  factory SenderDetails.fromJson(Map<String, dynamic> json) => SenderDetails(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    role: json["role"],
    businessAddress: json["businessAddress"] == null
        ? null
        : BusinessAddress.fromJson(json["businessAddress"]),
    businessName: json["businessName"],
    surName: json["surName"],
    registrationNumber: json["registrationNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "role": role,
    "businessAddress": businessAddress?.toJson(),
    "businessName": businessName,
    "surName": surName,
    "registrationNumber": registrationNumber,
  };
}
