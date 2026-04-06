import 'package:scholarwheels/models/license_doc_model.dart';
import 'package:scholarwheels/models/trip_model.dart';

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
  ChildUser? user;

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
    ChildUser? user,
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
    user: json["user"] == null ? null : ChildUser.fromJson(json["user"]),
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
