import 'dart:convert';
import 'package:scholarwheels/models/license_doc_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/models/transport_owner_model.dart';
import 'package:scholarwheels/models/vehicle_model.dart';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
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
  TransportOwner? transportOwner;
  Parent? parent;
  Route? route;
  List<Child>? children;

  BookingModel({
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
    this.transportOwner,
    this.parent,
    this.route,
    this.children,
  });

  BookingModel copyWith({
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
    TransportOwner? transportOwner,
    Parent? parent,
    Route? route,
    List<Child>? children,
  }) => BookingModel(
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
    transportOwner: transportOwner ?? this.transportOwner,
    parent: parent ?? this.parent,
    route: route ?? this.route,
    children: children ?? this.children,
  );

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
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
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
    parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
    route: json["route"] == null ? null : Route.fromJson(json["route"]),
    children: json["children"] == null
        ? []
        : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
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
    "transportOwner": transportOwner?.toJson(),
    "parent": parent?.toJson(),
    "route": route?.toJson(),
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
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
  };
}

class DropOffPoint {
  String? placeId;
  String? description;
  Coordinates? coordinates;

  DropOffPoint({this.placeId, this.description, this.coordinates});

  DropOffPoint copyWith({
    String? placeId,
    String? description,
    Coordinates? coordinates,
  }) => DropOffPoint(
    placeId: placeId ?? this.placeId,
    description: description ?? this.description,
    coordinates: coordinates ?? this.coordinates,
  );

  factory DropOffPoint.fromJson(Map<String, dynamic> json) => DropOffPoint(
    placeId: json["placeId"],
    description: json["description"],
    coordinates: json["coordinates"] == null
        ? null
        : Coordinates.fromJson(json["coordinates"]),
  );

  Map<String, dynamic> toJson() => {
    "placeId": placeId,
    "description": description,
    "coordinates": coordinates?.toJson(),
  };
}

class Coordinates {
  String? type;
  List<double>? coordinates;

  Coordinates({this.type, this.coordinates});

  Coordinates copyWith({String? type, List<double>? coordinates}) =>
      Coordinates(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    type: json["type"],
    coordinates: json["coordinates"] == null
        ? []
        : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null
        ? []
        : List<dynamic>.from(coordinates!.map((x) => x)),
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
    "suburbName": suburbName,
    "dropOffPointName": dropOffPointName,
  };
}
