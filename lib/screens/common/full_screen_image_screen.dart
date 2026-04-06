import 'package:flutter/material.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';

/// Full-screen image viewer with swipe between multiple images.
class FullScreenImageScreen extends StatelessWidget {
  static const route = '/full-screen-image';

  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageScreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'No image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex.clamp(0, imageUrls.length - 1)),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final size = MediaQuery.of(context).size;
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CustomNetworkImageWidget(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.contain,
                    width: size.width,
                    height: size.height,
                    showShimmer: true,
                    errorWidget: const Center(
                      child: Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
