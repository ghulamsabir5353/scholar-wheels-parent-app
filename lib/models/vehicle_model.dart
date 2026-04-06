import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/license_doc_model.dart';

class Vehicle {
  String? id;
  String? transportOwnerId;
  String? registrationNumber;
  String? vehicleType;
  String? make;
  String? model;
  String? manufacturingYear;
  DateTime? registrationExpiry;
  List<LicenseDocument>? documents;
  String? status;
  List<LicenseDocument>? pictures;
  String? assignedTo;
  int? capacity;
  bool? assigned;
  bool? isInsured;
  String? insurer;
  String? insurenceNumber;
  bool? isDeleted;
  bool? archived;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? color;

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
    this.insurer,
    this.insurenceNumber,
    this.isDeleted,
    this.archived,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.color,
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
    List<LicenseDocument>? documents,
    String? status,
    List<LicenseDocument>? pictures,
    String? assignedTo,
    int? capacity,
    bool? assigned,
    bool? isInsured,
    String? insurer,
    String? insurenceNumber,
    bool? isDeleted,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? color,
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
    insurer: insurer ?? this.insurer,
    insurenceNumber: insurenceNumber ?? this.insurenceNumber,
    isDeleted: isDeleted ?? this.isDeleted,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    color: color ?? this.color,
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
        : List<LicenseDocument>.from(
            json["documents"]!.map((x) => LicenseDocument.fromJson(x)),
          ),
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
    insurer: json["insurer"],
    insurenceNumber: json["insurenceNumber"],
    isDeleted: json["isDeleted"],
    archived: json["archived"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    color: json["color"],
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
        : List<dynamic>.from(documents?.map((x) => x.toJson()) ?? []),
    "status": status,
    "pictures": pictures == null
        ? []
        : List<dynamic>.from(pictures?.map((x) => x.toJson()) ?? []),
    "assigned_to": assignedTo,
    "capacity": capacity,
    "assigned": assigned,
    "isInsured": isInsured,
    "insurer": insurer,
    "insurenceNumber": insurenceNumber,
    "isDeleted": isDeleted,
    "archived": archived,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "color": color,
  };
}
