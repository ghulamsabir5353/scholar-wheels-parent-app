import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class BillingHistoryScreen extends StatelessWidget {
  static const route = '/billing-history';
  const BillingHistoryScreen({super.key});

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
          'Billing History',
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(color: AppColor.lightSecondary),
        child: ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: 8, // Number of billing entries
          itemBuilder: (context, index) {
            return _buildBillingCard(
              invoiceNumber: 'INV-2024-003',
              date: 'March 15, 2024',
              amount: '\$29.99',
              status: 'Paid',
            );
          },
        ),
      ),
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
          // Left section - Invoice details
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
                        fontWeight: FontWeight.w500,
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
          // Right section - Amount and download icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: poppinFonts(fontSize: base, fontWeight: FontWeight.w500),
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
