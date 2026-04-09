import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isObsecure,
    this.fillColor,
    this.hasPrefixIcon,
    this.onChanged,
    this.labelColor,
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

  final String? hintText;
  final TextEditingController? controller;
  final bool? isObsecure;
  final String? hasPrefixIcon;
  final Widget? hasSuffixIcon;
  final bool? isReadOnly;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool isNumericKeyboard;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmit;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final int? maxLines;
  final double? height;
  final Color? borderColor;
  final String? label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? semanticLabel;
  final String? semanticHint;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();

  void _syncControllerToFormField() {
    final c = widget.controller;
    if (c == null) return;
    _formFieldKey.currentState?.didChange(c.text);
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_syncControllerToFormField);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_syncControllerToFormField);
      widget.controller?.addListener(_syncControllerToFormField);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_syncControllerToFormField);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String fieldLabel =
        widget.semanticLabel ?? widget.label ?? widget.hintText ?? 'Text field';
    final String fieldHint = widget.semanticHint ?? '';

    return Semantics(
      label: fieldLabel,
      hint: fieldHint.isNotEmpty ? fieldHint : null,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Semantics(
              label: 'Label for $fieldLabel',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  widget.label!,
                  style: poppinFonts(
                    color: widget.labelColor ?? AppColor.black,
                    fontSize: md,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          FormField<String>(
            key: _formFieldKey,
            initialValue: widget.controller?.text ?? widget.initialValue,
            validator:
                widget.validator ??
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
                    height: widget.height ?? 48.h,
                    child: TextField(
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      onChanged: (value) {
                        field.didChange(value);
                        widget.onChanged?.call(value);
                      },
                      onTap: widget.onTap,
                      enableInteractiveSelection: true,
                      cursorColor: widget.cursorColor ?? Colors.black26,
                      cursorHeight: 18.h,
                      obscureText: widget.isObsecure ?? false,
                      readOnly: widget.isReadOnly ?? false,
                      maxLines: widget.maxLines ?? 1,
                      maxLength: widget.maxLength,
                      onSubmitted: widget.onFieldSubmit,
                      textInputAction:
                          widget.textInputAction ?? TextInputAction.next,
                      keyboardType: widget.isNumericKeyboard
                          ? const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            )
                          : widget.keyboardType,
                      inputFormatters:
                          (widget.isNumericKeyboard ||
                              widget.keyboardType == TextInputType.phone ||
                              widget.keyboardType == TextInputType.number)
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : null,
                      style: TextStyle(
                        color: widget.cursorColor ?? Colors.black,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: widget.hasPrefixIcon != null
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  widget.hasPrefixIcon!,
                                  height: 20.h,
                                ),
                              )
                            : null,
                        suffixIcon: widget.hasSuffixIcon,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        hintText: widget.hintText,
                        hintStyle:
                            widget.hintStyle ??
                            TextStyle(color: AppColor.gray, fontSize: 14.sp),
                        filled: true,
                        fillColor: widget.fillColor ?? AppColor.appColorWhite,
                        // Hide the built-in error text, we render it manually below
                        errorText: null,
                        counterText: widget.maxLength != null ? '' : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                widget.borderColor ?? AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                widget.borderColor ?? AppColor.textFieldBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                widget.borderColor ?? AppColor.textFieldBorderColor,
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
