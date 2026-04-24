import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/contract_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/contract_model.dart';
import 'package:scholarwheels/models/contract_rating_model.dart';

/// Rate & review form + collapsible history. Loads GET /rating on contract detail;
/// shows sample reviews when the API returns an empty list.
class BookingContractRatingReviewSection extends StatefulWidget {
  final ContractModel contract;

  const BookingContractRatingReviewSection({super.key, required this.contract});

  @override
  State<BookingContractRatingReviewSection> createState() =>
      _BookingContractRatingReviewSectionState();
}

class _PastReview {
  final DateTime periodMonth;
  final DateTime submittedAt;
  final double rating;
  final String text;

  _PastReview({
    required this.periodMonth,
    required this.submittedAt,
    required this.rating,
    required this.text,
  });

  factory _PastReview.fromApi(ContractRatingReview r) {
    final ca = r.createdAt ?? DateTime.now();
    DateTime? periodFromMonthYear() {
      final year = r.ratingYear;
      final monthName = r.ratingMonth;
      if (year == null || monthName == null || monthName.trim().isEmpty) {
        return null;
      }
      // Parse month name (e.g. "March") in English locale.
      try {
        final m = DateFormat('MMMM', 'en_US').parseLoose(monthName).month;
        return DateTime(year, m);
      } catch (_) {
        return null;
      }
    }

    final period = periodFromMonthYear() ?? DateTime(ca.year, ca.month);
    return _PastReview(
      periodMonth: period,
      submittedAt: ca,
      rating: r.rating,
      text: r.comment.isEmpty ? '—' : r.comment,
    );
  }
}

class _BookingContractRatingReviewSectionState
    extends State<BookingContractRatingReviewSection> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _historyExpanded = true;

  String get _contractIdForApi =>
      widget.contract.id ?? widget.contract.contractId ?? '';

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  List<_PastReview> _reviewsForDisplay(ContractController c) =>
      c.contractRatings.map(_PastReview.fromApi).toList();

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      customToaster('Please select a rating', color: Colors.red);
      return;
    }
    if (_contractIdForApi.isEmpty) {
      customToaster('Contract ID not found', color: Colors.red);
      return;
    }
    final c = Get.find<ContractController>();
    final ok = await c.createContractRating(
      contractId: _contractIdForApi,
      rating: _selectedRating,
      comment: _reviewController.text.trim(),
    );
    if (ok && mounted) {
      setState(() {
        _selectedRating = 0;
        _reviewController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contractController = Get.find<ContractController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate & Review',
          style: poppinFonts(
            fontSize: base,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        SpaceHelper(h: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColor.cardBorderColorGrey),
            boxShadow: [
              BoxShadow(
                color: AppColor.cardShadowColor.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColor.lightSecondary,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColor.borderGreen, width: 1),
                ),
                child: Text(
                  'You can submit a new review for this month',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightGreenColorText,
                  ),
                ),
              ),
              SpaceHelper(h: 16.h),
              Text(
                'Your Rating',
                style: poppinFonts(
                  fontSize: sm,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final filled = starIndex <= _selectedRating;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = starIndex;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        filled ? Icons.star : Icons.star_border,
                        size: 32.w,
                        color: filled
                            ? AppColor.primary
                            : AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  );
                }),
              ),
              SpaceHelper(h: 16.h),
              Text(
                'Your Review',
                style: poppinFonts(
                  fontSize: sm,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 8.h),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                maxLength: 500,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => const SizedBox.shrink(),
                inputFormatters: [LengthLimitingTextInputFormatter(500)],
                style: poppinFonts(fontSize: sm, color: AppColor.black),
                decoration: InputDecoration(
                  hintText:
                      'Share your experience with this transport service...',
                  hintStyle: poppinFonts(
                    fontSize: sm,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: AppColor.textFieldBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: AppColor.textFieldBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: AppColor.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SpaceHelper(h: 6.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_reviewController.text.length}/500 characters',
                  style: poppinFonts(
                    fontSize: xs,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ),
              SpaceHelper(h: 16.h),
              Obx(
                () => CustomButton(
                  isLoading: contractController.isSubmittingRating.value,
                  onPressed: contractController.isSubmittingRating.value
                      ? null
                      : _submit,
                  title: 'Submit Review',
                ),
              ),
            ],
          ),
        ),
        SpaceHelper(h: 12.h),
        InkWell(
          onTap: () {
            setState(() {
              _historyExpanded = !_historyExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Review History',
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    _historyExpanded ? 'Hide' : 'Show',
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                  Icon(
                    _historyExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColor.textLightBlackColor4A4A4A,
                    size: 22.w,
                  ),
                ],
              ),
            ],
          ),
        ),
        SpaceHelper(h: 12.h),
        if (_historyExpanded)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColor.cardBorderColorGrey),
              boxShadow: [
                BoxShadow(
                  color: AppColor.cardShadowColor.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final loading = contractController.isLoadingRatings.value;
                  final reviews = _reviewsForDisplay(contractController);

                  if (loading) {
                    return Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Center(
                        child: SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  if (contractController.contractRatings.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Center(
                        child: Text(
                          'No ratings yet',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpaceHelper(h: 12.h),
                      ...reviews.asMap().entries.map((entry) {
                        final i = entry.key;
                        final r = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (i > 0) ...[
                              Divider(
                                height: 20.h,
                                thickness: 1,
                                color: AppColor.cardBorderColorGrey,
                              ),
                            ],
                            Text(
                              AppDateTimeFormatter.format(
                                r.periodMonth,
                                pattern: 'MMMM yyyy',
                              ),
                              style: poppinFonts(
                                fontSize: sm,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            SpaceHelper(h: 4.h),
                            Text(
                              "Submitted on ${AppDateTimeFormatter.format(r.submittedAt, pattern: 'd MMMM yyyy')}",
                              style: poppinFonts(
                                fontSize: xs,
                                color: AppColor.textLightBlackColor4A4A4A,
                              ),
                            ),
                            SpaceHelper(h: 8.h),
                            Row(
                              children: [
                                ...List.generate(5, (si) {
                                  return Icon(
                                    si < r.rating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16.w,
                                    color: AppColor.primary,
                                  );
                                }),
                                SpaceHelper(w: 8.w),
                                Text(
                                  r.rating.toStringAsFixed(1),
                                  style: poppinFonts(
                                    fontSize: sm,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 8.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                r.text,
                                style: poppinFonts(
                                  fontSize: sm,
                                  color: AppColor.black,
                                ).copyWith(height: 1.35),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
