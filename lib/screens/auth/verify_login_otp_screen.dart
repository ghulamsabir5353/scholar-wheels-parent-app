import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import '../../core/helper.constants/textStyle.dart';

class VerifyLoginOTPScreen extends StatefulWidget {
  static const route = '/verify-login-otp';
  const VerifyLoginOTPScreen({super.key});

  @override
  State<VerifyLoginOTPScreen> createState() => _VerifyLoginOTPScreenState();
}

class _VerifyLoginOTPScreenState extends State<VerifyLoginOTPScreen> {
  late final AuthController controller;
  final TextEditingController _pinController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<AuthController>();
    } catch (e) {
      controller = Get.put(AuthController());
    }

    final args = Get.arguments;
    if (args is Map) {
      if (args['email'] != null) {
        controller.loginEmail = args['email'] as String;
      }
      if (args['challengeToken'] != null) {
        controller.challengeToken = args['challengeToken'] as String;
      }
    }

    if (controller.loginCountdownSeconds.value == 60 ||
        controller.canResendLoginOTP.value) {
      controller.startLoginCountdown();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    if (_hasError || controller.hasLoginOTPError.value) {
      setState(() => _hasError = false);
      controller.hasLoginOTPError.value = false;
      controller.loginOTPErrorMessage.value = '';
    }
    controller.loginOtpController.text = value;
  }

  void _verifyOTP() async {
    final otp = _pinController.text.trim();
    if (otp.length == 6) {
      controller.loginOtpController.text = otp;
      final success = await controller.verifyLoginOTP();

      if (!success && mounted) {
        setState(() => _hasError = true);
        _pinController.clear();
        controller.loginOtpController.clear();
      }
    } else {
      setState(() => _hasError = true);
    }
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
  Widget build(BuildContext context) {
    return KeyboardNavigator(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          centerTitle: false,
          titleSpacing: 0,
          leading: backButton(onTap: () => Get.back()),
          title: Text(
            'Verify Login',
            style: poppinFonts(
              fontSize: 18,
              color: AppColor.headingFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BaseHelper.getLogo(width: 160, height: 80),
                Text(
                  'Verify Your Login',
                  style: poppinFonts(fontWeight: FontWeight.w600, fontSize: 26),
                ),
                SpaceHelper(h: 8),
                Text(
                  'We\'ve sent a verification code to your email. Please check your inbox or spam folder. This OTP will expire in 1 minute.',
                  textAlign: TextAlign.center,
                  style: poppinFonts(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.lightGreenColorText,
                  ),
                ),
                SpaceHelper(h: 32),
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
                SpaceHelper(h: 12),
                Obx(() {
                  final hasError =
                      _hasError || controller.hasLoginOTPError.value;
                  return Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    length: 6,
                    controller: _pinController,
                    onChanged: _onPinChanged,
                    onCompleted: (pin) {
                      controller.loginOtpController.text = pin;
                      _verifyOTP();
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
                  );
                }),
                SpaceHelper(h: 8),
                Obx(() {
                  if (controller.hasLoginOTPError.value || _hasError) {
                    final msg = controller.loginOTPErrorMessage.value.isNotEmpty
                        ? controller.loginOTPErrorMessage.value
                        : 'Please enter valid OTP';
                    return Row(
                      children: [
                        Text(
                          msg,
                          style: poppinFonts(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SpaceHelper(h: 8),
                Obx(() {
                  if (controller.isResendingLoginOTP.value) {
                    return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    );
                  }
                  if (controller.canResendLoginOTP.value) {
                    return GestureDetector(
                      onTap: () {
                        _pinController.clear();
                        controller.resendLoginOTP();
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
                  } else {
                    return Text(
                      'Resend OTP in ${controller.formattedLoginCountdown}',
                      style: poppinFonts(
                        fontSize: 14,
                        color: AppColor.textLightBlackColor4A4A4A,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                }),
                SpaceHelper(h: 32),
                Obx(
                  () => CustomButton(
                    isLoading: controller.isVerifyingLoginOTP.value,
                    onPressed: controller.isVerifyingLoginOTP.value
                        ? null
                        : () {
                            final otp = _pinController.text.trim();
                            if (otp.length == 6) {
                              _verifyOTP();
                            } else {
                              setState(() => _hasError = true);
                            }
                          },
                    title: 'Verify OTP',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
