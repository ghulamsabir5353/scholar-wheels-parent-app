class LicenseDocument {
  String? url;
  String? fileName;
  String? id;
  DateTime? uploadedAt;
  String? presignedUrl;

  LicenseDocument({
    this.url,
    this.fileName,
    this.id,
    this.uploadedAt,
    this.presignedUrl,
  });

  LicenseDocument copyWith({
    String? url,
    String? fileName,
    String? id,
    DateTime? uploadedAt,
    String? presignedUrl,
  }) => LicenseDocument(
    url: url ?? this.url,
    fileName: fileName ?? this.fileName,
    id: id ?? this.id,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    presignedUrl: presignedUrl ?? this.presignedUrl,
  );

  factory LicenseDocument.fromJson(Map<String, dynamic> json) =>
      LicenseDocument(
        url: json["url"],
        fileName: json["fileName"],
        id: json["_id"],
        uploadedAt: json["uploadedAt"] == null
            ? null
            : DateTime.parse(json["uploadedAt"]),
        presignedUrl: json["presignedUrl"],
      );

  Map<String, dynamic> toJson() => {
    "url": url,
    "fileName": fileName,
    "_id": id,
    "uploadedAt": uploadedAt?.toIso8601String(),
    "presignedUrl": presignedUrl,
  };
}
