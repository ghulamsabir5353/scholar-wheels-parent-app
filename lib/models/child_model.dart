// To parse this JSON data, do
//
//     final childModel = childModelFromJson(jsonString);

import 'dart:convert';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/models/user_model.dart';

ChildModel childModelFromJson(String str) =>
    ChildModel.fromJson(json.decode(str));

String childModelToJson(ChildModel data) => json.encode(data.toJson());

class ChildModel {
  String? id;
  String? userId;
  String? parentId;
  String? name;
  int? age;
  String? school; // String school name
  String? primaryContactNumber;
  String? secondaryContactNumber;
  LocationData? pickUpAddress; // LocationData model or null
  LocationData? dropOffAddress; // LocationData model or null
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  UserDetail? user; // Child user
  Parent? parent; // Parent user

  // Helper getters to extract description from location data
  String? get schoolDescription => school;

  String? get pickUpAddressDescription => pickUpAddress?.description;

  String? get dropOffAddressDescription => dropOffAddress?.description;

  ChildModel({
    this.id,
    this.userId,
    this.parentId,
    this.name,
    this.age,
    this.school,
    this.primaryContactNumber,
    this.secondaryContactNumber,
    this.pickUpAddress,
    this.dropOffAddress,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.user,
    this.parent,
  });

  // Helper method to parse location data from JSON
  // Returns LocationData if it's a Map, null otherwise (handles String, null, or invalid types)
  static LocationData? _parseLocationData(dynamic json) {
    if (json == null) return null;
    // If it's a String, return null (location data must be a Map)
    if (json is String) return null;
    // Check if it's any type of Map (including _Map<String, dynamic>)
    if (json is Map) {
      try {
        // Convert to Map<String, dynamic> and parse into LocationData model
        final map = Map<String, dynamic>.from(json);
        return LocationData.fromJson(map);
      } catch (e) {
        // If parsing fails, return null
        return null;
      }
    }
    // For any other type (int, bool, etc.), return null
    return null;
  }

  ChildModel copyWith({
    String? id,
    String? userId,
    String? parentId,
    String? name,
    int? age,
    String? school,
    String? primaryContactNumber,
    String? secondaryContactNumber,
    LocationData? pickUpAddress,
    LocationData? dropOffAddress,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    UserDetail? user,
    Parent? parent,
  }) => ChildModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    parentId: parentId ?? this.parentId,
    name: name ?? this.name,
    age: age ?? this.age,
    school: school ?? this.school,
    primaryContactNumber: primaryContactNumber ?? this.primaryContactNumber,
    secondaryContactNumber:
        secondaryContactNumber ?? this.secondaryContactNumber,
    pickUpAddress: pickUpAddress ?? this.pickUpAddress,
    dropOffAddress: dropOffAddress ?? this.dropOffAddress,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,

    user: user ?? this.user,
    parent: parent ?? this.parent,
  );

  factory ChildModel.fromJson(Map<String, dynamic> json) => ChildModel(
    id: json["_id"],
    userId: json["userId"],
    parentId: json["parentId"],
    name: json["name"],
    age: json["age"],
    school: json["school"] is String
        ? json["school"]
        : (json["school"] is Map ? json["school"]["description"] : null),
    primaryContactNumber: json["primaryContactNumber"],
    secondaryContactNumber: json["secondaryContactNumber"],
    pickUpAddress: _parseLocationData(json["pickUpAddress"]),
    dropOffAddress: _parseLocationData(json["dropOffAddress"]),
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    user: json["user"] == null ? null : UserDetail.fromJson(json["user"]),
    parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "parentId": parentId,
    "name": name,
    "age": age,
    "school": school,
    "primaryContactNumber": primaryContactNumber,
    "secondaryContactNumber": secondaryContactNumber,
    "pickUpAddress": pickUpAddress?.toJson(),
    "dropOffAddress": dropOffAddress?.toJson(),
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "user": user?.toJson(),
    "parent": parent?.toJson(),
  };
}

class Parent {
  String? id;
  String? userId;
  String? address;
  String? city;
  String? postalCode;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  ParentUser? parentUser;

  Parent({
    this.id,
    this.userId,
    this.address,
    this.city,
    this.postalCode,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.parentUser,
  });

  Parent copyWith({
    String? id,
    String? userId,
    String? address,
    String? city,
    String? postalCode,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    ParentUser? parentUser,
  }) => Parent(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    address: address ?? this.address,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    parentUser: parentUser ?? this.parentUser,
  );

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
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
    parentUser: json["parentUser"] == null
        ? null
        : ParentUser.fromJson(json["parentUser"]),
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
    "parentUser": parentUser?.toJson(),
  };
}

class ParentUser {
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
  String? lastName;
  String? profileImage;

  ParentUser({
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
    this.lastName,
    this.profileImage,
  });

  ParentUser copyWith({
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
    String? lastName,
    String? profileImage,
  }) => ParentUser(
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
    lastName: lastName ?? this.lastName,
    profileImage: profileImage ?? this.profileImage,
  );

  factory ParentUser.fromJson(Map<String, dynamic> json) => ParentUser(
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
    lastName: json["lastName"],
    profileImage: json["profileImage"],
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
    "lastName": lastName,
    "profileImage": profileImage,
  };
}
