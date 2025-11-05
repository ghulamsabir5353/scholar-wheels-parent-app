import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';

poppinFonts({double? fontSize, FontWeight? fontWeight, Color? color}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: (fontSize ?? 14).sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? AppColor.appBlackColor,
  );
}
