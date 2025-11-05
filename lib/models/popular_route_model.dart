class PopularRouteModel {
  int? bookingCount;
  String? id;
  String? routeId;
  String? transportOwnerId;
  String? routeName;
  String? suburb;
  String? dropOffPoint;
  String? assignedVehicle;
  String? assignedDriver;
  String? status;
  int? estimatedDistance;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PopularRouteModel({
    this.bookingCount,
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
  });

  PopularRouteModel copyWith({
    int? bookingCount,
    String? id,
    String? routeId,
    String? transportOwnerId,
    String? routeName,
    String? suburb,
    String? dropOffPoint,
    String? assignedVehicle,
    String? assignedDriver,
    String? status,
    int? estimatedDistance,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => PopularRouteModel(
    bookingCount: bookingCount ?? this.bookingCount,
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
  );

  factory PopularRouteModel.fromJson(Map<String, dynamic> json) =>
      PopularRouteModel(
        bookingCount: json["bookingCount"],
        id: json["_id"],
        routeId: json["routeId"],
        transportOwnerId: json["transportOwnerId"],
        routeName: json["routeName"],
        suburb: json["suburb"],
        dropOffPoint: json["dropOffPoint"],
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
      );

  Map<String, dynamic> toJson() => {
    "bookingCount": bookingCount,
    "_id": id,
    "routeId": routeId,
    "transportOwnerId": transportOwnerId,
    "routeName": routeName,
    "suburb": suburb,
    "dropOffPoint": dropOffPoint,
    "assignedVehicle": assignedVehicle,
    "assignedDriver": assignedDriver,
    "status": status,
    "estimatedDistance": estimatedDistance,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
