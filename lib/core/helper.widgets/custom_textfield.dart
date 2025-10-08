import 'package:flutter/material.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label!,
              style: TextStyle(
                color: labelColor ?? Color(0xff212529),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        SizedBox(
          height: height ?? 70,
          child: TextFormField(
            initialValue: initialValue,
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            enableInteractiveSelection: false,
            cursorColor: cursorColor ?? Colors.black26,
            cursorHeight: 12,
            obscureText: isObsecure ?? false,
            readOnly: isReadOnly ?? false,
            maxLines: maxLines ?? 1,
            onFieldSubmitted: onFieldSubmit,
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: isNumericKeyboard
                ? const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  )
                : keyboardType,
            style: TextStyle(color: cursorColor ?? Colors.black, fontSize: 12),
            validator:
                validator ??
                (value) {
                  if (value!.isEmpty) {
                    return "Field Required*";
                  }
                  return null;
                },
            decoration: InputDecoration(
              prefixIcon: hasPrefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(hasPrefixIcon!, height: 20),
                    )
                  : null,
              suffixIcon: hasSuffixIcon,
              // ? GestureDetector(
              //     onTap: hasSuffixOnTap,
              //     child: Padding(
              //       padding: const EdgeInsets.all(15),
              //       child: Image.asset(
              //         hasSuffixIcon!,
              //         height: 20,
              //       ),
              //     ),
              //   )
              // : null,
              hintText: hintText,
              hintStyle:
                  hintStyle ??
                  const TextStyle(color: Color(0xffADA4A5), fontSize: 16),
              filled: true,
              fillColor: fillColor ?? AppColor.appColorWhite,
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? AppColor.textFieldBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? AppColor.textFieldBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? AppColor.textFieldBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
