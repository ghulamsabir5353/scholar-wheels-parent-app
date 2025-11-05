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

class SubscriptionPlansScreen extends StatelessWidget {
  static const route = '/subscription-plans';
  const SubscriptionPlansScreen({super.key});

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
              Text(
                'Select Plan',
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              SpaceHelper(h: 16.w),
              _buildPlanCard(
                planName: 'Premium Monthly',
                subtitle: 'Monthly subscription',
                price: '\$29.99',
                features: [
                  'Real-time Ride Tracking',
                  'Unlimited Chat Support',
                  'Detailed Trip Reports',
                  'Contract Management',
                  'Priority Support',
                ],
              ),
              SpaceHelper(h: 16.w),
              _buildPlanCard(
                planName: 'Standard',
                subtitle: 'Monthly subscription',
                price: '\$29.99',
                features: [
                  'Real-time Ride Tracking',
                  'Unlimited Chat Support',
                  'Detailed Trip Reports',
                  'Contract Management',
                  'Priority Support',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String planName,
    required String subtitle,
    required String price,
    required List<String> features,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: poppinFonts(
                      fontSize: base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  SpaceHelper(h: 4.w),
                  Text(
                    subtitle,
                    style: poppinFonts(
                      fontSize: xs,
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
                    price,
                    style: poppinFonts(
                      fontSize: xxl,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    'per month',
                    style: poppinFonts(
                      fontSize: xs,
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
              fontSize: sm,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
          ),
          SpaceHelper(h: 8.w),
          ...features.map((feature) => _buildFeatureItem(feature)),
          SpaceHelper(h: 16.w),
          // Subscribe Button
          CustomButton(
            onPressed: () {
              // TODO: Handle subscription
            },
            title: 'Subscribe Now',
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
}
