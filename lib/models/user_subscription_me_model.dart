/// Response from GET /usersubscription/me
class UserSubscriptionMeResponse {
  final bool hasActiveSubscription;
  final UserSubscriptionDetail? subscription;
  final SubscriptionLimits? limits;
  final String? cardUpdateUrl;

  UserSubscriptionMeResponse({
    required this.hasActiveSubscription,
    this.subscription,
    this.limits,
    this.cardUpdateUrl,
  });

  factory UserSubscriptionMeResponse.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionMeResponse(
      hasActiveSubscription: json['hasActiveSubscription'] as bool? ?? false,
      subscription: json['subscription'] != null
          ? UserSubscriptionDetail.fromJson(
              json['subscription'] as Map<String, dynamic>)
          : null,
      limits: json['limits'] != null
          ? SubscriptionLimits.fromJson(
              json['limits'] as Map<String, dynamic>)
          : null,
      cardUpdateUrl: json['cardUpdateUrl'] as String?,
    );
  }
}

class UserSubscriptionDetail {
  final String? id;
  final String? userId;
  final PlanSnapshot? planId;
  final String? status;
  final String? userSubscriptionId;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? nextBillingDate;

  UserSubscriptionDetail({
    this.id,
    this.userId,
    this.planId,
    this.status,
    this.userSubscriptionId,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.nextBillingDate,
  });

  factory UserSubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionDetail(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      planId: json['planId'] != null
          ? PlanSnapshot.fromJson(
              Map<String, dynamic>.from(json['planId'] as Map))
          : null,
      status: json['status'] as String?,
      userSubscriptionId: json['userSubscriptionId'] as String?,
      currentPeriodStart: json['currentPeriodStart'] != null
          ? DateTime.tryParse(json['currentPeriodStart'] as String)
          : null,
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.tryParse(json['currentPeriodEnd'] as String)
          : null,
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.tryParse(json['nextBillingDate'] as String)
          : null,
    );
  }
}

class PlanSnapshot {
  final String? id;
  final String? name;
  final num? price;
  final String? currency;
  final String? billingType;
  final int? durationInDays;
  final List<PlanFeature>? features;

  PlanSnapshot({
    this.id,
    this.name,
    this.price,
    this.currency,
    this.billingType,
    this.durationInDays,
    this.features,
  });

  factory PlanSnapshot.fromJson(Map<String, dynamic> json) {
    return PlanSnapshot(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      currency: json['currency'] as String?,
      billingType: json['billingType'] as String?,
      durationInDays: json['durationInDays'] as int?,
      features: json['features'] != null
          ? (json['features'] as List)
              .map((e) => PlanFeature.fromJson(
                  e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{}))
              .toList()
          : null,
    );
  }
}

class PlanFeature {
  final String? text;
  final String? id;

  PlanFeature({this.text, this.id});

  factory PlanFeature.fromJson(Map<String, dynamic> json) {
    return PlanFeature(
      text: json['text'] as String?,
      id: json['_id'] as String?,
    );
  }
}

class SubscriptionLimits {
  final int? children;
  final int? bookings;

  SubscriptionLimits({this.children, this.bookings});

  factory SubscriptionLimits.fromJson(Map<String, dynamic> json) {
    return SubscriptionLimits(
      children: json['children'] as int?,
      bookings: json['bookings'] as int?,
    );
  }
}
