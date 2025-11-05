import 'package:flutter/material.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.widgets/three_dot_loader.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final double? width;
  final double? height;
  final double? radius;
  final TextStyle? style;
  final Function()? onPressed;
  final bool? isLoading;
  final LinearGradient? gradient;
  final Widget? childWidget;
  final bool? isDisabled;
  final String? semanticLabel;
  final String? semanticHint;
  const CustomButton({
    super.key,
    this.title,
    required this.onPressed,
    this.isLoading,
    this.width,
    this.radius,
    this.style,
    this.gradient,
    this.isDisabled,
    this.childWidget,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  });
  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = isDisabled ?? false;
    final String buttonLabel = semanticLabel ?? title ?? 'Button';
    final String buttonHint = semanticHint ?? '';

    return Semantics(
      label: buttonLabel,
      hint: buttonHint.isNotEmpty ? buttonHint : null,
      button: true,
      enabled: !isButtonDisabled,
      onTap: isButtonDisabled ? null : onPressed,
      child: SizedBox(
        height: height ?? 56.0,
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(0.0),
            shadowColor: AppColor.primary,
            elevation: 0,
          ),
          onPressed: isButtonDisabled ? null : onPressed,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 12),
              gradient: isButtonDisabled
                  ? const LinearGradient(
                      colors: [Colors.grey, Colors.grey],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : gradient ??
                        const LinearGradient(
                          colors: [AppColor.primary, AppColor.primary],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
            ),
            child:
                childWidget ??
                (isLoading ?? false
                    ? Semantics(
                        label: 'Loading',
                        child: const Center(
                          child: ThreeDotLoader(color: Colors.white, size: 8.0),
                        ),
                      )
                    : Container(
                        constraints: const BoxConstraints(
                          maxWidth: double.infinity,
                          minHeight: 70.0,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style:
                              style ??
                              const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
