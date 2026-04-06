// To parse this JSON data, do
//
//     final contractModel = contractModelFromJson(jsonString);

import 'dart:convert';

import 'package:scholarwheels/models/license_doc_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/models/trip_model.dart';
import 'package:scholarwheels/models/vehicle_model.dart';

ContractModel contractModelFromJson(String str) =>
    ContractModel.fromJson(json.decode(str));

String contractModelToJson(ContractModel data) => json.encode(data.toJson());

class ContractModel {
  String? id;
  String? contractId;
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
  dynamic paymentDate;
  dynamic paymentMethod;
  dynamic isTwoWay;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Booking? booking;
  TransportOwner? transportOwner;
  Parent? parent;
  Route? route;
  List<Child>? children;
  BillingHistory? billingHistory;

  ContractModel({
    this.id,
    this.contractId,
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
    this.paymentDate,
    this.paymentMethod,
    this.isTwoWay,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.booking,
    this.transportOwner,
    this.parent,
    this.route,
    this.children,
    this.billingHistory,
  });

  ContractModel copyWith({
    String? id,
    String? contractId,
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
    dynamic paymentDate,
    dynamic paymentMethod,
    dynamic isTwoWay,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Booking? booking,
    TransportOwner? transportOwner,
    Parent? parent,
    Route? route,
    List<Child>? children,
    BillingHistory? billingHistory,
  }) => ContractModel(
    id: id ?? this.id,
    contractId: contractId ?? this.contractId,
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
    paymentDate: paymentDate ?? this.paymentDate,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isTwoWay: isTwoWay ?? this.isTwoWay,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    booking: booking ?? this.booking,
    transportOwner: transportOwner ?? this.transportOwner,
    parent: parent ?? this.parent,
    route: route ?? this.route,
    children: children ?? this.children,
    billingHistory: billingHistory ?? this.billingHistory,
  );

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    id: json["_id"],
    contractId: json["contractId"],
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
    paymentDate: json["paymentDate"],
    paymentMethod: json["paymentMethod"],
    isTwoWay: json["isTwoWay"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
    parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
    route: json["route"] == null ? null : Route.fromJson(json["route"]),
    children: json["children"] == null
        ? []
        : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
    billingHistory: json["billingHistory"] == null
        ? null
        : BillingHistory.fromJson(json["billingHistory"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "contractId": contractId,
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
    "paymentDate": paymentDate,
    "paymentMethod": paymentMethod,
    "isTwoWay": isTwoWay,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "booking": booking?.toJson(),
    "transportOwner": transportOwner?.toJson(),
    "parent": parent?.toJson(),
    "route": route?.toJson(),
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
    "billingHistory": billingHistory?.toJson(),
  };
}

class BillingHistory {
  int? totalPayment;
  int? paidAmount;
  int? dueAmount;
  int? nextPayment;

  BillingHistory({
    this.totalPayment,
    this.paidAmount,
    this.dueAmount,
    this.nextPayment,
  });

  BillingHistory copyWith({
    int? totalPayment,
    int? paidAmount,
    int? dueAmount,
    int? nextPayment,
  }) => BillingHistory(
    totalPayment: totalPayment ?? this.totalPayment,
    paidAmount: paidAmount ?? this.paidAmount,
    dueAmount: dueAmount ?? this.dueAmount,
    nextPayment: nextPayment ?? this.nextPayment,
  );

  factory BillingHistory.fromJson(Map<String, dynamic> json) => BillingHistory(
    totalPayment: json["totalPayment"],
    paidAmount: json["paidAmount"],
    dueAmount: json["dueAmount"],
    nextPayment: json["nextPayment"],
  );

  Map<String, dynamic> toJson() => {
    "totalPayment": totalPayment,
    "paidAmount": paidAmount,
    "dueAmount": dueAmount,
    "nextPayment": nextPayment,
  };
}

class Booking {
  String? id;
  String? bookingId;
  String? transportOwnerId;
  String? parentId;
  String? routeId;
  List<String>? childIds;
  DateTime? startDate;
  DateTime? endDate;
  String? pickUpTime;
  String? knockOffTime;
  String? contractDuration;
  String? approveStatus;
  String? status;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Booking({
    this.id,
    this.bookingId,
    this.transportOwnerId,
    this.parentId,
    this.routeId,
    this.childIds,
    this.startDate,
    this.endDate,
    this.pickUpTime,
    this.knockOffTime,
    this.contractDuration,
    this.approveStatus,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Booking copyWith({
    String? id,
    String? bookingId,
    String? transportOwnerId,
    String? parentId,
    String? routeId,
    List<String>? childIds,
    DateTime? startDate,
    DateTime? endDate,
    String? pickUpTime,
    String? knockOffTime,
    String? contractDuration,
    String? approveStatus,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Booking(
    id: id ?? this.id,
    bookingId: bookingId ?? this.bookingId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    parentId: parentId ?? this.parentId,
    routeId: routeId ?? this.routeId,
    childIds: childIds ?? this.childIds,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    pickUpTime: pickUpTime ?? this.pickUpTime,
    knockOffTime: knockOffTime ?? this.knockOffTime,
    contractDuration: contractDuration ?? this.contractDuration,
    approveStatus: approveStatus ?? this.approveStatus,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["_id"],
    bookingId: json["bookingId"],
    transportOwnerId: json["transportOwnerId"],
    parentId: json["parentId"],
    routeId: json["routeId"],
    childIds: json["childIds"] == null
        ? []
        : List<String>.from(json["childIds"]!.map((x) => x)),
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    pickUpTime: json["pickUpTime"],
    knockOffTime: json["knockOffTime"],
    contractDuration: json["contractDuration"],
    approveStatus: json["approveStatus"],
    status: json["status"],
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
    "bookingId": bookingId,
    "transportOwnerId": transportOwnerId,
    "parentId": parentId,
    "routeId": routeId,
    "childIds": childIds == null
        ? []
        : List<dynamic>.from(childIds!.map((x) => x)),
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "pickUpTime": pickUpTime,
    "knockOffTime": knockOffTime,
    "contractDuration": contractDuration,
    "approveStatus": approveStatus,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
  int? v;
  ChildUser? user;
  String? contractId;

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
    this.v,
    this.user,
    this.contractId,
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
    int? v,
    ChildUser? user,
    String? contractId,
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
    v: v ?? this.v,
    user: user ?? this.user,
    contractId: contractId ?? this.contractId,
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
    v: json["__v"],
    user: json["user"] == null ? null : ChildUser.fromJson(json["user"]),
    contractId: json["contractId"],
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
    "contractId": contractId,
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
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? phone;
  String? firstName;
  String? lastName;
  String? surName;

  ChildUser({
    this.id,
    this.email,
    this.role,
    this.status,
    this.profileImage,
    this.emailVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.phone,
    this.firstName,
    this.lastName,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? phone,
    String? firstName,
    String? lastName,
    String? surName,
  }) => ChildUser(
    id: id ?? this.id,
    email: email ?? this.email,
    role: role ?? this.role,
    status: status ?? this.status,
    profileImage: profileImage ?? this.profileImage,
    emailVerified: emailVerified ?? this.emailVerified,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    phone: phone ?? this.phone,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
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
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    phone: json["phone"],
    firstName: json["firstName"],
    lastName: json["lastName"],
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
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "phone": phone,
    "firstName": firstName,
    "lastName": lastName,
    "surName": surName,
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
  ParentUser? user;

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
    this.user,
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
    ParentUser? user,
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
    user: user ?? this.user,
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
    user: json["user"] == null ? null : ParentUser.fromJson(json["user"]),
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
    "user": user?.toJson(),
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
  String? profileImage;
  String? lastName;

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
    this.profileImage,
    this.lastName,
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
    String? profileImage,
    String? lastName,
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
    profileImage: profileImage ?? this.profileImage,
    lastName: lastName ?? this.lastName,
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
    profileImage: json["profileImage"],
    lastName: json["lastName"],
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
    "lastName": lastName,
  };
}

class Route {
  String? id;
  String? routeId;
  String? transportOwnerId;
  String? routeName;
  LocationData? suburb;
  LocationData? dropOffPoint;
  String? assignedVehicle;
  String? assignedDriver;
  String? status;
  int? estimatedDistance;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Vehicle? vehicle;
  Driver? driver;
  String? suburbName;
  String? dropOffPointName;
  Route({
    this.id,
    this.routeId,
    this.transportOwnerId,
    this.routeName,
    this.suburb,
    this.dropOffPoint,
    this.assignedVehicle,
    this.assignedDriver,
    this.status,
    this.estimatedDistance,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.vehicle,
    this.driver,
    this.suburbName,
    this.dropOffPointName,
  });

  Route copyWith({
    String? id,
    String? routeId,
    String? transportOwnerId,
    String? routeName,
    LocationData? suburb,
    LocationData? dropOffPoint,
    String? assignedVehicle,
    String? assignedDriver,
    String? status,
    int? estimatedDistance,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Vehicle? vehicle,
    Driver? driver,
    String? suburbName,
    String? dropOffPointName,
  }) => Route(
    id: id ?? this.id,
    routeId: routeId ?? this.routeId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    routeName: routeName ?? this.routeName,
    suburb: suburb ?? this.suburb,
    dropOffPoint: dropOffPoint ?? this.dropOffPoint,
    assignedVehicle: assignedVehicle ?? this.assignedVehicle,
    assignedDriver: assignedDriver ?? this.assignedDriver,
    status: status ?? this.status,
    estimatedDistance: estimatedDistance ?? this.estimatedDistance,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    vehicle: vehicle ?? this.vehicle,
    driver: driver ?? this.driver,
    suburbName: suburbName ?? this.suburbName,
    dropOffPointName: dropOffPointName ?? this.dropOffPointName,
  );

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    id: json["_id"],
    routeId: json["routeId"],
    transportOwnerId: json["transportOwnerId"],
    routeName: json["routeName"],
    suburb: json["suburb"] == null
        ? null
        : LocationData.fromJson(json["suburb"]),
    dropOffPoint: json["dropOffPoint"] == null
        ? null
        : LocationData.fromJson(json["dropOffPoint"]),
    assignedVehicle: json["assignedVehicle"],
    assignedDriver: json["assignedDriver"],
    status: json["status"],
    estimatedDistance: json["estimatedDistance"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    suburbName: json["suburbName"],
    dropOffPointName: json["dropOffPointName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "routeId": routeId,
    "transportOwnerId": transportOwnerId,
    "routeName": routeName,
    "suburb": suburb?.toJson(),
    "dropOffPoint": dropOffPoint?.toJson(),
    "assignedVehicle": assignedVehicle,
    "assignedDriver": assignedDriver,
    "status": status,
    "estimatedDistance": estimatedDistance,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "vehicle": vehicle?.toJson(),
    "driver": driver?.toJson(),
    "suburbName": suburbName,
    "dropOffPointName": dropOffPointName,
  };
}

class TransportOwner {
  String? id;
  String? userId;
  String? businessName;
  String? firstName;
  String? surName;
  String? registrationNumber;
  String? businessAddress;
  String? postalCode;
  String? city;
  List<LicenseDocument>? businessDocuments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isDeleted;
  String? businessType;
  String? transportLicense;
  bool? isIndependent;
  bool? isVerified;
  ChildUser? user;
  double? averageRating;
  double? totalRatings;

  TransportOwner({
    this.id,
    this.userId,
    this.businessName,
    this.firstName,
    this.surName,
    this.registrationNumber,
    this.businessAddress,
    this.postalCode,
    this.city,
    this.businessDocuments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isDeleted,
    this.businessType,
    this.transportLicense,
    this.isIndependent,
    this.isVerified,
    this.user,
    this.averageRating,
    this.totalRatings,
  });

  TransportOwner copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? firstName,
    String? surName,
    String? registrationNumber,
    String? businessAddress,
    String? postalCode,
    String? city,
    List<LicenseDocument>? businessDocuments,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    bool? isDeleted,
    String? businessType,
    String? transportLicense,
    bool? isIndependent,
    bool? isVerified,
    ChildUser? user,
    double? averageRating,
    double? totalRatings,
  }) => TransportOwner(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    businessName: businessName ?? this.businessName,
    firstName: firstName ?? this.firstName,
    surName: surName ?? this.surName,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    businessAddress: businessAddress ?? this.businessAddress,
    postalCode: postalCode ?? this.postalCode,
    city: city ?? this.city,
    businessDocuments: businessDocuments ?? this.businessDocuments,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    isDeleted: isDeleted ?? this.isDeleted,
    businessType: businessType ?? this.businessType,
    transportLicense: transportLicense ?? this.transportLicense,
    isIndependent: isIndependent ?? this.isIndependent,
    isVerified: isVerified ?? this.isVerified,
    user: user ?? this.user,
    averageRating: averageRating ?? this.averageRating,
    totalRatings: totalRatings ?? this.totalRatings,
  );

  factory TransportOwner.fromJson(Map<String, dynamic> json) => TransportOwner(
    id: json["_id"],
    userId: json["userId"],
    businessName: json["businessName"],
    firstName: json["firstName"],
    surName: json["surName"],
    registrationNumber: json["registrationNumber"],
    businessAddress: json["businessAddress"],
    postalCode: json["postalCode"],
    city: json["city"],
    businessDocuments: json["businessDocuments"] == null
        ? []
        : List<LicenseDocument>.from(
            json["businessDocuments"]!.map((x) => LicenseDocument.fromJson(x)),
          ),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isDeleted: json["isDeleted"],
    businessType: json["businessType"],
    transportLicense: json["transportLicense"],
    isIndependent: json["isIndependent"],
    isVerified: json["isVerified"],
    user: json["user"] == null ? null : ChildUser.fromJson(json["user"]),
    averageRating: json["averageRating"]?.toDouble() ?? 0,
    totalRatings: json["totalRatings"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "businessName": businessName,
    "firstName": firstName,
    "surName": surName,
    "registrationNumber": registrationNumber,
    "businessAddress": businessAddress,
    "postalCode": postalCode,
    "city": city,
    "businessDocuments": businessDocuments == null
        ? []
        : List<dynamic>.from(businessDocuments?.map((x) => x.toJson()) ?? []),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isDeleted": isDeleted,
    "businessType": businessType,
    "transportLicense": transportLicense,
    "isIndependent": isIndependent,
    "isVerified": isVerified,
    "user": user?.toJson(),
    "averageRating": averageRating,
    "totalRatings": totalRatings,
  };
}
