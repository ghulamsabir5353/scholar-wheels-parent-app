import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/user_model.dart';

class DashboardModel {
  NextTrip? activeRides;
  NextTrip? nextTrip;
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
    NextTrip? nextTrip,
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
              ? NextTrip.fromJson(json["activeRides"][0])
              : null
        : NextTrip.fromJson(json["activeRides"]),
    nextTrip: json["nextTrip"] == null
        ? null
        : NextTrip.fromJson(json["nextTrip"]),
    recentContracts: json["recentContracts"] == null
        ? []
        : List<ContractModel>.from(
            json["recentContracts"]!.map((x) => ContractModel.fromJson(x)),
          ),
    counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
  );

  Map<String, dynamic> toJson() => {
    "activeRides": activeRides?.toJson(),
    "nextTrip": nextTrip?.toJson(),
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
    activeRides: json["activeRides"],
    requestedBookings: json["requestedBookings"],
    totalContracts: json["totalContracts"],
    totalChildren: json["totalChildren"],
  );

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
  };
}

class AssignedChild {
  String? childId;
  PickupAddress? pickupAddress;
  String? pickupStatus;
  String? dropOffStatus;
  String? pickupTime;
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
    this.dropOffTime,
    this.reason,
    this.id,
    this.child,
  });

  AssignedChild copyWith({
    String? childId,
    PickupAddress? pickupAddress,
    String? pickupStatus,
    String? dropOffStatus,
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

class LicenseDocument {
  String? url;
  String? fileName;
  String? id;
  DateTime? uploadedAt;

  LicenseDocument({this.url, this.fileName, this.id, this.uploadedAt});

  LicenseDocument copyWith({
    String? url,
    String? fileName,
    String? id,
    DateTime? uploadedAt,
  }) => LicenseDocument(
    url: url ?? this.url,
    fileName: fileName ?? this.fileName,
    id: id ?? this.id,
    uploadedAt: uploadedAt ?? this.uploadedAt,
  );

  factory LicenseDocument.fromJson(Map<String, dynamic> json) =>
      LicenseDocument(
        url: json["url"],
        fileName: json["fileName"],
        id: json["_id"],
        uploadedAt: json["uploadedAt"] == null
            ? null
            : DateTime.parse(json["uploadedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "url": url,
    "fileName": fileName,
    "_id": id,
    "uploadedAt": uploadedAt?.toIso8601String(),
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

class Ride {
  String? id;
  String? rideId;
  String? transportOwnerId;
  List<String>? contractIds;
  List<String>? parentIds;
  String? rideType;
  DateTime? startDate;
  DateTime? endDate;
  String? assignedVehicle;
  String? assignedDriver;
  String? routeId;
  List<AssignedChild>? assignedChildren;
  String? dropOffTime;
  String? status;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Ride({
    this.id,
    this.rideId,
    this.transportOwnerId,
    this.contractIds,
    this.parentIds,
    this.rideType,
    this.startDate,
    this.endDate,
    this.assignedVehicle,
    this.assignedDriver,
    this.routeId,
    this.assignedChildren,
    this.dropOffTime,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Ride copyWith({
    String? id,
    String? rideId,
    String? transportOwnerId,
    List<String>? contractIds,
    List<String>? parentIds,
    String? rideType,
    DateTime? startDate,
    DateTime? endDate,
    String? assignedVehicle,
    String? assignedDriver,
    String? routeId,
    List<AssignedChild>? assignedChildren,
    String? dropOffTime,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Ride(
    id: id ?? this.id,
    rideId: rideId ?? this.rideId,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    contractIds: contractIds ?? this.contractIds,
    parentIds: parentIds ?? this.parentIds,
    rideType: rideType ?? this.rideType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    assignedVehicle: assignedVehicle ?? this.assignedVehicle,
    assignedDriver: assignedDriver ?? this.assignedDriver,
    routeId: routeId ?? this.routeId,
    assignedChildren: assignedChildren ?? this.assignedChildren,
    dropOffTime: dropOffTime ?? this.dropOffTime,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
    id: json["_id"],
    rideId: json["rideId"],
    transportOwnerId: json["transportOwnerId"],
    contractIds: json["contractIds"] == null
        ? []
        : List<String>.from(json["contractIds"]!.map((x) => x)),
    parentIds: json["parentIds"] == null
        ? []
        : List<String>.from(json["parentIds"]!.map((x) => x)),
    rideType: json["rideType"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    assignedVehicle: json["assignedVehicle"],
    assignedDriver: json["assignedDriver"],
    routeId: json["routeId"],
    assignedChildren: json["assignedChildren"] == null
        ? []
        : List<AssignedChild>.from(
            json["assignedChildren"]!.map((x) => AssignedChild.fromJson(x)),
          ),
    dropOffTime: json["dropOffTime"],
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
    "rideId": rideId,
    "transportOwnerId": transportOwnerId,
    "contractIds": contractIds == null
        ? []
        : List<dynamic>.from(contractIds!.map((x) => x)),
    "parentIds": parentIds == null
        ? []
        : List<dynamic>.from(parentIds!.map((x) => x)),
    "rideType": rideType,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "assignedVehicle": assignedVehicle,
    "assignedDriver": assignedDriver,
    "routeId": routeId,
    "assignedChildren": assignedChildren == null
        ? []
        : List<dynamic>.from(assignedChildren!.map((x) => x.toJson())),
    "dropOffTime": dropOffTime,
    "status": status,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
  UserDetail? user; // UserDetail model
  int? averageRating;
  int? totalRatings;

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
    UserDetail? user,
    int? averageRating,
    int? totalRatings,
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
    user: json["user"] == null ? null : UserDetail.fromJson(json["user"]),
    averageRating: json["averageRating"],
    totalRatings: json["totalRatings"],
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
        : List<dynamic>.from(businessDocuments!.map((x) => x.toJson())),
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

class Vehicle {
  String? id;
  String? transportOwnerId;
  String? registrationNumber;
  String? vehicleType;
  String? make;
  String? model;
  String? manufacturingYear;
  DateTime? registrationExpiry;
  List<dynamic>? documents;
  String? status;
  List<LicenseDocument>? pictures;
  dynamic assignedTo;
  int? capacity;
  bool? assigned;
  bool? isInsured;
  bool? isDeleted;
  bool? archived;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Vehicle({
    this.id,
    this.transportOwnerId,
    this.registrationNumber,
    this.vehicleType,
    this.make,
    this.model,
    this.manufacturingYear,
    this.registrationExpiry,
    this.documents,
    this.status,
    this.pictures,
    this.assignedTo,
    this.capacity,
    this.assigned,
    this.isInsured,
    this.isDeleted,
    this.archived,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Vehicle copyWith({
    String? id,
    String? transportOwnerId,
    String? registrationNumber,
    String? vehicleType,
    String? make,
    String? model,
    String? manufacturingYear,
    DateTime? registrationExpiry,
    List<dynamic>? documents,
    String? status,
    List<LicenseDocument>? pictures,
    dynamic assignedTo,
    int? capacity,
    bool? assigned,
    bool? isInsured,
    bool? isDeleted,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => Vehicle(
    id: id ?? this.id,
    transportOwnerId: transportOwnerId ?? this.transportOwnerId,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    vehicleType: vehicleType ?? this.vehicleType,
    make: make ?? this.make,
    model: model ?? this.model,
    manufacturingYear: manufacturingYear ?? this.manufacturingYear,
    registrationExpiry: registrationExpiry ?? this.registrationExpiry,
    documents: documents ?? this.documents,
    status: status ?? this.status,
    pictures: pictures ?? this.pictures,
    assignedTo: assignedTo ?? this.assignedTo,
    capacity: capacity ?? this.capacity,
    assigned: assigned ?? this.assigned,
    isInsured: isInsured ?? this.isInsured,
    isDeleted: isDeleted ?? this.isDeleted,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["_id"],
    transportOwnerId: json["transportOwnerId"],
    registrationNumber: json["registrationNumber"],
    vehicleType: json["vehicleType"],
    make: json["make"],
    model: json["model"],
    manufacturingYear: json["manufacturingYear"],
    registrationExpiry: json["registrationExpiry"] == null
        ? null
        : DateTime.parse(json["registrationExpiry"]),
    documents: json["documents"] == null
        ? []
        : List<dynamic>.from(json["documents"]!.map((x) => x)),
    status: json["status"],
    pictures: json["pictures"] == null
        ? []
        : List<LicenseDocument>.from(
            json["pictures"]!.map((x) => LicenseDocument.fromJson(x)),
          ),
    assignedTo: json["assigned_to"],
    capacity: json["capacity"],
    assigned: json["assigned"],
    isInsured: json["isInsured"],
    isDeleted: json["isDeleted"],
    archived: json["archived"],
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
    "transportOwnerId": transportOwnerId,
    "registrationNumber": registrationNumber,
    "vehicleType": vehicleType,
    "make": make,
    "model": model,
    "manufacturingYear": manufacturingYear,
    "registrationExpiry": registrationExpiry?.toIso8601String(),
    "documents": documents == null
        ? []
        : List<dynamic>.from(documents!.map((x) => x)),
    "status": status,
    "pictures": pictures == null
        ? []
        : List<dynamic>.from(pictures!.map((x) => x.toJson())),
    "assigned_to": assignedTo,
    "capacity": capacity,
    "assigned": assigned,
    "isInsured": isInsured,
    "isDeleted": isDeleted,
    "archived": archived,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
