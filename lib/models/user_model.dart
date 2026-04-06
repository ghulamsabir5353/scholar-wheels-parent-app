// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

import 'package:scholarwheels/models/subscription_model.dart';

UserDetail userDetailFromJson(String str) =>
    UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  String? id;
  String? email;
  String? firstName;
  String? surName;
  String? phone;
  String? role;
  String? status;
  bool? emailVerified;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? profileImage;
  String? userDetailId;
  String? profileImagePresignedUrl;
  RoleData? roleData;
  bool? activeSubscription;
  Subscription? subscription;
  DateTime? currentPeriodStart;
  DateTime? currentPeriodEnd;

  UserDetail({
    this.id,
    this.email,
    this.firstName,
    this.surName,
    this.phone,
    this.role,
    this.status,
    this.emailVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.profileImage,
    this.userDetailId,
    this.profileImagePresignedUrl,
    this.roleData,
    this.activeSubscription,
    this.subscription,
    this.currentPeriodStart,
    this.currentPeriodEnd,
  });

  UserDetail copyWith({
    String? id,
    String? email,
    String? firstName,
    String? surName,
    String? phone,
    String? role,
    String? status,
    bool? emailVerified,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? profileImage,
    String? userDetailId,
    String? profileImagePresignedUrl,
    RoleData? roleData,
    bool? activeSubscription,
    Subscription? subscription,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
  }) => UserDetail(
    id: id ?? this.id,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    surName: surName ?? this.surName,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    status: status ?? this.status,
    emailVerified: emailVerified ?? this.emailVerified,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    profileImage: profileImage ?? this.profileImage,
    userDetailId: userDetailId ?? this.userDetailId,
    profileImagePresignedUrl:
        profileImagePresignedUrl ?? this.profileImagePresignedUrl,
    roleData: roleData ?? this.roleData,
    activeSubscription: activeSubscription ?? this.activeSubscription,
    subscription: subscription ?? this.subscription,
    currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
    currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
  );

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["_id"],
    email: json["email"],
    firstName: json["firstName"],
    surName: json["surName"],
    phone: json["phone"],
    role: json["role"],
    status: json["status"],
    emailVerified: json["emailVerified"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    profileImage: json["profileImage"],
    userDetailId: json["id"],
    profileImagePresignedUrl: json["profileImagePresignedUrl"],
    roleData: json["roleData"] == null
        ? null
        : RoleData.fromJson(json["roleData"]),
    activeSubscription: json["activeSubscription"],
    subscription: json["subscription"] == null
        ? null
        : Subscription.fromJson(json["subscription"]),
    currentPeriodStart: json["currentPeriodStart"] == null
        ? null
        : DateTime.parse(json["currentPeriodStart"]),
    currentPeriodEnd: json["currentPeriodEnd"] == null
        ? null
        : DateTime.parse(json["currentPeriodEnd"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "firstName": firstName,
    "surName": surName,
    "phone": phone,
    "role": role,
    "status": status,
    "emailVerified": emailVerified,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "profileImage": profileImage,
    "id": userDetailId,
    "profileImagePresignedUrl": profileImagePresignedUrl,
    "roleData": roleData?.toJson(),
    "activeSubscription": activeSubscription,
    "subscription": subscription?.toJson(),
    "currentPeriodStart": currentPeriodStart?.toIso8601String(),
    "currentPeriodEnd": currentPeriodEnd?.toIso8601String(),
  };
}

class RoleData {
  String? id;
  String? userId;
  String? address;
  String? city;
  String? postalCode;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  RoleData({
    this.id,
    this.userId,
    this.address,
    this.city,
    this.postalCode,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  RoleData copyWith({
    String? id,
    String? userId,
    String? address,
    String? city,
    String? postalCode,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => RoleData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    address: address ?? this.address,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory RoleData.fromJson(Map<String, dynamic> json) => RoleData(
    id: json["_id"],
    userId: json["userId"],
    address: json["address"],
    city: json["city"],
    postalCode: json["postalCode"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "address": address,
    "city": city,
    "postalCode": postalCode,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

// "subscription": {

//         "plan": {
//           "_id": "6992ebb2e05f83db4dfa794c",
//           "name": "Plan 1",
//           "price": 10,
//           "currency": "ZAR",
//           "billingType": "monthly",
//           "durationInDays": 30,
//           "limits": {
//             "parent": {
//               "children": 2,
//               "bookings": 3
//             },
//             "transportOwner": {
//               "drivers": null,
//               "vehicles": null,
//               "routes": null,
//               "rides": null,
//               "contracts": null
//             }
//           },
//           "features": [
//             {
//               "text": "Can request booking",
//               "_id": "6992ebb2e05f83db4dfa794d"
//             },
//             {
//               "text": "Access chat",
//               "_id": "6992ebb2e05f83db4dfa794e"
//             }
//           ]
//         },
