import 'package:flutter/material.dart';

class SpaceHelper extends StatelessWidget {
  double? h;
  double? w;
  SpaceHelper({super.key, this.w, this.h});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
    );
  }
}
