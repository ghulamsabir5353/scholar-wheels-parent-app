import 'package:scholarwheels/models/business_address_model.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/ride_model.dart';
import 'package:scholarwheels/models/transport_owner_model.dart';
import 'package:scholarwheels/models/user_model.dart';
import 'package:scholarwheels/models/vehicle_model.dart';

import 'license_doc_model.dart';

class DashboardModel {
  NextTrip? activeRides;

  /// Upcoming trips (list from API). UI shows a card per item.
  List<NextTrip>? nextTrip;
  List<ContractModel>? recentContracts;
  Counts? counts;

  DashboardModel({
    this.activeRides,
    this.nextTrip,
    this.recentContracts,
    this.counts,
  });

  DashboardModel copyWith({
    NextTrip? activeRides,
    List<NextTrip>? nextTrip,
    List<ContractModel>? recentContracts,
    Counts? counts,
  }) => DashboardModel(
    activeRides: activeRides ?? this.activeRides,
    nextTrip: nextTrip ?? this.nextTrip,
    recentContracts: recentContracts ?? this.recentContracts,
    counts: counts ?? this.counts,
  );

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    activeRides: json["activeRides"] == null
        ? null
        : json["activeRides"] is List
        ? (json["activeRides"] as List).isNotEmpty
              ? NextTrip.fromJson(
                  (json["activeRides"] as List)[0] as Map<String, dynamic>,
                )
              : null
        : NextTrip.fromJson(json["activeRides"] as Map<String, dynamic>),
    nextTrip: json["nextTrip"] == null
        ? null
        : json["nextTrip"] is List
        ? List<NextTrip>.from(
            (json["nextTrip"] as List).map(
              (x) => NextTrip.fromJson(x as Map<String, dynamic>),
            ),
          )
        : [NextTrip.fromJson(json["nextTrip"] as Map<String, dynamic>)],
    recentContracts: json["recentContracts"] == null
        ? []
        : List<ContractModel>.from(
            (json["recentContracts"] as List).map(
              (x) => ContractModel.fromJson(x as Map<String, dynamic>),
            ),
          ),
    counts: json["counts"] == null
        ? null
        : Counts.fromJson(json["counts"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "activeRides": activeRides?.toJson(),
    "nextTrip": nextTrip == null
        ? []
        : List<dynamic>.from(nextTrip!.map((x) => x.toJson())),
    "recentContracts": recentContracts == null
        ? []
        : List<dynamic>.from(recentContracts!.map((x) => x.toJson())),
    "counts": counts?.toJson(),
  };
}

class Counts {
  int? activeRides;
  int? requestedBookings;
  int? totalContracts;
  int? totalChildren;

  Counts({
    this.activeRides,
    this.requestedBookings,
    this.totalContracts,
    this.totalChildren,
  });

  Counts copyWith({
    int? activeRides,
    int? requestedBookings,
    int? totalContracts,
    int? totalChildren,
  }) => Counts(
    activeRides: activeRides ?? this.activeRides,
    requestedBookings: requestedBookings ?? this.requestedBookings,
    totalContracts: totalContracts ?? this.totalContracts,
    totalChildren: totalChildren ?? this.totalChildren,
  );

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
    activeRides: _toInt(json["activeRides"]),
    requestedBookings: _toInt(json["requestedBookings"]),
    totalContracts: _toInt(json["totalContracts"]),
    totalChildren: _toInt(json["totalChildren"]),
  );

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    "activeRides": activeRides,
    "requestedBookings": requestedBookings,
    "totalContracts": totalContracts,
    "totalChildren": totalChildren,
  };
}

class NextTrip {
  String? id;
  String? tripId;
  String? rideId;
  String? transportOwnerId;
  DateTime? serviceDate;
  String? assignedVehicle;
  String? assignedDriver;
  List<String>? contractIds;
  List<String>? parentIds;
  List<AssignedChild>? assignedChildren;
  String? dropOffTime;
  dynamic logbookId;
  dynamic scheduledPickupTime;
  String? status;
  bool? isDeleted;
  int? v;
  DateTime? createdAt;
  DateTime? updatedAt;
  TransportOwner? transportOwner;
  Ride? ride;
  Vehicle? vehicle;
  Driver? driver;
  List<Parent>? parents;

  /// GeoJSON-style snapshot from API; see [NextTripX.currentLocationLatLng].
  Map<String, dynamic>? currentLocation;
  NextTrip({
    this.id,
    this.tripId,
    this.rideId,
    this.transportOwnerId,
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
    this.v,
    this.createdAt,
    this.updatedAt,
    this.transportOwner,
    this.ride,
    this.vehicle,
    this.driver,
    this.parents,
    this.currentLocation,
  });

  NextTrip copyWith({
    String? id,
    String? tripId,
    String? rideId,
    String? transportOwnerId,
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
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
    TransportOwner? transportOwner,
    Ride? ride,
    Vehicle? vehicle,
    Driver? driver,
    List<Parent>? parents,
    Map<String, dynamic>? currentLocation,
  }) => NextTrip(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    rideId: rideId ?? this.rideId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
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
    v: v ?? this.v,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    transportOwner: transportOwner ?? this.transportOwner,
    ride: ride ?? this.ride,
    vehicle: vehicle ?? this.vehicle,
    driver: driver ?? this.driver,
    parents: parents ?? this.parents,
    currentLocation: currentLocation ?? this.currentLocation,
  );

  factory NextTrip.fromJson(Map<String, dynamic> json) => NextTrip(
    id: json["_id"],
    tripId: json["tripId"],
    rideId: json["rideId"],
    transportOwnerId: json["transportOwnerId"],
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
    v: json["__v"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
    ride: json["ride"] == null ? null : Ride.fromJson(json["ride"]),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    parents: json["parents"] == null
        ? []
        : List<Parent>.from(json["parents"]!.map((x) => Parent.fromJson(x))),
    currentLocation: json["currentLocation"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "tripId": tripId,
    "rideId": rideId,
    "transportOwnerId": transportOwnerId,
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
    "__v": v,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "transportOwner": transportOwner?.toJson(),
    "ride": ride?.toJson(),
    "vehicle": vehicle?.toJson(),
    "driver": driver?.toJson(),
    "parents": parents == null
        ? []
        : List<dynamic>.from(parents!.map((x) => x.toJson())),
    "currentLocation": currentLocation,
  };
}

/// Extension to check if a ride is scheduled for today (local date).
extension NextTripX on NextTrip {
  bool get isScheduledForToday {
    if (serviceDate == null) return false;
    final sd = serviceDate!.toLocal();
    final now = DateTime.now();
    return sd.year == now.year && sd.month == now.month && sd.day == now.day;
  }

  /// Driver snapshot from REST `currentLocation` (GeoJSON Point, [lng, lat]).
  ///
  /// Supported shapes:
  /// `{ "coordinates": { "type": "Point", "coordinates": [lng, lat] } }`
  /// `{ "type": "Point", "coordinates": [lng, lat] }`
  ({double latitude, double longitude})? get currentLocationLatLng {
    final root = currentLocation;
    if (root == null || root.isEmpty) return null;

    List<dynamic>? coordList;
    final inner = root['coordinates'];
    if (inner is Map) {
      final nested = inner['coordinates'];
      if (nested is List && nested.length >= 2) {
        coordList = nested;
      }
    } else if (inner is List && inner.length >= 2) {
      coordList = inner;
    }
    if (coordList == null && root['type'] == 'Point') {
      final c = root['coordinates'];
      if (c is List && c.length >= 2) coordList = c;
    }
    if (coordList == null || coordList.length < 2) return null;
    final a = coordList[0];
    final b = coordList[1];
    if (a is! num || b is! num) return null;
    final lng = a.toDouble();
    final lat = b.toDouble();
    if (!lat.isFinite || !lng.isFinite) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    return (latitude: lat, longitude: lng);
  }
}

class AssignedChild {
  String? childId;
  PickupAddress? pickupAddress;
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
    PickupAddress? pickupAddress,
    String? pickupStatus,
    String? pickupStatusUpdatedAt,
    String? dropOffStatus,
    String? dropOffStatusUpdatedAt,
    String? pickupTime,
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
        : PickupAddress.fromJson(json["pickupAddress"]),
    pickupStatus: json["pickupStatus"],
    dropOffStatus: json["dropOffStatus"],
    pickupTime: json["pickupTime"],
    dropOffTime: json["dropOffTime"],
    reason: json["reason"],
    pickupStatusUpdatedAt: json["pickupStatusUpdatedAt"],
    dropOffStatusUpdatedAt: json["dropOffStatusUpdatedAt"],
    id: json["_id"],
    child: json["child"] == null ? null : Child.fromJson(json["child"]),
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
  PickupAddress? pickUpAddress;
  PickupAddress? dropOffAddress;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  UserDetail? user; // UserDetail model

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
    PickupAddress? pickUpAddress,
    PickupAddress? dropOffAddress,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    UserDetail? user,
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
    school: json["school"] == null ? null : json["school"],
    primaryContactNumber: json["primaryContactNumber"],
    secondaryContactNumber: json["secondaryContactNumber"],
    pickUpAddress: json["pickUpAddress"] == null
        ? null
        : PickupAddress.fromJson(json["pickUpAddress"]),
    dropOffAddress: json["dropOffAddress"] == null
        ? null
        : PickupAddress.fromJson(json["dropOffAddress"]),
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    user: json["user"] == null
        ? null
        : UserDetail.fromJson(json["user"]), // UserDetail model
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

class PickupAddress {
  String? placeId;
  String? description;
  Coordinates? coordinates;

  PickupAddress({this.placeId, this.description, this.coordinates});

  PickupAddress copyWith({
    String? placeId,
    String? description,
    Coordinates? coordinates,
  }) => PickupAddress(
    placeId: placeId ?? this.placeId,
    description: description ?? this.description,
    coordinates: coordinates ?? this.coordinates,
  );

  factory PickupAddress.fromJson(Map<String, dynamic> json) => PickupAddress(
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

class Driver {
  String? id;
  String? userId;
  String? transportOwnerId;
  String? fullName;
  String? licenseNumber;
  String? gender;
  String? identifyNumber;
  DateTime? joiningDate;
  String? pdp;
  String? licenseCategory;
  String? contactNumber;
  DateTime? licenseExpiry;
  String? licenseId;
  List<LicenseDocument>? licenseDocuments;
  String? status;
  bool? isDeleted;
  bool? archived;
  List<dynamic>? assignedVehicles;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  UserDetail? user; // UserDetail model

  Driver({
    this.id,
    this.userId,
    this.transportOwnerId,
    this.fullName,
    this.licenseNumber,
    this.gender,
    this.identifyNumber,
    this.joiningDate,
    this.pdp,
    this.licenseCategory,
    this.contactNumber,
    this.licenseExpiry,
    this.licenseId,
    this.licenseDocuments,
    this.status,
    this.isDeleted,
    this.archived,
    this.assignedVehicles,
    this.createdAt,
    this.updatedAt,
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
    String? identifyNumber,
    DateTime? joiningDate,
    String? pdp,
    String? licenseCategory,
    String? contactNumber,
    DateTime? licenseExpiry,
    String? licenseId,
    List<LicenseDocument>? licenseDocuments,
    String? status,
    bool? isDeleted,
    bool? archived,
    List<dynamic>? assignedVehicles,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    UserDetail? user,
  }) => Driver(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    fullName: fullName ?? this.fullName,
    licenseNumber: licenseNumber ?? this.licenseNumber,
    gender: gender ?? this.gender,
    identifyNumber: identifyNumber ?? this.identifyNumber,
    joiningDate: joiningDate ?? this.joiningDate,
    pdp: pdp ?? this.pdp,
    licenseCategory: licenseCategory ?? this.licenseCategory,
    contactNumber: contactNumber ?? this.contactNumber,
    licenseExpiry: licenseExpiry ?? this.licenseExpiry,
    licenseId: licenseId ?? this.licenseId,
    licenseDocuments: licenseDocuments ?? this.licenseDocuments,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    archived: archived ?? this.archived,
    assignedVehicles: assignedVehicles ?? this.assignedVehicles,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
    identifyNumber: json["identifyNumber"],
    joiningDate: json["joiningDate"] == null
        ? null
        : DateTime.parse(json["joiningDate"]),
    pdp: json["pdp"],
    licenseCategory: json["licenseCategory"],
    contactNumber: json["contactNumber"],
    licenseExpiry: json["licenseExpiry"] == null
        ? null
        : DateTime.parse(json["licenseExpiry"]),
    licenseId: json["licenseId"],
    licenseDocuments: json["licenseDocuments"] == null
        ? []
        : List<LicenseDocument>.from(
            json["licenseDocuments"]!.map((x) => LicenseDocument.fromJson(x)),
          ),
    status: json["status"],
    isDeleted: json["isDeleted"],
    archived: json["archived"],
    assignedVehicles: json["assignedVehicles"] == null
        ? []
        : List<dynamic>.from(json["assignedVehicles"]!.map((x) => x)),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    user: json["user"] == null
        ? null
        : UserDetail.fromJson(json["user"]), // UserDetail model
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "transportOwnerId": transportOwnerId,
    "fullName": fullName,
    "licenseNumber": licenseNumber,
    "gender": gender,
    "identifyNumber": identifyNumber,
    "joiningDate": joiningDate?.toIso8601String(),
    "pdp": pdp,
    "licenseCategory": licenseCategory,
    "contactNumber": contactNumber,
    "licenseExpiry": licenseExpiry?.toIso8601String(),
    "licenseId": licenseId,
    "licenseDocuments": licenseDocuments == null
        ? []
        : List<dynamic>.from(licenseDocuments!.map((x) => x.toJson())),
    "status": status,
    "isDeleted": isDeleted,
    "archived": archived,
    "assignedVehicles": assignedVehicles == null
        ? []
        : List<dynamic>.from(assignedVehicles!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "user": user?.toJson(),
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
  UserDetail? user; // UserDetail model

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
    UserDetail? user,
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
    user: json["user"] == null
        ? null
        : UserDetail.fromJson(json["user"]), // UserDetail model
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
