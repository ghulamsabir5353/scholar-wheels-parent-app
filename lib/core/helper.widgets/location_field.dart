import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/screens/common/location_search_screen.dart';

class LocationField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(LocationData locationData)? onLocationSelected;
  final String? initialValue;
  final TextEditingController controller;

  const LocationField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onLocationSelected,
    this.initialValue,
  });

  Future<void> _openSearchScreen(BuildContext context) async {
    final result = await Get.toNamed(
      LocationSearchScreen.route,
      arguments: {
        'initialValue': controller.text.isNotEmpty
            ? controller.text
            : initialValue,
        'hintText': hintText,
      },
    );

    if (result != null && result is LocationData) {
      // Update controller
      controller.text = result.description;
      // Call callback if provided
      if (onLocationSelected != null) {
        onLocationSelected!(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      validator: validator,
      isReadOnly: true,
      onTap: () => _openSearchScreen(context),
      hasSuffixIcon: Padding(
        padding: EdgeInsets.all(12.w),
        child: SvgPicture.asset(
          'assets/images/svg/location.svg',
          width: 2.w,
          height: 2.h,
        ),
      ),
    );
  }
}
