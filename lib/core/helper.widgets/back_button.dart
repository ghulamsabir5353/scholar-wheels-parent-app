import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

GestureDetector backButton({required VoidCallback onTap, EdgeInsets? padding}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w),
      child: SvgPicture.asset(
        'assets/images/svg/back_button.svg',
        width: 24.w,
        height: 24.w,
      ),
    ),
  );
}
