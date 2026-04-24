// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/models/ride_model.dart';
import 'package:scholarwheels/models/route_model.dart';
import 'package:scholarwheels/models/transport_owner_model.dart';

import 'license_doc_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';

import 'vehicle_model.dart';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModel {
  String? id;
  String? rideId;
  String? routeId;
  String? transportOwnerId;
  String? rideType;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? serviceDate;
  String? assignedVehicle;
  String? assignedDriver;
  List<String>? contractIds;
  List<String>? parentIds;
  List<AssignedChild>? assignedChildren;

  String? logbookId;
  String? scheduledPickupTime;
  String? status;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? tripId;
  int? v;
  TransportOwner? transportOwner;
  List<Contract>? contracts;
  Ride? ride;
  RouteModel? route;
  List<Parent>? parents;
  Vehicle? vehicle;
  Driver? driver;
  List<Child>? children;
  String? pickupTime;
  String? dropOffTime;
  String? pickupStatusUpdatedAt;
  String? dropOffStatusUpdatedAt;
  int? totalChildren;
  //   "start_time" -> "2026-04-08T10:04:49.155Z"
  // 14 =
  // "end_time" -> "2026-04-08T12:08:06.575Z"
  DateTime? startTime;
  DateTime? endTime;

  TripModel({
    this.id,
    this.rideId,
    this.transportOwnerId,
    this.rideType,
    this.routeId,
    this.startDate,
    this.endDate,
    this.serviceDate,
    this.assignedVehicle,
    this.assignedDriver,
    this.contractIds,
    this.parentIds,
    this.assignedChildren,
    this.dropOffTime,
    this.logbookId,
    this.scheduledPickupTime,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.tripId,
    this.v,
    this.transportOwner,
    this.contracts,
    this.ride,
    this.route,
    this.parents,
    this.vehicle,
    this.driver,
    this.children,
    this.pickupTime,
    this.totalChildren,
    this.startTime,
    this.endTime,
    this.pickupStatusUpdatedAt,
    this.dropOffStatusUpdatedAt,
  });

  TripModel copyWith({
    String? id,
    String? rideId,
    String? transportOwnerId,
    String? rideType,
    String? routeId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? serviceDate,
    String? assignedVehicle,
    String? assignedDriver,
    List<String>? contractIds,
    List<String>? parentIds,
    List<AssignedChild>? assignedChildren,
    String? dropOffTime,
    dynamic logbookId,
    dynamic scheduledPickupTime,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? tripId,
    int? v,
    TransportOwner? transportOwner,
    List<Contract>? contracts,
    Ride? ride,
    RouteModel? route,
    List<Parent>? parents,
    Vehicle? vehicle,
    Driver? driver,
    List<Child>? children,
    String? pickupTime,
    int? totalChildren,
    DateTime? startTime,
    DateTime? endTime,
    String? pickupStatusUpdatedAt,
    String? dropOffStatusUpdatedAt,
  }) => TripModel(
    id: id ?? this.id,
    rideId: rideId ?? this.rideId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    rideType: rideType ?? this.rideType,
    routeId: routeId ?? this.routeId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    serviceDate: serviceDate ?? this.serviceDate,
    assignedVehicle: assignedVehicle ?? this.assignedVehicle,
    assignedDriver: assignedDriver ?? this.assignedDriver,
    contractIds: contractIds ?? this.contractIds,
    parentIds: parentIds ?? this.parentIds,
    assignedChildren: assignedChildren ?? this.assignedChildren,
    dropOffTime: dropOffTime ?? this.dropOffTime,
    logbookId: logbookId ?? this.logbookId,
    scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    tripId: tripId ?? this.tripId,
    v: v ?? this.v,
    transportOwner: transportOwner ?? this.transportOwner,
    contracts: contracts ?? this.contracts,
    ride: ride ?? this.ride,
    route: route ?? this.route,
    parents: parents ?? this.parents,
    vehicle: vehicle ?? this.vehicle,
    driver: driver ?? this.driver,
    children: children ?? this.children,
    pickupTime: pickupTime ?? this.pickupTime,
    totalChildren: totalChildren ?? this.totalChildren,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    pickupStatusUpdatedAt: pickupStatusUpdatedAt ?? this.pickupStatusUpdatedAt,
    dropOffStatusUpdatedAt:
        dropOffStatusUpdatedAt ?? this.dropOffStatusUpdatedAt,
  );

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    id: json["_id"],
    rideId: json["rideId"],
    transportOwnerId: json["transportOwnerId"],
    rideType: json["rideType"],
    routeId: json["routeId"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    serviceDate: json["serviceDate"] == null
        ? null
        : DateTime.parse(json["serviceDate"]),
    assignedVehicle: json["assignedVehicle"],
    assignedDriver: json["assignedDriver"],
    contractIds: json["contractIds"] == null
        ? []
        : List<String>.from(json["contractIds"]!.map((x) => x)),
    parentIds: json["parentIds"] == null
        ? []
        : List<String>.from(json["parentIds"]!.map((x) => x)),
    assignedChildren: json["assignedChildren"] == null
        ? []
        : List<AssignedChild>.from(
            json["assignedChildren"]!.map((x) => AssignedChild.fromJson(x)),
          ),
    dropOffTime: json["dropOffTime"],
    logbookId: json["logbookId"],
    scheduledPickupTime: json["scheduledPickupTime"],
    status: json["status"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    tripId: json["tripId"],
    v: json["__v"],
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
    contracts: json["contracts"] == null
        ? []
        : List<Contract>.from(
            json["contracts"]!.map((x) => Contract.fromJson(x)),
          ),
    ride: json["ride"] == null ? null : Ride.fromJson(json["ride"]),
    route: json["route"] == null ? null : RouteModel.fromJson(json["route"]),
    parents: json["parents"] == null
        ? []
        : List<Parent>.from(json["parents"]!.map((x) => Parent.fromJson(x))),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    children: json["children"] == null
        ? []
        : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
    pickupTime: json["pickupTime"],
    totalChildren: json["totalChildren"],
    startTime: json["start_time"] == null
        ? null
        : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    pickupStatusUpdatedAt: json["pickupStatusUpdatedAt"],
    dropOffStatusUpdatedAt: json["dropOffStatusUpdatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "rideId": rideId,
    "transportOwnerId": transportOwnerId,
    "rideType": rideType,
    "routeId": routeId,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "serviceDate": serviceDate?.toIso8601String(),
    "assignedVehicle": assignedVehicle,
    "assignedDriver": assignedDriver,
    "contractIds": contractIds == null
        ? []
        : List<dynamic>.from(contractIds!.map((x) => x)),
    "parentIds": parentIds == null
        ? []
        : List<dynamic>.from(parentIds!.map((x) => x)),
    "assignedChildren": assignedChildren == null
        ? []
        : List<dynamic>.from(assignedChildren!.map((x) => x.toJson())),
    "dropOffTime": dropOffTime,
    "logbookId": logbookId,
    "scheduledPickupTime": scheduledPickupTime,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "tripId": tripId,
    "__v": v,
    "transportOwner": transportOwner?.toJson(),
    "contracts": contracts == null
        ? []
        : List<dynamic>.from(contracts!.map((x) => x.toJson())),
    "ride": ride?.toJson(),
    "route": route?.toJson(),
    "parents": parents == null
        ? []
        : List<dynamic>.from(parents!.map((x) => x.toJson())),
    "vehicle": vehicle?.toJson(),
    "driver": driver?.toJson(),
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
    "pickupTime": pickupTime,
    "totalChildren": totalChildren,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "pickupStatusUpdatedAt": pickupStatusUpdatedAt,
    "dropOffStatusUpdatedAt": dropOffStatusUpdatedAt,
  };
}

class AssignedChild {
  String? childId;
  LocationData? pickupAddress;
  String? pickupStatus;
  String? dropOffStatus;
  String? pickupTime;
  String? pickupStatusUpdatedAt;
  String? dropOffStatusUpdatedAt;
  String? dropOffTime;
  dynamic reason;
  String? id;
  Child? child;

  AssignedChild({
    this.childId,
    this.pickupAddress,
    this.pickupStatus,
    this.dropOffStatus,
    this.pickupTime,
    this.pickupStatusUpdatedAt,
    this.dropOffStatusUpdatedAt,
    this.dropOffTime,
    this.reason,
    this.id,
    this.child,
  });

  AssignedChild copyWith({
    String? childId,
    LocationData? pickupAddress,
    String? pickupStatus,
    String? dropOffStatus,
    String? pickupTime,
    String? pickupStatusUpdatedAt,
    String? dropOffStatusUpdatedAt,
    String? dropOffTime,
    dynamic reason,
    String? id,
    Child? child,
  }) => AssignedChild(
    childId: childId ?? this.childId,
    pickupAddress: pickupAddress ?? this.pickupAddress,
    pickupStatus: pickupStatus ?? this.pickupStatus,
    dropOffStatus: dropOffStatus ?? this.dropOffStatus,
    pickupTime: pickupTime ?? this.pickupTime,
    dropOffTime: dropOffTime ?? this.dropOffTime,
    reason: reason ?? this.reason,
    id: id ?? this.id,
    child: child ?? this.child,
    pickupStatusUpdatedAt: pickupStatusUpdatedAt ?? this.pickupStatusUpdatedAt,
    dropOffStatusUpdatedAt:
        dropOffStatusUpdatedAt ?? this.dropOffStatusUpdatedAt,
  );

  factory AssignedChild.fromJson(Map<String, dynamic> json) => AssignedChild(
    childId: json["childId"],
    pickupAddress: json["pickupAddress"] == null
        ? null
        : LocationData.fromJson(json["pickupAddress"]),
    pickupStatus: json["pickupStatus"],
    dropOffStatus: json["dropOffStatus"],
    pickupTime: json["pickupTime"],
    dropOffTime: json["dropOffTime"],
    reason: json["reason"],
    id: json["_id"],
    child: json["child"] == null ? null : Child.fromJson(json["child"]),
    pickupStatusUpdatedAt: json["pickupStatusUpdatedAt"],
    dropOffStatusUpdatedAt: json["dropOffStatusUpdatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "childId": childId,
    "pickupAddress": pickupAddress?.toJson(),
    "pickupStatus": pickupStatus,
    "dropOffStatus": dropOffStatus,
    "pickupTime": pickupTime,
    "dropOffTime": dropOffTime,
    "reason": reason,
    "_id": id,
    "child": child?.toJson(),
    "pickupStatusUpdatedAt": pickupStatusUpdatedAt,
    "dropOffStatusUpdatedAt": dropOffStatusUpdatedAt,
  };
}

class Child {
  String? id;
  String? userId;
  String? parentId;
  String? name;
  int? age;
  String? school;
  String? primaryContactNumber;
  String? secondaryContactNumber;
  LocationData? pickUpAddress;
  LocationData? dropOffAddress;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? childId;
  int? v;
  ChildUser? user;

  Child({
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
    this.childId,
    this.v,
    this.user,
  });

  Child copyWith({
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
    String? childId,
    int? v,
    ChildUser? user,
  }) => Child(
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
    childId: childId ?? this.childId,
    v: v ?? this.v,
    user: user ?? this.user,
  );

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["_id"],
    userId: json["userId"],
    parentId: json["parentId"],
    name: json["name"],
    age: json["age"],
    school: json["school"],
    primaryContactNumber: json["primaryContactNumber"],
    secondaryContactNumber: json["secondaryContactNumber"],
    pickUpAddress: json["pickUpAddress"] == null
        ? null
        : LocationData.fromJson(json["pickUpAddress"]),
    dropOffAddress: json["dropOffAddress"] == null
        ? null
        : LocationData.fromJson(json["dropOffAddress"]),
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    childId: json["childId"],
    v: json["__v"],
    user: json["user"] == null ? null : ChildUser.fromJson(json["user"]),
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
    "childId": childId,
    "__v": v,
    "user": user?.toJson(),
  };
}

class ChildUser {
  String? id;
  String? email;
  String? role;
  String? status;
  String? profileImage;
  bool? emailVerified;
  bool? isDeleted;
  List<dynamic>? fcmTokens;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? phone;
  String? firstName;
  String? surName;

  ChildUser({
    this.id,
    this.email,
    this.role,
    this.status,
    this.profileImage,
    this.emailVerified,
    this.isDeleted,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.phone,
    this.firstName,
    this.surName,
  });

  ChildUser copyWith({
    String? id,
    String? email,
    String? role,
    String? status,
    String? profileImage,
    bool? emailVerified,
    bool? isDeleted,
    List<dynamic>? fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? phone,
    String? firstName,
    String? surName,
  }) => ChildUser(
    id: id ?? this.id,
    email: email ?? this.email,
    role: role ?? this.role,
    status: status ?? this.status,
    profileImage: profileImage ?? this.profileImage,
    emailVerified: emailVerified ?? this.emailVerified,
    isDeleted: isDeleted ?? this.isDeleted,
    fcmTokens: fcmTokens ?? this.fcmTokens,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    phone: phone ?? this.phone,
    firstName: firstName ?? this.firstName,
    surName: surName ?? this.surName,
  );

  factory ChildUser.fromJson(Map<String, dynamic> json) => ChildUser(
    id: json["_id"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
    profileImage: json["profileImage"],
    emailVerified: json["emailVerified"],
    isDeleted: json["isDeleted"],
    fcmTokens: json["fcmTokens"] == null
        ? []
        : List<dynamic>.from(json["fcmTokens"]!.map((x) => x)),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    phone: json["phone"],
    firstName: json["firstName"],
    surName: json["surName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "role": role,
    "status": status,
    "profileImage": profileImage,
    "emailVerified": emailVerified,
    "isDeleted": isDeleted,
    "fcmTokens": fcmTokens == null
        ? []
        : List<dynamic>.from(fcmTokens!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "phone": phone,
    "firstName": firstName,
    "surName": surName,
  };
}

class Contract {
  String? id;
  String? bookingId;
  String? parentId;
  List<String>? childIds;
  String? transportOwnerId;
  String? routeId;
  DateTime? startDate;
  DateTime? endDate;
  String? pickUpTime;
  String? knockOffTime;
  String? contractDuration;
  String? status;
  bool? isDeleted;
  int? monthlyPayment;
  int? totalPayment;
  String? paymentStatus;
  bool? isTwoWay;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? contractId;
  int? v;
  TransportOwner? transportOwner;
  RouteModel? route;
  List<Child>? children;

  Contract({
    this.id,
    this.bookingId,
    this.parentId,
    this.childIds,
    this.transportOwnerId,
    this.routeId,
    this.startDate,
    this.endDate,
    this.pickUpTime,
    this.knockOffTime,
    this.contractDuration,
    this.status,
    this.isDeleted,
    this.monthlyPayment,
    this.totalPayment,
    this.paymentStatus,
    this.isTwoWay,
    this.createdAt,
    this.updatedAt,
    this.contractId,
    this.v,
    this.transportOwner,
    this.route,
    this.children,
  });

  Contract copyWith({
    String? id,
    String? bookingId,
    String? parentId,
    List<String>? childIds,
    String? transportOwnerId,
    String? routeId,
    DateTime? startDate,
    DateTime? endDate,
    String? pickUpTime,
    String? knockOffTime,
    String? contractDuration,
    String? status,
    bool? isDeleted,
    int? monthlyPayment,
    int? totalPayment,
    String? paymentStatus,
    bool? isTwoWay,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contractId,
    int? v,
    TransportOwner? transportOwner,
    RouteModel? route,
    List<Child>? children,
  }) => Contract(
    id: id ?? this.id,
    bookingId: bookingId ?? this.bookingId,
    parentId: parentId ?? this.parentId,
    childIds: childIds ?? this.childIds,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    routeId: routeId ?? this.routeId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    pickUpTime: pickUpTime ?? this.pickUpTime,
    knockOffTime: knockOffTime ?? this.knockOffTime,
    contractDuration: contractDuration ?? this.contractDuration,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    monthlyPayment: monthlyPayment ?? this.monthlyPayment,
    totalPayment: totalPayment ?? this.totalPayment,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    isTwoWay: isTwoWay ?? this.isTwoWay,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    contractId: contractId ?? this.contractId,
    v: v ?? this.v,
    transportOwner: transportOwner ?? this.transportOwner,
    route: route ?? this.route,
    children: children ?? this.children,
  );

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
    id: json["_id"],
    bookingId: json["bookingId"],
    parentId: json["parentId"],
    childIds: json["childIds"] == null
        ? []
        : List<String>.from(json["childIds"]!.map((x) => x)),
    transportOwnerId: json["transportOwnerId"],
    routeId: json["routeId"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    pickUpTime: json["pickUpTime"],
    knockOffTime: json["knockOffTime"],
    contractDuration: json["contractDuration"],
    status: json["status"],
    isDeleted: json["isDeleted"],
    monthlyPayment: json["monthlyPayment"],
    totalPayment: json["totalPayment"],
    paymentStatus: json["paymentStatus"],
    isTwoWay: json["isTwoWay"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    contractId: json["contractId"],
    v: json["__v"],
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
    route: json["route"] == null ? null : RouteModel.fromJson(json["route"]),
    children: json["children"] == null
        ? []
        : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bookingId": bookingId,
    "parentId": parentId,
    "childIds": childIds == null
        ? []
        : List<dynamic>.from(childIds!.map((x) => x)),
    "transportOwnerId": transportOwnerId,
    "routeId": routeId,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "pickUpTime": pickUpTime,
    "knockOffTime": knockOffTime,
    "contractDuration": contractDuration,
    "status": status,
    "isDeleted": isDeleted,
    "monthlyPayment": monthlyPayment,
    "totalPayment": totalPayment,
    "paymentStatus": paymentStatus,
    "isTwoWay": isTwoWay,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "contractId": contractId,
    "__v": v,
    "transportOwner": transportOwner?.toJson(),
    "route": route?.toJson(),
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}

class Driver {
  String? id;
  String? userId;
  String? transportOwnerId;
  String? fullName;
  String? licenseNumber;
  String? gender;
  String? saIdentityNumber;
  DateTime? joiningDate;
  String? pdp;
  String? licenseCategory;
  String? contactNumber;
  DateTime? licenseExpiry;
  String? trafficRegisOrPassNumber;
  List<LicenseDocument>? licenseDocuments;
  List<AssignedVehicle>? assignedVehicles;
  String? status;
  bool? isDeleted;
  bool? archived;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driverId;
  int? v;
  ChildUser? user;

  Driver({
    this.id,
    this.userId,
    this.transportOwnerId,
    this.fullName,
    this.licenseNumber,
    this.gender,
    this.saIdentityNumber,
    this.joiningDate,
    this.pdp,
    this.licenseCategory,
    this.contactNumber,
    this.licenseExpiry,
    this.trafficRegisOrPassNumber,
    this.licenseDocuments,
    this.assignedVehicles,
    this.status,
    this.isDeleted,
    this.archived,
    this.createdAt,
    this.updatedAt,
    this.driverId,
    this.v,
    this.user,
  });

  Driver copyWith({
    String? id,
    String? userId,
    String? transportOwnerId,
    String? fullName,
    String? licenseNumber,
    String? gender,
    String? saIdentityNumber,
    DateTime? joiningDate,
    String? pdp,
    String? licenseCategory,
    String? contactNumber,
    DateTime? licenseExpiry,
    String? trafficRegisOrPassNumber,
    List<LicenseDocument>? licenseDocuments,
    List<AssignedVehicle>? assignedVehicles,
    String? status,
    bool? isDeleted,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? driverId,
    int? v,
    ChildUser? user,
  }) => Driver(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    fullName: fullName ?? this.fullName,
    licenseNumber: licenseNumber ?? this.licenseNumber,
    gender: gender ?? this.gender,
    saIdentityNumber: saIdentityNumber ?? this.saIdentityNumber,
    joiningDate: joiningDate ?? this.joiningDate,
    pdp: pdp ?? this.pdp,
    licenseCategory: licenseCategory ?? this.licenseCategory,
    contactNumber: contactNumber ?? this.contactNumber,
    licenseExpiry: licenseExpiry ?? this.licenseExpiry,
    trafficRegisOrPassNumber:
        trafficRegisOrPassNumber ?? this.trafficRegisOrPassNumber,
    licenseDocuments: licenseDocuments ?? this.licenseDocuments,
    assignedVehicles: assignedVehicles ?? this.assignedVehicles,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    driverId: driverId ?? this.driverId,
    v: v ?? this.v,
    user: user ?? this.user,
  );

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["_id"],
    userId: json["userId"],
    transportOwnerId: json["transportOwnerId"],
    fullName: json["fullName"],
    licenseNumber: json["licenseNumber"],
    gender: json["gender"],
    saIdentityNumber: json["SAIdentityNumber"],
    joiningDate: json["joiningDate"] == null
        ? null
        : DateTime.parse(json["joiningDate"]),
    pdp: json["pdp"],
    licenseCategory: json["licenseCategory"],
    contactNumber: json["contactNumber"],
    licenseExpiry: json["licenseExpiry"] == null
        ? null
        : DateTime.parse(json["licenseExpiry"]),
    trafficRegisOrPassNumber: json["trafficRegisOrPassNumber"],
    licenseDocuments: json["licenseDocuments"] == null
        ? []
        : List<LicenseDocument>.from(
            json["licenseDocuments"]!.map((x) => LicenseDocument.fromJson(x)),
          ),
    assignedVehicles: json["assignedVehicles"] == null
        ? []
        : List<AssignedVehicle>.from(
            json["assignedVehicles"]!.map((x) => AssignedVehicle.fromJson(x)),
          ),
    status: json["status"],
    isDeleted: json["isDeleted"],
    archived: json["archived"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    driverId: json["driverId"],
    v: json["__v"],
    user: json["user"] == null ? null : ChildUser.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "transportOwnerId": transportOwnerId,
    "fullName": fullName,
    "licenseNumber": licenseNumber,
    "gender": gender,
    "SAIdentityNumber": saIdentityNumber,
    "joiningDate":
        "${joiningDate!.year.toString().padLeft(4, '0')}-${joiningDate!.month.toString().padLeft(2, '0')}-${joiningDate!.day.toString().padLeft(2, '0')}",
    "pdp": pdp,
    "licenseCategory": licenseCategory,
    "contactNumber": contactNumber,
    "licenseExpiry": licenseExpiry?.toIso8601String(),
    "trafficRegisOrPassNumber": trafficRegisOrPassNumber,
    "licenseDocuments": licenseDocuments == null
        ? []
        : List<dynamic>.from(licenseDocuments!.map((x) => x.toJson())),
    "assignedVehicles": assignedVehicles == null
        ? []
        : List<dynamic>.from(assignedVehicles!.map((x) => x.toJson())),
    "status": status,
    "isDeleted": isDeleted,
    "archived": archived,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "driverId": driverId,
    "__v": v,
    "user": user?.toJson(),
  };
}

class AssignedVehicle {
  String? vehicleId;
  DateTime? assignedOn;
  String? id;

  AssignedVehicle({this.vehicleId, this.assignedOn, this.id});

  AssignedVehicle copyWith({
    String? vehicleId,
    DateTime? assignedOn,
    String? id,
  }) => AssignedVehicle(
    vehicleId: vehicleId ?? this.vehicleId,
    assignedOn: assignedOn ?? this.assignedOn,
    id: id ?? this.id,
  );

  factory AssignedVehicle.fromJson(Map<String, dynamic> json) =>
      AssignedVehicle(
        vehicleId: json["vehicleId"],
        assignedOn: json["assignedOn"] == null
            ? null
            : DateTime.parse(json["assignedOn"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "assignedOn": assignedOn?.toIso8601String(),
    "_id": id,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
