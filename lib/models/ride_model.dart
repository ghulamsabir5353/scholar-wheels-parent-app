import 'package:scholarwheels/models/dashboard_model.dart';

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
