import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/billing_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/date_time_formatter.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/subscription_invoice_model.dart';
import 'package:scholarwheels/models/user_subscription_me_model.dart';
import 'package:scholarwheels/screens/settings/billings/billing_history_screen.dart';
import 'package:scholarwheels/screens/settings/billings/subscription_plans_screen.dart';

class BillingScreen extends StatefulWidget {
  static const route = '/billing';
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen>
    with WidgetsBindingObserver {
  late final BillingController _ctrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ctrl = Get.put(BillingController());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ctrl.fetchMySubscription();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        titleSpacing: 0,
        leading: backButton(onTap: () => Get.back()),
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
      body: Obx(() {
        final loading = _ctrl.isLoadingMySubscription.value;
        final me = _ctrl.mySubscription.value;
        final hasActivePlan =
            me?.hasActiveSubscription == true &&
            me?.subscription != null &&
            me!.subscription!.planId != null;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Plan',
                  style: poppinFonts(
                    fontSize: lg,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                SpaceHelper(h: 12.w),
                if (loading)
                  _buildCurrentPlanLoading()
                else if (!hasActivePlan)
                  _buildNoPlanCard()
                else
                  _buildCurrentPlanCard(me.subscription!),
                SpaceHelper(h: 32.w),
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
                      onTap: () => Get.toNamed(BillingHistoryScreen.route),
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
        );
      }),
    );
  }

  Widget _buildCurrentPlanLoading() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cardBorderColorGrey),
      ),
      child: Center(child: CircularProgressIndicator(color: AppColor.primary)),
    );
  }

  Widget _buildNoPlanCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cardBorderColorGrey),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You don\'t have an active subscription',
            style: poppinFonts(
              fontSize: base,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
          ),
          SpaceHelper(h: 8.w),
          Text(
            'Subscribe to a plan to unlock booking, chat, and more.',
            style: poppinFonts(
              fontSize: sm,
              fontWeight: FontWeight.w400,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
          SpaceHelper(h: 16.w),
          CustomButton(
            onPressed: () {
              Get.toNamed(
                SubscriptionPlansScreen.route,
              )?.then((_) => _ctrl.fetchMySubscription());
            },
            title: 'View plans',
            height: 44.h,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(UserSubscriptionDetail detail) {
    final plan = detail.planId!;
    final price = plan.price ?? 0;
    final currency = plan.currency ?? 'ZAR';
    final displayPrice = currency.toUpperCase() == 'ZAR'
        ? 'R $price'
        : '$currency $price';
    final billingType = (plan.billingType ?? 'monthly').toLowerCase();
    final perPeriod = billingType == 'monthly' ? 'per month' : 'per year';
    final features = plan.features ?? [];
    final periodStart = AppDateTimeFormatter.toLocal(detail.currentPeriodStart);
    final periodEnd = AppDateTimeFormatter.toLocal(detail.currentPeriodEnd);
    String periodText = '';
    if (periodEnd != null) {
      final endStr = AppDateTimeFormatter.format(
        periodEnd,
        pattern: 'MMMM d, yyyy',
      );
      final now = DateTime.now();
      final daysLeft = periodEnd.difference(now).inDays;
      periodText = daysLeft >= 0
          ? 'Current period ends $endStr ($daysLeft days left)'
          : 'Ended on $endStr';
    } else if (periodStart != null) {
      periodText =
          "Started ${AppDateTimeFormatter.format(periodStart, pattern: 'MMMM d, yyyy')}";
    } else {
      periodText = 'Active';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.lightSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderGreen),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadowColorGreen.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name ?? 'Plan',
                    style: poppinFonts(
                      fontSize: base,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                  SpaceHelper(h: 4.w),
                  Text(
                    '${plan.durationInDays ?? 30} days',
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
                    displayPrice,
                    style: poppinFonts(
                      fontSize: xxl,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  SpaceHelper(h: 4.w),
                  // Text(
                  //   perPeriod,
                  //   style: poppinFonts(
                  //     fontSize: sm,
                  //     fontWeight: FontWeight.w400,
                  //     color: AppColor.textLightBlackColor4A4A4A,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          if (features.isNotEmpty) ...[
            SpaceHelper(h: 16.w),
            Text(
              'Features Included:',
              style: poppinFonts(
                fontSize: base,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
            SpaceHelper(h: 8.w),
            ...features.map((f) => _buildFeatureItem(f.text ?? '')),
          ],
          SpaceHelper(h: 16.w),
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
                Expanded(
                  child: Text(
                    periodText,
                    style: poppinFonts(
                      fontSize: sm,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SpaceHelper(h: 16.w),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  return OutlinedButton(
                    onPressed: _ctrl.isCancelling.value
                        ? null
                        : () => _showCancelDialog(_ctrl),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.primary, width: 1),
                      foregroundColor: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _ctrl.isCancelling.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.primary,
                            ),
                          )
                        : Text(
                            'Cancel',
                            style: poppinFonts(
                              fontSize: base,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primary,
                            ),
                          ),
                  );
                }),
              ),
              SpaceHelper(w: 12.w),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Get.toNamed(
                      SubscriptionPlansScreen.route,
                    )?.then((_) => _ctrl.fetchMySubscription());
                  },
                  height: 44.h,
                  title: 'Change plan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BillingController ctrl) {
    final reasonController = TextEditingController(text: '');
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text(
          'Cancel subscription',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please tell us why you\'re cancelling (optional).',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
            SpaceHelper(h: 12.h),
            CustomTextField(
              controller: reasonController,
              hintText: 'Reason',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Keep subscription',
              style: poppinFonts(color: AppColor.primary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final reason = reasonController.text.trim().isEmpty
                  ? 'any'
                  : reasonController.text.trim();
              final success = await ctrl.cancelSubscription(reason: reason);
              if (success && Get.isDialogOpen == true) Get.back();
            },
            child: Text(
              'Cancel subscription',
              style: poppinFonts(
                color: AppColor.redColor,
                fontWeight: FontWeight.w600,
              ),
            ),
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
    return Obx(() {
      if (_ctrl.isLoadingInvoices.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CircularProgressIndicator(color: AppColor.primary),
          ),
        );
      }
      final list = _ctrl.invoices.take(5).toList();
      if (list.isEmpty) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.cardBorderColorGrey),
          ),
          child: Center(
            child: Text(
              'No billing history yet',
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
              ),
            ),
          ),
        );
      }
      return Column(
        children: list
            .map(
              (inv) => _buildBillingCard(
                invoiceNumber: inv.invoiceNumber ?? '—',
                date: inv.issuedAt != null
                    ? AppDateTimeFormatter.format(
                        inv.issuedAt,
                        pattern: 'MMM d, yyyy',
                      )
                    : '—',
                amount: _formatInvoiceAmount(inv),
                status: inv.status ?? '—',
              ),
            )
            .toList(),
      );
    });
  }

  String _formatInvoiceAmount(SubscriptionInvoice inv) {
    final amount = inv.amountGross ?? inv.amountNet ?? 0;
    final currency = inv.currency ?? 'ZAR';
    return currency.toUpperCase() == 'ZAR' ? 'R $amount' : '$currency $amount';
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
                        status.capitalizeFirst.toString(),
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
              // SvgPicture.asset('assets/images/svg/document-download.svg'),
            ],
          ),
        ],
      ),
    );
  }
}
