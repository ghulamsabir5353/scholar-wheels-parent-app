// businessAddress: {
//       street: {
//         type: String,
//       },
//       city: {
//         type: String,
//       },
//       postalCode: {
//         type: String,
//       },
//     },
class BusinessAddress {
  String? type;

  String? city;
  String? postalCode;

  BusinessAddress({this.type, this.city, this.postalCode});

  BusinessAddress copyWith({String? type, String? city, String? postalCode}) =>
      BusinessAddress(
        type: type ?? this.type,

        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
      );
  factory BusinessAddress.fromJson(Map<String, dynamic> json) =>
      BusinessAddress(
        type: json["type"],

        city: json["city"],
        postalCode: json["postalCode"],
      );
  Map<String, dynamic> toJson() => {
    "type": type,

    "city": city,
    "postalCode": postalCode,
  };
}
