// To parse this JSON data, do
//
//     final subscriptions = subscriptionsFromJson(jsonString);

import 'dart:convert';

Subscriptions subscriptionsFromJson(String str) =>
    Subscriptions.fromJson(json.decode(str));

String subscriptionsToJson(Subscriptions data) => json.encode(data.toJson());

// Response wrapper for API
SubscriptionsResponse subscriptionsResponseFromJson(String str) =>
    SubscriptionsResponse.fromJson(json.decode(str));

String subscriptionsResponseToJson(SubscriptionsResponse data) =>
    json.encode(data.toJson());

class SubscriptionsResponse {
  List<Subscriptions>? subscriptions;

  SubscriptionsResponse({this.subscriptions});

  factory SubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionsResponse(
        subscriptions: json["subscriptions"] == null
            ? []
            : List<Subscriptions>.from(
                json["subscriptions"]!.map((x) => Subscriptions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subscriptions": subscriptions == null
            ? []
            : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
      };
}

class Subscriptions {
  String? id;
  String? name;
  String? role;
  int? price;
  String? currency;
  bool? isPublic;
  int? durationInDays;
  String? billingType;
  Limits? limits;
  List<Feature>? features;
  String? status;
  bool? isActive;
  bool? isDeleted;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? subscriptionId;
  int? v;

  Subscriptions({
    this.id,
    this.name,
    this.role,
    this.price,
    this.currency,
    this.isPublic,
    this.durationInDays,
    this.billingType,
    this.limits,
    this.features,
    this.status,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.subscriptionId,
    this.v,
  });

  Subscriptions copyWith({
    String? id,
    String? name,
    String? role,
    int? price,
    String? currency,
    bool? isPublic,
    int? durationInDays,
    String? billingType,
    Limits? limits,
    List<Feature>? features,
    String? status,
    bool? isActive,
    bool? isDeleted,
    CreatedBy? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subscriptionId,
    int? v,
  }) => Subscriptions(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    isPublic: isPublic ?? this.isPublic,
    durationInDays: durationInDays ?? this.durationInDays,
    billingType: billingType ?? this.billingType,
    limits: limits ?? this.limits,
    features: features ?? this.features,
    status: status ?? this.status,
    isActive: isActive ?? this.isActive,
    isDeleted: isDeleted ?? this.isDeleted,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    v: v ?? this.v,
  );

  factory Subscriptions.fromJson(Map<String, dynamic> json) => Subscriptions(
    id: json["_id"],
    name: json["name"],
    role: json["role"],
    price: json["price"],
    currency: json["currency"],
    isPublic: json["isPublic"],
    durationInDays: json["durationInDays"],
    billingType: json["billingType"],
    limits: json["limits"] == null ? null : Limits.fromJson(json["limits"]),
    features: json["features"] == null
        ? []
        : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    status: json["status"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdBy: json["createdBy"] == null
        ? null
        : CreatedBy.fromJson(json["createdBy"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    subscriptionId: json["subscriptionId"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "role": role,
    "price": price,
    "currency": currency,
    "isPublic": isPublic,
    "durationInDays": durationInDays,
    "billingType": billingType,
    "limits": limits?.toJson(),
    "features": features == null
        ? []
        : List<dynamic>.from(features!.map((x) => x.toJson())),
    "status": status,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdBy": createdBy?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "subscriptionId": subscriptionId,
    "__v": v,
  };
}

class CreatedBy {
  String? id;
  String? email;
  String? firstName;
  String? surName;

  CreatedBy({this.id, this.email, this.firstName, this.surName});

  CreatedBy copyWith({
    String? id,
    String? email,
    String? firstName,
    String? surName,
  }) => CreatedBy(
    id: id ?? this.id,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    surName: surName ?? this.surName,
  );

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["_id"],
    email: json["email"],
    firstName: json["firstName"],
    surName: json["surName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "firstName": firstName,
    "surName": surName,
  };
}

class Feature {
  String? text;
  String? id;

  Feature({this.text, this.id});

  Feature copyWith({String? text, String? id}) =>
      Feature(text: text ?? this.text, id: id ?? this.id);

  factory Feature.fromJson(Map<String, dynamic> json) =>
      Feature(text: json["text"], id: json["_id"]);

  Map<String, dynamic> toJson() => {"text": text, "_id": id};
}

class Limits {
  Parent? parent;
  TransportOwner? transportOwner;

  Limits({this.parent, this.transportOwner});

  Limits copyWith({Parent? parent, TransportOwner? transportOwner}) => Limits(
    parent: parent ?? this.parent,
    transportOwner: transportOwner ?? this.transportOwner,
  );

  factory Limits.fromJson(Map<String, dynamic> json) => Limits(
    parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
    transportOwner: json["transportOwner"] == null
        ? null
        : TransportOwner.fromJson(json["transportOwner"]),
  );

  Map<String, dynamic> toJson() => {
    "parent": parent?.toJson(),
    "transportOwner": transportOwner?.toJson(),
  };
}

class Parent {
  int? children;
  int? bookings;

  Parent({this.children, this.bookings});

  Parent copyWith({int? children, int? bookings}) => Parent(
    children: children ?? this.children,
    bookings: bookings ?? this.bookings,
  );

  factory Parent.fromJson(Map<String, dynamic> json) =>
      Parent(children: json["children"], bookings: json["bookings"]);

  Map<String, dynamic> toJson() => {"children": children, "bookings": bookings};
}

class TransportOwner {
  dynamic drivers;
  dynamic vehicles;
  dynamic routes;
  dynamic rides;
  dynamic contracts;

  TransportOwner({
    this.drivers,
    this.vehicles,
    this.routes,
    this.rides,
    this.contracts,
  });

  TransportOwner copyWith({
    dynamic drivers,
    dynamic vehicles,
    dynamic routes,
    dynamic rides,
    dynamic contracts,
  }) => TransportOwner(
    drivers: drivers ?? this.drivers,
    vehicles: vehicles ?? this.vehicles,
    routes: routes ?? this.routes,
    rides: rides ?? this.rides,
    contracts: contracts ?? this.contracts,
  );

  factory TransportOwner.fromJson(Map<String, dynamic> json) => TransportOwner(
    drivers: json["drivers"],
    vehicles: json["vehicles"],
    routes: json["routes"],
    rides: json["rides"],
    contracts: json["contracts"],
  );

  Map<String, dynamic> toJson() => {
    "drivers": drivers,
    "vehicles": vehicles,
    "routes": routes,
    "rides": rides,
    "contracts": contracts,
  };
}
