import 'package:scholarwheels/models/location_data_model.dart';

class PopularRouteModel {
  int? bookingCount;
  String? id;
  String? routeId;
  String? transportOwnerId;
  String? routeName;
  LocationData? suburb; // LocationData model or null
  LocationData? dropOffPoint; // LocationData model or null
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

  // Helper getters to extract description from location data
  String? get suburbDescription => suburb?.description;

  String? get dropOffPointDescription => dropOffPoint?.description;

  // Helper method to parse location data from JSON
  // Returns LocationData if it's a Map, null otherwise (handles String, null, or invalid types)
  static LocationData? _parseLocationData(dynamic json) {
    if (json == null) return null;
    // If it's a String, return null (location data must be a Map)
    if (json is String) return null;
    // Check if it's any type of Map (including _Map<String, dynamic>)
    if (json is Map) {
      try {
        // Convert to Map<String, dynamic> and parse into LocationData model
        final map = Map<String, dynamic>.from(json);
        return LocationData.fromJson(map);
      } catch (e) {
        // If parsing fails, return null
        return null;
      }
    }
    // For any other type (int, bool, etc.), return null
    return null;
  }

  PopularRouteModel copyWith({
    int? bookingCount,
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
        suburb: _parseLocationData(json["suburb"]),
        dropOffPoint: _parseLocationData(json["dropOffPoint"]),
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
  };
}
