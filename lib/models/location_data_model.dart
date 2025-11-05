class LocationData {
  final String placeId;
  final String description;
  final Coordinates coordinates;

  LocationData({
    required this.placeId,
    required this.description,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() => {
        "placeId": placeId,
        "description": description,
        "coordinates": coordinates.toJson(),
      };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        placeId: json["placeId"] ?? "",
        description: json["description"] ?? "",
        coordinates: Coordinates.fromJson(json["coordinates"] ?? {}),
      );
}

class Coordinates {
  final String type;
  final List<double> coordinates; // [lng, lat]

  Coordinates({
    this.type = "Point",
    required this.coordinates,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates,
      };

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        type: json["type"] ?? "Point",
        coordinates: json["coordinates"] != null
            ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
            : [0.0, 0.0],
      );

  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
  double get longitude => coordinates.length > 0 ? coordinates[0] : 0.0;
}

