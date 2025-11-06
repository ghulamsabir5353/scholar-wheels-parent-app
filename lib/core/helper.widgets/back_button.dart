import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

GestureDetector backButton({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SvgPicture.asset(
        'assets/images/svg/back_button.svg',
        width: 32,
        height: 32,
      ),
    ),
  );
}
