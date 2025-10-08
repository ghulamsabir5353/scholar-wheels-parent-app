import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';

const TextStyle regular13textStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  fontFamily: 'Poppins',
);

poppinFonts({double? fontSize, FontWeight? fontWeight, Color? color}) {
  return GoogleFonts.poppins(
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? AppColor.appBlackColor,
  );
}
