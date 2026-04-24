/// Response from GET /usersubscription/limits
class UserSubscriptionLimitsResponse {
  final bool hasActiveSubscription;
  final String? role;
  final SubscriptionLimitCounts limits;
  final SubscriptionLimitCounts usage;
  final SubscriptionLimitCounts remaining;

  UserSubscriptionLimitsResponse({
    required this.hasActiveSubscription,
    this.role,
    required this.limits,
    required this.usage,
    required this.remaining,
  });

  factory UserSubscriptionLimitsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserSubscriptionLimitsResponse(
      hasActiveSubscription: json['hasActiveSubscription'] == true,
      role: json['role'] as String?,
      limits: SubscriptionLimitCounts.fromJson(
        json['limits'] is Map<String, dynamic>
            ? json['limits'] as Map<String, dynamic>
            : null,
      ),
      usage: SubscriptionLimitCounts.fromJson(
        json['usage'] is Map<String, dynamic>
            ? json['usage'] as Map<String, dynamic>
            : null,
      ),
      remaining: SubscriptionLimitCounts.fromJson(
        json['remaining'] is Map<String, dynamic>
            ? json['remaining'] as Map<String, dynamic>
            : null,
      ),
    );
  }
}

class SubscriptionLimitCounts {
  final int? children;
  final int? bookings;

  SubscriptionLimitCounts({this.children, this.bookings});

  factory SubscriptionLimitCounts.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SubscriptionLimitCounts();
    }
    return SubscriptionLimitCounts(
      children: _readInt(json['children']),
      bookings: _readInt(json['bookings']),
    );
  }

  static int? _readInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
