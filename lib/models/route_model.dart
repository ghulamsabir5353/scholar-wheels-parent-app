// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

RouteModel routeModelFromJson(String str) =>
    RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
  String? id;
  String? routeId;
  String? transportOwnerId;
  String? routeName;
  DropOffPoint? suburb;
  DropOffPoint? dropOffPoint;
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
  TransportOwner? transportOwner;

  RouteModel({
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
    this.transportOwner,
  });

  RouteModel copyWith({
    String? id,
    String? routeId,
    String? transportOwnerId,
    String? routeName,
    DropOffPoint? suburb,
    DropOffPoint? dropOffPoint,
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
    TransportOwner? transportOwner,
  }) => RouteModel(
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
    transportOwner: transportOwner ?? this.transportOwner,
  );

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
    id: json["_id"],
    routeId: json["routeId"],
    transportOwnerId: json["transportOwnerId"],
    routeName: json["routeName"],
    suburb: json["suburb"] == null
        ? null
        : DropOffPoint.fromJson(json["suburb"]),
    dropOffPoint: json["dropOffPoint"] == null
        ? null
        : DropOffPoint.fromJson(json["dropOffPoint"]),
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
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
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
    "transportOwner": transportOwner?.toJson(),
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
  DriverUser? user;
  String? licenseIdPresignedUrl;

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
    this.licenseIdPresignedUrl,
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
    DriverUser? user,
    String? licenseIdPresignedUrl,
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
    licenseIdPresignedUrl: licenseIdPresignedUrl ?? this.licenseIdPresignedUrl,
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
    user: json["user"] == null ? null : DriverUser.fromJson(json["user"]),
    licenseIdPresignedUrl: json["licenseIdPresignedUrl"],
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
    "licenseIdPresignedUrl": licenseIdPresignedUrl,
  };
}

class LicenseDocument {
  String? url;
  String? fileName;
  String? id;
  DateTime? uploadedAt;
  String? presignedUrl;

  LicenseDocument({
    this.url,
    this.fileName,
    this.id,
    this.uploadedAt,
    this.presignedUrl,
  });

  LicenseDocument copyWith({
    String? url,
    String? fileName,
    String? id,
    DateTime? uploadedAt,
    String? presignedUrl,
  }) => LicenseDocument(
    url: url ?? this.url,
    fileName: fileName ?? this.fileName,
    id: id ?? this.id,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    presignedUrl: presignedUrl ?? this.presignedUrl,
  );

  factory LicenseDocument.fromJson(Map<String, dynamic> json) =>
      LicenseDocument(
        url: json["url"],
        fileName: json["fileName"],
        id: json["_id"],
        uploadedAt: json["uploadedAt"] == null
            ? null
            : DateTime.parse(json["uploadedAt"]),
        presignedUrl: json["presignedUrl"],
      );

  Map<String, dynamic> toJson() => {
    "url": url,
    "fileName": fileName,
    "_id": id,
    "uploadedAt": uploadedAt?.toIso8601String(),
    "presignedUrl": presignedUrl,
  };
}

class DriverUser {
  String? id;
  String? email;
  String? phone;
  String? role;
  String? status;
  bool? emailVerified;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  DriverUser({
    this.id,
    this.email,
    this.phone,
    this.role,
    this.status,
    this.emailVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  DriverUser copyWith({
    String? id,
    String? email,
    String? phone,
    String? role,
    String? status,
    bool? emailVerified,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => DriverUser(
    id: id ?? this.id,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    status: status ?? this.status,
    emailVerified: emailVerified ?? this.emailVerified,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory DriverUser.fromJson(Map<String, dynamic> json) => DriverUser(
    id: json["_id"],
    email: json["email"],
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
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "phone": phone,
    "role": role,
    "status": status,
    "emailVerified": emailVerified,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
  TransportOwnerUser? user;
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
    TransportOwnerUser? user,
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
    user: json["user"] == null
        ? null
        : TransportOwnerUser.fromJson(json["user"]),
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

class TransportOwnerUser {
  String? id;
  String? email;
  String? phone;
  bool? emailVerified;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? role;
  String? status;
  String? profileImagePresignedUrl;

  TransportOwnerUser({
    this.id,
    this.email,
    this.phone,
    this.emailVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.role,
    this.status,
    this.profileImagePresignedUrl,
  });

  TransportOwnerUser copyWith({
    String? id,
    String? email,
    String? phone,
    bool? emailVerified,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? firstName,
    String? lastName,
    String? profileImage,
    String? role,
    String? status,
    String? profileImagePresignedUrl,
  }) => TransportOwnerUser(
    id: id ?? this.id,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    emailVerified: emailVerified ?? this.emailVerified,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profileImage: profileImage ?? this.profileImage,
    role: role ?? this.role,
    status: status ?? this.status,
    profileImagePresignedUrl:
        profileImagePresignedUrl ?? this.profileImagePresignedUrl,
  );

  factory TransportOwnerUser.fromJson(Map<String, dynamic> json) =>
      TransportOwnerUser(
        id: json["_id"],
        email: json["email"],
        phone: json["phone"],
        emailVerified: json["emailVerified"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profileImage: json["profileImage"],
        role: json["role"],
        status: json["status"],
        profileImagePresignedUrl: json["profileImagePresignedUrl"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "phone": phone,
    "emailVerified": emailVerified,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "role": role,
    "status": status,
    "profileImagePresignedUrl": profileImagePresignedUrl,
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
  String? assignedTo;
  int? capacity;
  bool? assigned;
  bool? isInsured;
  bool? isDeleted;
  bool? archived;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? insurenceNumber;
  String? insurer;

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
    this.insurenceNumber,
    this.insurer,
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
    String? assignedTo,
    int? capacity,
    bool? assigned,
    bool? isInsured,
    bool? isDeleted,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? insurenceNumber,
    String? insurer,
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
    insurenceNumber: insurenceNumber ?? this.insurenceNumber,
    insurer: insurer ?? this.insurer,
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
    insurenceNumber: json["insurenceNumber"],
    insurer: json["insurer"],
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
    "insurenceNumber": insurenceNumber,
    "insurer": insurer,
  };
}
