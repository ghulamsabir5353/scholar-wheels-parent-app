import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/billing_controller.dart';
import 'package:scholarwheels/controllers/subscription_controller.dart';
import 'package:scholarwheels/models/subscription.dart';
import 'package:scholarwheels/screens/tab_screen.dart';
import 'package:scholarwheels/services/api_state.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  static const route = '/subscription-plans';
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen>
    with WidgetsBindingObserver {
  Subscriptions? _selectedPlan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer fetch to after first frame to avoid setState/markNeedsBuild during build (Obx)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshMySubscription();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResumed();
    }
  }

  /// On app resume (e.g. return from payment): refetch subscription and redirect to dashboard if user now has a plan.
  Future<void> _onResumed() async {
    await _refreshMySubscription();
    if (!mounted) return;
    if (BaseHelper.mySubscription.value?.hasActiveSubscription == true) {
      Get.offAllNamed(TabScreen.route);
    }
  }

  /// Fetch GET usersubscription/me and update BaseHelper. Returns when fetch completes.
  Future<void> _refreshMySubscription() async {
    final billing = Get.isRegistered<BillingController>()
        ? Get.find<BillingController>()
        : Get.put(BillingController());
    await billing.fetchMySubscription();
  }

  @override
  Widget build(BuildContext context) {
    final fromProfileCompletion =
        Get.arguments?['fromProfileCompletion'] == true;
    final controller = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController(), permanent: false);

    return PopScope(
      canPop: !fromProfileCompletion,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          titleSpacing: 0,
          leading: backButton(
            onTap: () {
              if (fromProfileCompletion) {
                // User must have subscription to access dashboard; back does nothing
                return;
              }
              Get.back();
            },
          ),

          centerTitle: false,
          title: Text(
            'Subscription Plans',
            style: poppinFonts(
              fontSize: lg,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
        ),
        body: Obx(() {
          final state = controller.subscriptionsState.value;

          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is ErrorState<List<Subscriptions>>) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.w,
                      color: AppColor.redColor,
                    ),
                    SpaceHelper(h: 16.w),
                    Text(
                      state.message,
                      style: poppinFonts(
                        fontSize: base,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SpaceHelper(h: 24.w),
                    CustomButton(
                      title: 'Retry',
                      onPressed: () => controller.getSubscriptionPlans(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is EmptyState<List<Subscriptions>>) {
            return Center(
              child: Text(
                state.message,
                style: poppinFonts(
                  fontSize: base,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          final subscriptions = controller.subscriptions;
          if (subscriptions.isEmpty) {
            return Center(
              child: Text(
                'No plans available',
                style: poppinFonts(
                  fontSize: base,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
            );
          }

          // Default select first active/public plan if none selected
          Subscriptions? selected = _selectedPlan;
          if (selected == null && subscriptions.isNotEmpty) {
            selected = subscriptions.firstWhere(
              (p) => (p.isActive ?? false) && (p.isPublic ?? true),
              orElse: () => subscriptions.first,
            );
          }

          final fromProfileCompletion =
              Get.arguments?['fromProfileCompletion'] == true;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                  child: Column(
                    children: subscriptions.map((plan) {
                      final isSelected = selected?.id == plan.id;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _PlanCard(
                          plan: plan,
                          isSelected: isSelected,
                          onTap: () {
                            if (plan.isActive == true &&
                                plan.isPublic == true) {
                              setState(() => _selectedPlan = plan);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                color: AppColor.backgroundColor,
                child: Column(
                  children: [
                    Obx(() {
                      final billingCtrl = Get.isRegistered<BillingController>()
                          ? Get.find<BillingController>()
                          : null;
                      final isLoadingSubscription =
                          billingCtrl?.isLoadingMySubscription.value ?? false;
                      final isRequestingPayment =
                          controller.isRequestingPayment.value;

                      final mySub = BaseHelper.mySubscription.value;
                      final hasActiveSubscription =
                          mySub?.hasActiveSubscription == true;
                      final currentPlanId = mySub?.subscription?.planId?.id;

                      // Disable only when selected plan is the user's current plan
                      final isCurrentPlanSelected =
                          hasActiveSubscription &&
                          selected != null &&
                          currentPlanId != null &&
                          selected.id == currentPlanId;

                      final isPlanSelectable =
                          selected != null &&
                          (selected.isActive ?? false) &&
                          (selected.isPublic ?? true);
                      final canSubscribe =
                          !isLoadingSubscription &&
                          !isRequestingPayment &&
                          isPlanSelectable &&
                          !isCurrentPlanSelected;

                      String buttonTitle;
                      if (isLoadingSubscription) {
                        buttonTitle = 'Refreshing...';
                      } else if (isRequestingPayment) {
                        buttonTitle = 'Processing...';
                      } else if (isCurrentPlanSelected) {
                        buttonTitle = 'You already have this plan';
                      } else {
                        buttonTitle = fromProfileCompletion
                            ? 'Start Free Trial'
                            : 'Subscribe';
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isLoadingSubscription) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.primary,
                                  ),
                                ),
                                SpaceHelper(w: 8.w),
                                Text(
                                  'Refreshing your plan...',
                                  style: poppinFonts(
                                    fontSize: sm,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.textLightBlackColor4A4A4A,
                                  ),
                                ),
                              ],
                            ),
                            SpaceHelper(h: 12.h),
                          ],
                          CustomButton(
                            onPressed: canSubscribe
                                ? () {
                                    if (selected!.id != null) {
                                      controller.requestPayment(
                                        subscriptionPlanId: selected.id!,
                                      );
                                    } else {
                                      customToaster(
                                        'Subscription plan ID not found',
                                        color: AppColor.redColor,
                                      );
                                    }
                                  }
                                : null,
                            isLoading: isRequestingPayment,
                            title: buttonTitle,
                            gradient: LinearGradient(
                              colors: canSubscribe
                                  ? [AppColor.primary, AppColor.primary]
                                  : [Colors.grey, Colors.grey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            style: poppinFonts(
                              fontSize: base,
                              fontWeight: FontWeight.w600,
                              color: AppColor.white,
                            ),
                          ),
                          if (fromProfileCompletion &&
                              hasActiveSubscription) ...[
                            SpaceHelper(h: 12.h),
                            TextButton(
                              onPressed: () => Get.offAllNamed(TabScreen.route),
                              child: Text(
                                'Go to dashboard',
                                style: poppinFonts(
                                  fontSize: base,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                    SpaceHelper(h: 12.h),
                    Text(
                      fromProfileCompletion
                          ? 'First month free. Cancel at anytime. No commitment.'
                          : 'Cancel at anytime. No commitment',
                      style: poppinFonts(
                        fontSize: sm,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Subscriptions plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currency = plan.currency ?? 'ZAR';
    final price = plan.price ?? 0;
    final billingType = (plan.billingType ?? 'monthly').toLowerCase();
    final symbol = currency.toUpperCase() == 'ZAR' ? 'R' : '\$';
    String priceLabel = '$symbol$price';
    if (billingType == 'monthly') {
      priceLabel += '/month';
    } else if (billingType == 'yearly') {
      priceLabel += '/year';
    } else {
      priceLabel += '/$billingType';
    }

    // Description: first feature or duration + type
    final features = plan.features ?? [];
    final description = features.isNotEmpty
        ? (features.first.text ??
              '${plan.durationInDays ?? 30} days • $billingType')
        : '${plan.durationInDays ?? 30} days • $billingType';

    return GestureDetector(
      onTap: (plan.isActive == true && plan.isPublic == true) ? onTap : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.lightPurple : AppColor.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColor.primary.withOpacity(0.5)
                    : AppColor.cardBorderColorGrey,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.cardShadowColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio indicator
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColor.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColor.primary
                            : AppColor.textLightBlackColor4A4A4A,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.w,
                            color: AppColor.white,
                          )
                        : null,
                  ),
                ),
                SpaceHelper(w: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name ?? 'Plan',
                        style: poppinFonts(
                          fontSize: base,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                      SpaceHelper(h: 4.h),
                      Text(
                        description,
                        style: poppinFonts(
                          fontSize: sm,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textLightBlackColor4A4A4A,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SpaceHelper(h: 8.h),
                      Text(
                        priceLabel,
                        style: poppinFonts(
                          fontSize: base,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
