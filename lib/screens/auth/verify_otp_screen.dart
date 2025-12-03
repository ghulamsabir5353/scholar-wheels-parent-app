import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/forgot_password_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/core/helper.widgets/focus_manager.dart';
import '../../core/helper.constants/textStyle.dart';

class VerifyOTPScreen extends StatefulWidget {
  static const route = '/verify-otp';
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  late final ForgotPasswordController controller;
  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Get or create controller - use find with put fallback to reuse existing instance
    try {
      controller = Get.find<ForgotPasswordController>();
    } catch (e) {
      controller = Get.put(ForgotPasswordController());
    }

    // Initialize 6 OTP input fields
    for (int i = 0; i < 6; i++) {
      _otpControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPChanged(int index, String value) {
    // Clear error when user starts typing
    if (_hasError || controller.hasOTPError.value) {
      setState(() {
        _hasError = false;
      });
      controller.hasOTPError.value = false;
      controller.otpErrorMessage.value = '';
    }

    if (value.length == 1 && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Update the combined OTP in controller
    final otp = _otpControllers.map((c) => c.text).join();
    controller.otpController.text = otp;

    // Auto verify when all 6 digits are entered
    if (otp.length == 6) {
      _verifyOTP();
    }
  }

  void _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      controller.otpController.text = otp;
      final success = await controller.verifyOTP();

      // If verification failed, show error
      if (!success && mounted) {
        setState(() {
          _hasError = true;
        });
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } else {
      setState(() {
        _hasError = true;
      });
    }
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
          leading: backButton(onTap: () => Get.back()),
          title: Text(
            'Verify OTP',
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
                  'Verify OTP',
                  style: poppinFonts(fontWeight: FontWeight.w600, fontSize: 26),
                ),
                SpaceHelper(h: 8),
                Text(
                  'We\'ve sent a reset password to your email. Please check your inbox or spam folder for verification',
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
                  final hasError = _hasError || controller.hasOTPError.value;
                  return Row(
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: AspectRatio(
                            aspectRatio: 1, // width == height
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: poppinFonts(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: hasError
                                        ? Colors.red
                                        : AppColor.textFieldBorderColor,
                                    width: hasError ? 2 : 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: hasError
                                        ? Colors.red
                                        : AppColor.textFieldBorderColor,
                                    width: hasError ? 2 : 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: hasError
                                        ? Colors.red
                                        : AppColor.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) => _onOTPChanged(index, value),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                SpaceHelper(h: 8),
                Obx(() {
                  if (controller.hasOTPError.value || _hasError) {
                    final msg = controller.otpErrorMessage.value.isNotEmpty
                        ? controller.otpErrorMessage.value
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
                  if (controller.isResendingOTP.value) {
                    return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => controller.resendOTP(),
                    child: Text(
                      'Resend',
                      style: poppinFonts(
                        fontSize: 14,
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
                SpaceHelper(h: 32),
                Obx(
                  () => CustomButton(
                    isLoading: controller.isVerifyingOTP.value,
                    onPressed: controller.isVerifyingOTP.value
                        ? null
                        : () {
                            final otp = _otpControllers
                                .map((c) => c.text)
                                .join();
                            if (otp.length == 6) {
                              _verifyOTP();
                            } else {
                              setState(() {
                                _hasError = true;
                              });
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
