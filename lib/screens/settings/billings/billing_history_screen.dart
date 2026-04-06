import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scholarwheels/controllers/billing_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/subscription_invoice_model.dart';

class BillingHistoryScreen extends StatelessWidget {
  static const route = '/billing-history';
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BillingController>()) {
      Get.put(BillingController());
    }
    final ctrl = Get.find<BillingController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(onTap: () => Get.back()),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          'Billing History',
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoadingInvoices.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }
        final list = ctrl.invoices;
        if (list.isEmpty) {
          return Center(
            child: Text(
              'No billing history yet',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final inv = list[index];
            return _buildBillingCard(
              invoiceNumber: inv.invoiceNumber ?? '—',
              date: inv.issuedAt != null
                  ? DateFormat('MMM d, yyyy').format(inv.issuedAt!)
                  : '—',
              amount: _formatAmount(inv),
              status: inv.status ?? '—',
            );
          },
        );
      }),
    );
  }

  String _formatAmount(SubscriptionInvoice inv) {
    final amount = inv.amountGross ?? inv.amountNet ?? 0;
    final currency = inv.currency ?? 'ZAR';
    return currency.toUpperCase() == 'ZAR' ? 'R$amount' : '$currency $amount';
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
        border: Border.all(color: AppColor.cardBorderColorGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
