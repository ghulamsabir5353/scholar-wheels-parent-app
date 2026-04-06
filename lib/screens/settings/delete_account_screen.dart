import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:scholarwheels/controllers/account_deletion_controller.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/auth/login_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const route = '/delete-account';
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  int _step = 0;
  bool _agreed = false;
  final TextEditingController _pinController = TextEditingController();

  AccountDeletionController get controller {
    if (!Get.isRegistered<AccountDeletionController>()) {
      Get.put(AccountDeletionController());
    }
    return Get.find<AccountDeletionController>();
  }

  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColor.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 12.w,
              top: 16.w,
              bottom: 16.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Account',
                      style: poppinFonts(
                        fontSize: lg,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Icon(Icons.close, size: 24.w),
                    ),
                  ],
                ),
                SpaceHelper(h: 12.w),
                Text(
                  'Are you sure? You want to delete this account. This action cannot be undone.',
                  style: poppinFonts(
                    fontSize: sm,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
                SpaceHelper(h: 16.w),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColor.cardBorderColorGrey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: poppinFonts(
                                fontSize: base,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SpaceHelper(w: 12.w),
                    Expanded(
                      child: Obx(
                        () => CustomButton(
                          height: 36.h,
                          isLoading: controller.isVerifying.value,
                          onPressed: controller.isVerifying.value
                              ? null
                              : () async {
                                  final success = await controller
                                      .verifyAccountDeletion();
                                  if (success && ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                    await BaseHelper.clearSession();
                                    Get.offAllNamed(LoginScreen.route);
                                  }
                                },
                          title: 'Delete',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PinTheme _pinTheme(Color borderColor, {double borderWidth = 1}) {
    return PinTheme(
      width: 44.w,
      height: 44.w,
      textStyle: poppinFonts(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        centerTitle: false,
        titleSpacing: 0,
        leading: backButton(onTap: () => Get.back()),
        title: Text(
          'Delete Account',
          style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
        ),
      ),
      body: _step == 0 ? _buildStep1() : _buildStep2(),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Account',
            style: poppinFonts(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.headingFontColor,
            ),
          ),
          SpaceHelper(h: 16.h),
          Text(
            'Deleting your parent account will permanently remove your access and all related data from the platform. Please review the actions below before proceeding.',
            style: poppinFonts(
              fontSize: sm,
              color: AppColor.textLightBlackColor4A4A4A,
              fontWeight: FontWeight.w400,
            ),
          ),
          SpaceHelper(h: 16.h),
          _bullet(
            'All child profiles linked to your account will be permanently deleted',
          ),
          SpaceHelper(h: 8.h),
          _bullet(
            'All active and past transport contracts with transport owners will be cancelled',
          ),
          SpaceHelper(h: 8.h),
          _bullet(
            'Any upcoming or scheduled transport bookings will be removed',
          ),
          SpaceHelper(h: 8.h),
          _bullet(
            'Ongoing rides associated with your children may be immediately terminated',
          ),
          SpaceHelper(h: 8.h),
          _bullet(
            'All personal information, preferences, and history will be permanently removed',
          ),
          SpaceHelper(h: 8.h),
          _bullet(
            'Any active subscription linked to your account will be cancelled without refund (if applicable)',
          ),
          SpaceHelper(h: 24.h),
          Row(
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                  activeColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SpaceHelper(w: 4.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Text(
                    'I have read and agree.',
                    style: poppinFonts(
                      fontSize: md,
                      color: AppColor.appBlackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SpaceHelper(h: 12.h),
          Obx(
            () => CustomButton(
              isLoading: controller.isRequesting.value,
              onPressed: controller.isRequesting.value
                  ? null
                  : () async {
                      if (!_agreed) {
                        Get.snackbar(
                          'Required',
                          'Please read and agree to continue.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade100,
                        );
                        return;
                      }
                      final success = await controller.requestAccountDeletion();
                      if (success && mounted) {
                        setState(() => _step = 1);
                        if (controller.countdownSeconds.value ==
                                AccountDeletionController
                                    .countdownDurationSeconds ||
                            controller.canResendOtp.value) {
                          controller.startCountdown();
                        }
                      }
                    },
              title: 'Next',
              isDisabled: !_agreed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: poppinFonts(
              fontSize: sm,
              color: AppColor.textLightBlackColor4A4A4A,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: poppinFonts(
                fontSize: sm,
                color: AppColor.textLightBlackColor4A4A4A,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return GetBuilder<AccountDeletionController>(
      init: controller,
      builder: (_) {
        final hasError = controller.hasOtpError.value;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              SpaceHelper(h: 24.h),
              Icon(
                Icons.verified_user_rounded,
                size: 80.w,
                color: AppColor.primary,
              ),
              SpaceHelper(h: 24.h),
              Text(
                'Verify Account',
                style: poppinFonts(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.headingFontColor,
                ),
              ),
              SpaceHelper(h: 8.h),
              Text(
                'Please verify your account by entering the OTP sent to your email.',
                textAlign: TextAlign.center,
                style: poppinFonts(
                  fontSize: sm,
                  color: AppColor.textLightBlackColor4A4A4A,
                ),
              ),
              SpaceHelper(h: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Enter OTP',
                      style: poppinFonts(
                        fontSize: 14,
                        color: AppColor.textLightBlackColor4A4A4A,
                      ),
                    ),
                  ],
                ),
              ),
              SpaceHelper(h: 12.h),
              Pinput(
                length: 6,
                controller: _pinController,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                onChanged: (v) {
                  controller.otpController.text = v;
                  if (controller.hasOtpError.value) {
                    controller.hasOtpError.value = false;
                    controller.otpErrorMessage.value = '';
                  }
                },
                onCompleted: (pin) {
                  controller.otpController.text = pin;
                  _showConfirmDeleteDialog();
                },
                defaultPinTheme: _pinTheme(
                  hasError ? Colors.red : AppColor.textFieldBorderColor,
                  borderWidth: hasError ? 2 : 1,
                ),
                focusedPinTheme: _pinTheme(
                  hasError ? Colors.red : AppColor.primary,
                  borderWidth: 2,
                ),
                submittedPinTheme: _pinTheme(AppColor.primary),
                errorPinTheme: _pinTheme(Colors.red, borderWidth: 2),
                forceErrorState: hasError,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SpaceHelper(h: 8.h),
              if (controller.hasOtpError.value)
                Row(
                  children: [
                    Text(
                      controller.otpErrorMessage.value.isNotEmpty
                          ? controller.otpErrorMessage.value
                          : 'Please enter valid OTP',
                      style: poppinFonts(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              SpaceHelper(h: 16.h),
              Obx(() {
                if (controller.isResendingOtp.value) {
                  return SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.primary,
                    ),
                  );
                }
                if (controller.canResendOtp.value) {
                  return GestureDetector(
                    onTap: () {
                      _pinController.clear();
                      controller.resendOtp();
                    },
                    child: Text(
                      'Resend OTP',
                      style: poppinFonts(
                        fontSize: 14,
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return Text(
                  'Resend OTP in ${controller.formattedCountdown}',
                  style: poppinFonts(
                    fontSize: 14,
                    color: AppColor.textLightBlackColor4A4A4A,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),
              SpaceHelper(h: 24.h),
              Obx(
                () => CustomButton(
                  isLoading: controller.isVerifying.value,
                  onPressed: controller.isVerifying.value
                      ? null
                      : () {
                          final otp = _pinController.text.trim();
                          if (otp.length == 6) {
                            controller.otpController.text = otp;
                            _showConfirmDeleteDialog();
                          } else {
                            controller.hasOtpError.value = true;
                            controller.otpErrorMessage.value =
                                'Please enter valid OTP';
                            controller.update();
                          }
                        },
                  title: 'Next',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
