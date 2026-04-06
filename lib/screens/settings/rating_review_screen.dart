import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class RatingReviewScreen extends StatelessWidget {
  static const route = '/rating-review';
  const RatingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          'Rating and Reviews',
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Pending Rating Card
          _buildRatingCard(
            context: context,
            isPending: true,
            serviceName: 'TransportCo Services',
            busNumber: 'Bus #12 (ABC-123)',
            pickupAddress: 'Pickup: 123 Maple Street',
            schoolName: 'School: Lincoln Elementary School',
            driverName: 'Driver: Michael Rodriguez',
            vehicleInfo: 'Vehicle: Blue Toyota Hiace - ABC 123',
            rating: '4.9',
            reviewCount: '23',
          ),
          SpaceHelper(h: 16.w),
          // Submitted Review Card
          _buildRatingCard(
            context: context,
            isPending: false,
            serviceName: 'TransportCo Services',
            busNumber: 'Bus #12 (ABC-123)',
            pickupAddress: 'Pickup: 123 Maple Street',
            schoolName: 'School: Lincoln Elementary School',
            driverName: 'Driver: Michael Rodriguez',
            vehicleInfo: 'Vehicle: Blue Toyota Hiace - ABC 123',
            rating: '4.9',
            reviewCount: '23',
            userRating: '5',
            userReview:
                'ipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud',
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _RatingDialog();
      },
    );
  }

  Widget _buildRatingCard({
    required BuildContext context,
    required bool isPending,
    required String serviceName,
    required String busNumber,
    required String pickupAddress,
    required String schoolName,
    required String driverName,
    required String vehicleInfo,
    required String rating,
    required String reviewCount,
    String? userRating,
    String? userReview,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Details
          Text(
            serviceName,
            style: poppinFonts(
              fontSize: base,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
          ),
          SpaceHelper(h: 4.w),
          Text(
            busNumber,
            style: poppinFonts(
              fontSize: sm,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
          ),
          SpaceHelper(h: 8.w),
          Row(
            children: [
              SvgPicture.asset('assets/images/svg/pickup-icon.svg'),
              SpaceHelper(w: 4.w),
              Text(
                pickupAddress,
                style: poppinFonts(
                  fontSize: xs,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            ],
          ),
          SpaceHelper(h: 4.w),
          Row(
            children: [
              SvgPicture.asset('assets/images/svg/pickup-icon.svg'),
              SpaceHelper(w: 4.w),
              Text(
                schoolName,
                style: poppinFonts(
                  fontSize: xs,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            ],
          ),
          SpaceHelper(h: 12.w),
          // Driver and Vehicle Info Box
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.lightSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: poppinFonts(
                    fontSize: xs,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ),
                SpaceHelper(h: 4.w),
                Text(
                  vehicleInfo,
                  style: poppinFonts(
                    fontSize: xs,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ),
                SpaceHelper(h: 4.w),
                Row(
                  children: [
                    Text(
                      'Rating: $rating',
                      style: poppinFonts(
                        fontSize: xs,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    ),
                    SpaceHelper(w: 4.w),
                    Icon(Icons.star, size: 14.w, color: AppColor.secondary),
                    SpaceHelper(w: 4.w),
                    Text(
                      '($reviewCount Reviews)',
                      style: poppinFonts(
                        fontSize: xs,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // User Rating and Review (if submitted)
          if (!isPending && userRating != null && userReview != null) ...[
            SpaceHelper(h: 12.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.lightSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Your Rating: $userRating',
                        style: poppinFonts(
                          fontSize: xs,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black,
                        ),
                      ),
                      SpaceHelper(w: 4.w),
                      Icon(Icons.star, size: 14.w, color: AppColor.secondary),
                    ],
                  ),
                  SpaceHelper(h: 4.w),
                  Text(
                    'Review: $userReview',
                    style: poppinFonts(
                      fontSize: xs,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Rate Now Button (if pending)
          if (isPending) ...[
            SpaceHelper(h: 12.w),
            CustomButton(
              onPressed: () {
                _showRatingDialog(context);
              },

              title: 'Rate Now',
            ),
          ],
        ],
      ),
    );
  }
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog();

  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColor.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate Our App!',
                  style: poppinFonts(
                    fontSize: base,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SpaceHelper(h: 12.w),
            // Service Info
            Text(
              'TransportCo Services',
              style: poppinFonts(
                fontSize: sm,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
            ),
            SpaceHelper(h: 4.w),
            Text(
              'Bus #12 (ABC-123)',
              style: poppinFonts(
                fontSize: xs,
                fontWeight: FontWeight.w400,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 16.w),
            // Rating Prompt
            Text(
              'How would you rate this service?',
              style: poppinFonts(
                fontSize: sm,
                fontWeight: FontWeight.w400,
                color: AppColor.black,
              ),
            ),
            SpaceHelper(h: 12.w),
            // Star Rating
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star_border,
                      size: 32.w,
                      color: index < selectedRating
                          ? Colors.red
                          : AppColor.textLightBlackColor4A4A4A,
                    ),
                  );
                }),
              ),
            ),
            SpaceHelper(h: 16.w),
            // Feedback Section
            Text(
              'Share your experience (optional)',
              style: poppinFonts(
                fontSize: sm,
                fontWeight: FontWeight.w400,
                color: AppColor.black,
              ),
            ),
            SpaceHelper(h: 8.w),
            CustomTextField(
              controller: reviewController,
              hintText: 'Tell us something through you reviews',
              hintStyle: poppinFonts(
                fontSize: xs,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 12.w),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderGreen, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        'Skip',
                        style: poppinFonts(
                          fontSize: base,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SpaceHelper(w: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Handle submit rating
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: poppinFonts(
                            fontSize: base,
                            fontWeight: FontWeight.w500,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
