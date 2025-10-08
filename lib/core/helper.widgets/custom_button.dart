import 'package:flutter/material.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';

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
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        onPressed: isDisabled ?? false ? null : onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 12),
            gradient: isDisabled ?? false
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
                  ? const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
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
    );
  }
}
