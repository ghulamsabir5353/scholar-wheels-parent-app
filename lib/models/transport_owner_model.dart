import 'package:scholarwheels/models/business_address_model.dart';
import 'package:scholarwheels/models/license_doc_model.dart';
import 'package:scholarwheels/models/user_model.dart';

class TransportOwner {
  String? id;
  String? userId;
  String? businessName;
  String? firstName;
  String? surName;
  String? registrationNumber;
  //   businessAddress: {
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
  BusinessAddress? businessAddress;

  List<LicenseDocument>? businessDocuments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isDeleted;
  String? businessType;
  String? transportLicense;
  bool? isIndependent;
  bool? isVerified;
  UserDetail? user; // UserDetail model
  double? averageRating;
  double? totalRatings;

  TransportOwner({
    this.id,
    this.userId,
    this.businessName,
    this.firstName,
    this.surName,
    this.registrationNumber,
    this.businessAddress,
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
    BusinessAddress? businessAddress,
    List<LicenseDocument>? businessDocuments,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    bool? isDeleted,
    String? businessType,
    String? transportLicense,
    bool? isIndependent,
    bool? isVerified,
    UserDetail? user,
    double? averageRating,
    double? totalRatings,
  }) => TransportOwner(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    businessName: businessName ?? this.businessName,
    firstName: firstName ?? this.firstName,
    surName: surName ?? this.surName,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    businessAddress: businessAddress ?? this.businessAddress,
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
    businessAddress: json["businessAddress"] == null
        ? null
        : BusinessAddress.fromJson(json["businessAddress"]),
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
    user: json["user"] == null ? null : UserDetail.fromJson(json["user"]),
    averageRating: json["averageRating"]?.toDouble() ?? 0,
    totalRatings: json["totalRatings"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "businessName": businessName,
    "firstName": firstName,
    "surName": surName,
    "registrationNumber": registrationNumber,
    "businessAddress": businessAddress?.toJson(),
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
    "averageRating": averageRating?.toString(),
    "totalRatings": totalRatings?.toString(),
  };
}
