import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width, height, borderRadius;
  final BoxFit? fit;
  final bool showShimmer;
  final Widget? errorWidget;
  const CustomNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.showShimmer = true,
    this.borderRadius,
    this.errorWidget,
  });

  Widget _buildShimmerPlaceholder() {
    if (!showShimmer) {
      return Container(
        width: width ?? 47,
        height: height ?? 47,
        color: Colors.grey.shade300,
      );
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width ?? 47,
        height: height ?? 47,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 47,
        height: height ?? 47,
        fit: fit ?? BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          width: width ?? 47,
          height: height ?? 47,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit ?? BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? 
            Container(
              width: width ?? 47,
              height: height ?? 47,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(borderRadius ?? 12),
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.grey.shade400,
                size: (width ?? 47) * 0.4,
              ),
            ),
      ),
    );
  }
}
