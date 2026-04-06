import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? borderRadius;
  final bool? isDisabled;

  const CustomOutlineButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height,
    this.borderRadius,
    this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 42.0.h,
      decoration: BoxDecoration(
        color: isDisabled ?? false ? AppColor.gray : AppColor.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0.r),
        border: Border.all(
          color: isDisabled ?? false ? AppColor.gray : AppColor.borderGreen,
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: isDisabled ?? false ? null : onPressed,
        child: Text(
          title,
          style: poppinFonts(
            color: isDisabled ?? false ? AppColor.white : AppColor.primary,
            fontSize: md,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
