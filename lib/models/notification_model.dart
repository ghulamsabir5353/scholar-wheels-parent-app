class NotificationResponse {
  int? status;
  String? message;
  List<NotificationModel>? notifications;
  NotificationPagination? pagination;

  NotificationResponse({
    this.status,
    this.message,
    this.notifications,
    this.pagination,
  });

  NotificationResponse copyWith({
    int? status,
    String? message,
    List<NotificationModel>? notifications,
    NotificationPagination? pagination,
  }) =>
      NotificationResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        notifications: notifications ?? this.notifications,
        pagination: pagination ?? this.pagination,
      );

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        status: json["status"],
        message: json["message"],
        notifications: json["notifications"] == null
            ? []
            : List<NotificationModel>.from(
                json["notifications"]!.map((x) => NotificationModel.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : NotificationPagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class NotificationModel {
  String? id;
  String? title;
  String? message;
  String? type;
  dynamic audience;
  List<String>? recipientIds;
  String? fcmToken;
  bool? sent;
  DateTime? sentAt;
  bool? read;
  DateTime? readAt;
  String? fcmMessageId;
  NotificationData? data;
  String? status;
  bool? isActive;
  bool? isDeleted;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? notificationId;
  int? v;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.audience,
    this.recipientIds,
    this.fcmToken,
    this.sent,
    this.sentAt,
    this.read,
    this.readAt,
    this.fcmMessageId,
    this.data,
    this.status,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.notificationId,
    this.v,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    dynamic audience,
    List<String>? recipientIds,
    String? fcmToken,
    bool? sent,
    DateTime? sentAt,
    bool? read,
    DateTime? readAt,
    String? fcmMessageId,
    NotificationData? data,
    String? status,
    bool? isActive,
    bool? isDeleted,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notificationId,
    int? v,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        title: title ?? this.title,
        message: message ?? this.message,
        type: type ?? this.type,
        audience: audience ?? this.audience,
        recipientIds: recipientIds ?? this.recipientIds,
        fcmToken: fcmToken ?? this.fcmToken,
        sent: sent ?? this.sent,
        sentAt: sentAt ?? this.sentAt,
        read: read ?? this.read,
        readAt: readAt ?? this.readAt,
        fcmMessageId: fcmMessageId ?? this.fcmMessageId,
        data: data ?? this.data,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        notificationId: notificationId ?? this.notificationId,
        v: v ?? this.v,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["_id"],
        title: json["title"],
        message: json["message"],
        type: json["type"],
        audience: json["audience"],
        recipientIds: json["recipientIds"] == null
            ? []
            : List<String>.from(json["recipientIds"]!.map((x) => x)),
        fcmToken: json["fcmToken"],
        sent: json["sent"],
        sentAt: json["sentAt"] == null
            ? null
            : DateTime.parse(json["sentAt"]),
        read: json["read"],
        readAt: json["readAt"] == null
            ? null
            : DateTime.parse(json["readAt"]),
        fcmMessageId: json["fcmMessageId"],
        data: json["data"] == null
            ? null
            : NotificationData.fromJson(json["data"]),
        status: json["status"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        notificationId: json["notificationId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "message": message,
        "type": type,
        "audience": audience,
        "recipientIds": recipientIds == null
            ? []
            : List<dynamic>.from(recipientIds!.map((x) => x)),
        "fcmToken": fcmToken,
        "sent": sent,
        "sentAt": sentAt?.toIso8601String(),
        "read": read,
        "readAt": readAt?.toIso8601String(),
        "fcmMessageId": fcmMessageId,
        "data": data?.toJson(),
        "status": status,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "notificationId": notificationId,
        "__v": v,
      };
}

class NotificationData {
  String? contractId;
  String? contractIdString;
  List<String>? childIds;
  String? childrenNames;
  String? parentId;
  String? parentName;
  String? transportOwnerId;
  String? transportOwnerName;
  String? routeId;
  String? routeName;
  int? monthlyPayment;
  DateTime? startDate;
  DateTime? endDate;
  String? bookingId;
  String? bookingIdString;

  NotificationData({
    this.contractId,
    this.contractIdString,
    this.childIds,
    this.childrenNames,
    this.parentId,
    this.parentName,
    this.transportOwnerId,
    this.transportOwnerName,
    this.routeId,
    this.routeName,
    this.monthlyPayment,
    this.startDate,
    this.endDate,
    this.bookingId,
    this.bookingIdString,
  });

  NotificationData copyWith({
    String? contractId,
    String? contractIdString,
    List<String>? childIds,
    String? childrenNames,
    String? parentId,
    String? parentName,
    String? transportOwnerId,
    String? transportOwnerName,
    String? routeId,
    String? routeName,
    int? monthlyPayment,
    DateTime? startDate,
    DateTime? endDate,
    String? bookingId,
    String? bookingIdString,
  }) =>
      NotificationData(
        contractId: contractId ?? this.contractId,
        contractIdString: contractIdString ?? this.contractIdString,
        childIds: childIds ?? this.childIds,
        childrenNames: childrenNames ?? this.childrenNames,
        parentId: parentId ?? this.parentId,
        parentName: parentName ?? this.parentName,
        transportOwnerId: transportOwnerId ?? this.transportOwnerId,
        transportOwnerName: transportOwnerName ?? this.transportOwnerName,
        routeId: routeId ?? this.routeId,
        routeName: routeName ?? this.routeName,
        monthlyPayment: monthlyPayment ?? this.monthlyPayment,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        bookingId: bookingId ?? this.bookingId,
        bookingIdString: bookingIdString ?? this.bookingIdString,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        contractId: json["contractId"],
        contractIdString: json["contractIdString"],
        childIds: json["childIds"] == null
            ? []
            : List<String>.from(json["childIds"]!.map((x) => x)),
        childrenNames: json["childrenNames"],
        parentId: json["parentId"],
        parentName: json["parentName"],
        transportOwnerId: json["transportOwnerId"],
        transportOwnerName: json["transportOwnerName"],
        routeId: json["routeId"],
        routeName: json["routeName"],
        monthlyPayment: json["monthlyPayment"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.parse(json["endDate"]),
        bookingId: json["bookingId"],
        bookingIdString: json["bookingIdString"],
      );

  Map<String, dynamic> toJson() => {
        "contractId": contractId,
        "contractIdString": contractIdString,
        "childIds": childIds == null
            ? []
            : List<dynamic>.from(childIds!.map((x) => x)),
        "childrenNames": childrenNames,
        "parentId": parentId,
        "parentName": parentName,
        "transportOwnerId": transportOwnerId,
        "transportOwnerName": transportOwnerName,
        "routeId": routeId,
        "routeName": routeName,
        "monthlyPayment": monthlyPayment,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "bookingId": bookingId,
        "bookingIdString": bookingIdString,
      };
}

class NotificationPagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? currentPage;

  NotificationPagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.currentPage,
  });

  NotificationPagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
    int? currentPage,
  }) =>
      NotificationPagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
      );

  factory NotificationPagination.fromJson(Map<String, dynamic> json) =>
      NotificationPagination(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}


