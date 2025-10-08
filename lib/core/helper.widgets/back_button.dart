import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

GestureDetector backButton({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SvgPicture.asset(
        'assets/images/svg/back_button.svg',
        width: 32,
        height: 32,
      ),
    ),
  );
}
