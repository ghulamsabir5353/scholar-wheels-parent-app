import 'package:flutter/material.dart';

abstract class AppColor {
  static const primary = Color(0xff047720);
  static const darkPrimary = Color(0xff00370C);
  static const lightSecondary = Color(0xffEDFFF1);
  static const secondary = Color(0xffADFFC1);
  static const darkSecondary = Color(0xff00EA34);

  static const borderGreen = Color(0xffBDF39A);
  static const recieverBubbleColor = Color(0xffE7E7E7);

  // static const backgroundColor = Color(0xfffafafa);
  static const lightGreenColorText = Color(0xff223A28);
  static const textLightBlackColor4A4A4A = Color(0xff4A4A4A);
  static const bottomNavigationGrayColor = Color(0xff888888);
  static const black = Color(0xff080C09);
  static const white = Colors.white;
  static const Color headingFontColor = Color(0xff2E2F30);
  ///////
  static const yellowText = Color(0xffFF9800);
  static const blueText = Color(0xff4169E1);
  static const textFieldBorderColor = Color(0xffC7CCD4);
  static const darkBlueColor = Color(0xff283E5C);
  static const backgroundColor = Color(0xffECECEC);
  static const bgGray979797 = Color(0xff979797);
  static const bgGrayD9D8D8 = Color(0xffD9D8D8);
  static const redColor = Color(0xffFF0000);
  static LinearGradient cardLinearGradient = const LinearGradient(
    colors: [Color(0xff537959), Color(0xff00C327)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  ////////
  static const purpleColor = Color(0xffC58BF2);
  static const appColorWhite = Colors.white;
  static const appBlackColor = Color(0xff1D1617);

  static const lightPurple = Color(0xffEAEFFF);
  static var bgColor = Colors.grey.shade50;
  static const LinearGradient linearGradient = LinearGradient(
    colors: [blueText, Color(0xffBAD4FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color gray = Color(0xffADA4A5);
  static const Color lightGray = Color(0xffff7f8f8);
  static const Color completedStatusColor = Color(0xff93AE3C);

  static const Color activeStatusColor = purpleColor;

  static const Color notCompletedStatusColor = Color(0xffC92727);
  static const Color disableColor = Color(0xff555555);
  static const LinearGradient disableColorLinearGradient = LinearGradient(
    colors: [disableColor, disableColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color textGrayColor = Color(0xff464545);
}
