/// Model for subscription invoice from GET /subscription-invoice/
class SubscriptionInvoice {
  final String? id;
  final String? userId;
  final String? subscriptionId;
  final String? userSubscriptionId;
  final DateTime? billingPeriodStart;
  final DateTime? billingPeriodEnd;
  final num? amountGross;
  final num? amountFee;
  final num? amountNet;
  final String? currency;
  final String? provider;
  final String? status;
  final DateTime? issuedAt;
  final DateTime? createdAt;
  final String? invoiceNumber;
  final Map<String, dynamic>? planSnapshot;
  final Map<String, dynamic>? customerSnapshot;

  SubscriptionInvoice({
    this.id,
    this.userId,
    this.subscriptionId,
    this.userSubscriptionId,
    this.billingPeriodStart,
    this.billingPeriodEnd,
    this.amountGross,
    this.amountFee,
    this.amountNet,
    this.currency,
    this.provider,
    this.status,
    this.issuedAt,
    this.createdAt,
    this.invoiceNumber,
    this.planSnapshot,
    this.customerSnapshot,
  });

  factory SubscriptionInvoice.fromJson(Map<String, dynamic> json) {
    return SubscriptionInvoice(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
      userSubscriptionId: json['userSubscriptionId'] as String?,
      billingPeriodStart: json['billingPeriodStart'] != null
          ? DateTime.tryParse(json['billingPeriodStart'] as String)
          : null,
      billingPeriodEnd: json['billingPeriodEnd'] != null
          ? DateTime.tryParse(json['billingPeriodEnd'] as String)
          : null,
      amountGross: json['amountGross'] as num?,
      amountFee: json['amountFee'] as num?,
      amountNet: json['amountNet'] as num?,
      currency: json['currency'] as String?,
      provider: json['provider'] as String?,
      status: json['status'] as String?,
      issuedAt: json['issuedAt'] != null
          ? DateTime.tryParse(json['issuedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      invoiceNumber: json['invoiceNumber'] as String?,
      planSnapshot: json['planSnapshot'] as Map<String, dynamic>?,
      customerSnapshot: json['customerSnapshot'] as Map<String, dynamic>?,
    );
  }
}
