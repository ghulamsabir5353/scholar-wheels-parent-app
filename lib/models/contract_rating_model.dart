// ignore_for_file: constant_identifier_names

/// Parent review for a contract (GET /rating, POST /rating).
class ContractRatingReview {
  final String? id;
  final String? contractId;
  final String? parentId;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  final String? ratingMonth; // e.g. "March"
  final int? ratingYear; // e.g. 2026

  ContractRatingReview({
    this.id,
    this.contractId,
    this.parentId,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.ratingMonth,
    this.ratingYear,
  });

  factory ContractRatingReview.fromJson(Map<String, dynamic> json) {
    double parseRating(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return ContractRatingReview(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      contractId: json['contractId']?.toString(),
      parentId: json['parentId']?.toString(),
      rating: parseRating(json['rating']),
      comment: json['comment']?.toString() ?? '',
      createdAt:
          parseDate(json['createdAt'] ?? json['created_at'] ?? json['updatedAt']),
      ratingMonth: json['ratingMonth']?.toString(),
      ratingYear: json['ratingYear'] is num
          ? (json['ratingYear'] as num).toInt()
          : int.tryParse(json['ratingYear']?.toString() ?? ''),
    );
  }
}
