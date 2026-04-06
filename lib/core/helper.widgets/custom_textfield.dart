import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isObsecure,
    this.fillColor,
    this.hasPrefixIcon,
    this.onChanged,
    this.labelColor,
    // this.hasSuffixOnTap,
    this.isReadOnly,
    this.maxLines,
    this.hintStyle,
    this.cursorColor,
    this.hasSuffixIcon,
    this.height,
    this.textInputAction,
    this.onFieldSubmit,
    this.isNumericKeyboard = false,
    this.onTap,
    this.initialValue,
    this.borderColor,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.label,
    this.semanticLabel,
    this.semanticHint,
    this.maxLength,
  }) : assert(
         isObsecure == null || hasSuffixIcon != null,
         'isObsecure or hasSuffixIcon must be provided',
       );

  String? hintText;
  TextEditingController? controller;
  bool? isObsecure;
  String? hasPrefixIcon;
  Widget? hasSuffixIcon;
  bool? isReadOnly;
  Color? labelColor;
  // VoidCallback? hasSuffixOnTap;
  VoidCallback? onTap;
  bool isNumericKeyboard;
  String? initialValue;
  Function(String)? onChanged;
  Function(String)? onFieldSubmit;
  TextInputAction? textInputAction;
  Color? fillColor;
  FocusNode? focusNode;
  Color? cursorColor;
  TextStyle? hintStyle;
  int? maxLines;
  double? height;
  Color? borderColor;
  String? label;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  String? semanticLabel;
  String? semanticHint;
  int? maxLength;

  @override
  Widget build(BuildContext context) {
    final String fieldLabel =
        semanticLabel ?? label ?? hintText ?? 'Text field';
    final String fieldHint = semanticHint ?? '';

    return Semantics(
      label: fieldLabel,
      hint: fieldHint.isNotEmpty ? fieldHint : null,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Semantics(
              label: 'Label for $fieldLabel',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  label!,
                  style: poppinFonts(
                    color: labelColor ?? AppColor.black,
                    fontSize: md,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          FormField<String>(
            initialValue: controller?.text ?? initialValue,
            validator:
                validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return "Field Required*";
                  }
                  return null;
                },
            builder: (field) {
              final hasError =
                  field.errorText != null && field.errorText!.isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height ?? 48.h,
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      onChanged: (value) {
                        field.didChange(value);
                        if (onChanged != null) {
                          onChanged!(value);
                        }
                      },
                      onTap: onTap,
                      enableInteractiveSelection: true,
                      cursorColor: cursorColor ?? Colors.black26,
                      cursorHeight: 18.h,
                      obscureText: isObsecure ?? false,
                      readOnly: isReadOnly ?? false,
                      maxLines: maxLines ?? 1,
                      maxLength: maxLength,
                      onSubmitted: onFieldSubmit,
                      textInputAction: textInputAction ?? TextInputAction.next,
                      keyboardType: isNumericKeyboard
                          ? const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            )
                          : keyboardType,
                      inputFormatters:
                          (isNumericKeyboard ||
                              keyboardType == TextInputType.phone ||
                              keyboardType == TextInputType.number)
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : null,
                      style: TextStyle(
                        color: cursorColor ?? Colors.black,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: hasPrefixIcon != null
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  hasPrefixIcon!,
                                  height: 20.h,
                                ),
                              )
                            : null,
                        suffixIcon: hasSuffixIcon,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        hintText: hintText,
                        hintStyle:
                            hintStyle ??
                            TextStyle(color: AppColor.gray, fontSize: 14.sp),
                        filled: true,
                        fillColor: fillColor ?? AppColor.appColorWhite,
                        // Hide the built-in error text, we render it manually below
                        errorText: null,
                        counterText: maxLength != null ? '' : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: borderColor ?? AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: borderColor ?? AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: borderColor ?? AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  if (hasError) ...[
                    SpaceHelper(h: 4.h),
                    Text(
                      field.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ],
                ],
              );
            },
          ),
          SpaceHelper(h: 8.h),
        ],
      ),
    );
  }
}
