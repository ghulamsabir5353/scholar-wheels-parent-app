class RoomDetail {
  List<Chat>? chats;
  Pagination? pagination;

  RoomDetail({this.chats, this.pagination});

  RoomDetail copyWith({List<Chat>? chats, Pagination? pagination}) =>
      RoomDetail(
        chats: chats ?? this.chats,
        pagination: pagination ?? this.pagination,
      );

  factory RoomDetail.fromJson(Map<String, dynamic> json) => RoomDetail(
    chats: json["chats"] == null
        ? []
        : List<Chat>.from(json["chats"]!.map((x) => Chat.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "chats": chats == null
        ? []
        : List<dynamic>.from(chats!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Chat {
  String? id;
  List<Participant>? participants;
  String? chatType;
  String? contractId;
  dynamic rideId;
  dynamic rideInstanceId;
  String? lastMessage;
  String? lastMessageAt;
  dynamic lastMessageSender;
  int? unreadCount;
  bool? isActive;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<ParticipantDetail>? participantDetails;
  ContractDetails? contractDetails;

  Chat({
    this.id,
    this.participants,
    this.chatType,
    this.contractId,
    this.rideId,
    this.rideInstanceId,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSender,
    this.unreadCount,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.participantDetails,
    this.contractDetails,
  });

  Chat copyWith({
    String? id,
    List<Participant>? participants,
    String? chatType,
    String? contractId,
    dynamic rideId,
    dynamic rideInstanceId,
    String? lastMessage,
    String? lastMessageAt,
    dynamic lastMessageSender,
    int? unreadCount,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<ParticipantDetail>? participantDetails,
    ContractDetails? contractDetails,
  }) => Chat(
    id: id ?? this.id,
    participants: participants ?? this.participants,
    chatType: chatType ?? this.chatType,
    contractId: contractId ?? this.contractId,
    rideId: rideId ?? this.rideId,
    rideInstanceId: rideInstanceId ?? this.rideInstanceId,
    lastMessage: lastMessage ?? this.lastMessage,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    lastMessageSender: lastMessageSender ?? this.lastMessageSender,
    unreadCount: unreadCount ?? this.unreadCount,
    isActive: isActive ?? this.isActive,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    participantDetails: participantDetails ?? this.participantDetails,
    contractDetails: contractDetails ?? this.contractDetails,
  );

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["_id"],
    participants: json["participants"] == null
        ? []
        : List<Participant>.from(
            json["participants"]!.map((x) => Participant.fromJson(x)),
          ),
    chatType: json["chatType"],
    contractId: json["contractId"],
    rideId: json["rideId"],
    rideInstanceId: json["rideInstanceId"],
    lastMessage: json["lastMessage"],
    lastMessageAt: json["lastMessageAt"],
    lastMessageSender: json["lastMessageSender"],
    unreadCount: json["unreadCount"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    participantDetails: json["participantDetails"] == null
        ? []
        : List<ParticipantDetail>.from(
            json["participantDetails"]!.map(
              (x) => ParticipantDetail.fromJson(x),
            ),
          ),
    contractDetails: json["contractDetails"] == null
        ? null
        : ContractDetails.fromJson(json["contractDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "participants": participants == null
        ? []
        : List<dynamic>.from(participants!.map((x) => x.toJson())),
    "chatType": chatType,
    "contractId": contractId,
    "rideId": rideId,
    "rideInstanceId": rideInstanceId,
    "lastMessage": lastMessage,
    "lastMessageAt": lastMessageAt,
    "lastMessageSender": lastMessageSender,
    "unreadCount": unreadCount,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "participantDetails": participantDetails == null
        ? []
        : List<dynamic>.from(participantDetails!.map((x) => x.toJson())),
    "contractDetails": contractDetails?.toJson(),
  };
}

class ContractDetails {
  String? id;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  ContractDetails({this.id, this.startDate, this.endDate, this.status});

  ContractDetails copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) => ContractDetails(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
  );

  factory ContractDetails.fromJson(Map<String, dynamic> json) =>
      ContractDetails(
        id: json["_id"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.parse(json["endDate"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "status": status,
  };
}

class ParticipantDetail {
  String? id;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? role;
  String? businessAddress;
  String? businessName;
  String? surName;
  String? registrationNumber;
  String? address;
  String? postalCode;

  ParticipantDetail({
    this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.role,
    this.businessAddress,
    this.businessName,
    this.surName,
    this.registrationNumber,
    this.address,
    this.postalCode,
  });

  ParticipantDetail copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? profileImage,
    String? role,
    String? businessAddress,
    String? businessName,
    String? surName,
    String? registrationNumber,
    String? address,
    String? postalCode,
  }) => ParticipantDetail(
    id: id ?? this.id,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profileImage: profileImage ?? this.profileImage,
    role: role ?? this.role,
    businessAddress: businessAddress ?? this.businessAddress,
    businessName: businessName ?? this.businessName,
    surName: surName ?? this.surName,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    address: address ?? this.address,
    postalCode: postalCode ?? this.postalCode,
  );

  factory ParticipantDetail.fromJson(Map<String, dynamic> json) =>
      ParticipantDetail(
        id: json["_id"],
        email: json["email"],
        phone: json["phone"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profileImage: json["profileImage"],
        role: json["role"],
        businessAddress: json["businessAddress"],
        businessName: json["businessName"],
        surName: json["surName"],
        registrationNumber: json["registrationNumber"],
        address: json["address"],
        postalCode: json["postalCode"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "phone": phone,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "role": role,
    "businessAddress": businessAddress,
    "businessName": businessName,
    "surName": surName,
    "registrationNumber": registrationNumber,
    "address": address,
    "postalCode": postalCode,
  };
}

class Participant {
  String? userId;
  String? role;
  String? id;
  DateTime? joinedAt;

  Participant({this.userId, this.role, this.id, this.joinedAt});

  Participant copyWith({
    String? userId,
    String? role,
    String? id,
    DateTime? joinedAt,
  }) => Participant(
    userId: userId ?? this.userId,
    role: role ?? this.role,
    id: id ?? this.id,
    joinedAt: joinedAt ?? this.joinedAt,
  );

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    userId: json["userId"],
    role: json["role"],
    id: json["_id"],
    joinedAt: json["joinedAt"] == null
        ? null
        : DateTime.parse(json["joinedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "role": role,
    "_id": id,
    "joinedAt": joinedAt?.toIso8601String(),
  };
}

class Pagination {
  dynamic currentPage;
  dynamic totalPages;
  int? totalChats;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalChats,
    this.hasMore,
  });

  Pagination copyWith({
    dynamic currentPage,
    dynamic totalPages,
    int? totalChats,
    bool? hasMore,
  }) => Pagination(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    totalChats: totalChats ?? this.totalChats,
    hasMore: hasMore ?? this.hasMore,
  );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    totalChats: json["totalChats"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalChats": totalChats,
    "hasMore": hasMore,
  };
}
