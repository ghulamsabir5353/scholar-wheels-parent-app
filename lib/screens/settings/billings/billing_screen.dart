import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/settings/billings/billing_history_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';

class BillingScreen extends StatelessWidget {
  static const route = '/billing';
  const BillingScreen({super.key});

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
        centerTitle: false,
        title: Text(
          'Billing and Subscription',
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Plan Section
              Text(
                'Current Plan',
                style: poppinFonts(
                  fontSize: lg,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 12.w),
              _buildCurrentPlanCard(),
              SpaceHelper(h: 32.w),
              // Billing History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Billing History',
                    style: poppinFonts(
                      fontSize: lg,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(BillingHistoryScreen.route);
                    },
                    child: Text(
                      'See All',
                      style: poppinFonts(
                        fontSize: base,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 12.w),
              _buildBillingHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.lightSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Monthly',
                    style: poppinFonts(
                      fontSize: base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  SpaceHelper(h: 4.w),
                  Text(
                    'Monthly subscription',
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$29.99',
                    style: poppinFonts(
                      fontSize: xxl,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  SpaceHelper(h: 4.w),
                  Text(
                    'per month',
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textLightBlackColor4A4A4A,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpaceHelper(h: 16.w),
          // Features Included
          Text(
            'Features Included:',
            style: poppinFonts(
              fontSize: base,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
          ),
          SpaceHelper(h: 8.w),
          _buildFeatureItem('Real-time Ride Tracking'),
          _buildFeatureItem('Unlimited Chat Support'),
          _buildFeatureItem('Detailed Trip Reports'),
          _buildFeatureItem('Contract Management'),
          _buildFeatureItem('Priority Support'),
          SpaceHelper(h: 16.w),
          // Expiration Info
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20.w, color: AppColor.primary),
                SpaceHelper(w: 8.w),
                Text(
                  'Expires on April 15, 2024 (12 days left)',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
          SpaceHelper(h: 16.w),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColor.lightSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.primary, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
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
                child: CustomButton(
                  onPressed: () {
                    Get.toNamed(SubscriptionPlansScreen.route);
                  },
                  height: 36.h,
                  title: 'Upgrade',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/svg/check_icon.svg'),
          SpaceHelper(w: 8.w),
          Text(
            feature,
            style: poppinFonts(
              fontSize: xs,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistoryList() {
    return Column(
      children: List.generate(3, (index) {
        return _buildBillingCard(
          invoiceNumber: 'INV-2024-003',
          date: 'March 15, 2024',
          amount: '\$29.99',
          status: 'Paid',
        );
      }),
    );
  }

  Widget _buildBillingCard({
    required String invoiceNumber,
    required String date,
    required String amount,
    required String status,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.black, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      invoiceNumber,
                      style: poppinFonts(
                        fontSize: base,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    SpaceHelper(w: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.lightSecondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status,
                        style: poppinFonts(
                          fontSize: xs,
                          fontWeight: FontWeight.w400,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SpaceHelper(h: 4.w),
                Text(
                  date,
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textLightBlackColor4A4A4A,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 4.w),
              SvgPicture.asset('assets/images/svg/document-download.svg'),
            ],
          ),
        ],
      ),
    );
  }
}
