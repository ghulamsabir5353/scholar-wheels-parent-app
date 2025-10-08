import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width, height, borderRadius;
  final BoxFit? fit;
  final bool showShimmer;
  const CustomNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.showShimmer = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 47,
        height: height ?? 47,
        imageBuilder: (context, imageProvider) => Container(
          width: width ?? 47,
          height: height ?? 47,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
        placeholder: (context, url) => SpaceHelper(),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
