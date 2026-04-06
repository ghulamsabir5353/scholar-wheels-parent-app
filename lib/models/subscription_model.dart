class Subscription {
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

  Subscription({
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
  });

  Subscription copyWith({
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
  }) => Subscription(
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
  );

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
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
  };
}

class Limits {
  String? id;
  String? name;
  String? role;
  int? price;
  String? currency;
  bool? isPublic;
  int? durationInDays;
  String? billingType;
  Limits({
    this.id,
    this.name,
    this.role,
    this.price,
    this.currency,
    this.isPublic,
    this.durationInDays,
    this.billingType,
  });
  Limits copyWith({
    String? id,
    String? name,
    String? role,
    int? price,
    String? currency,
    bool? isPublic,
    int? durationInDays,
    String? billingType,
  }) => Limits(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    isPublic: isPublic ?? this.isPublic,
    durationInDays: durationInDays ?? this.durationInDays,
    billingType: billingType ?? this.billingType,
  );
  factory Limits.fromJson(Map<String, dynamic> json) => Limits(
    id: json["_id"],
    name: json["name"],
    role: json["role"],
    price: json["price"],
    currency: json["currency"],
    isPublic: json["isPublic"],
    durationInDays: json["durationInDays"],
    billingType: json["billingType"],
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
