import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final trimmed = imageUrl.trim();

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      imageWidget = CachedNetworkImage(
        imageUrl: trimmed,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildShimmer(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    } else {
      // Resolve asset path: supports "assets/...", "images/...", or filename "1.png"
      String assetPath = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
      if (!assetPath.startsWith('assets/')) {
        if (assetPath.startsWith('images/')) {
          assetPath = 'assets/$assetPath';
        } else {
          assetPath = 'assets/images/$assetPath';
        }
      }

      imageWidget = Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(
          Icons.bakery_dining_rounded,
          color: AppColors.primaryDark,
          size: 28,
        ),
      ),
    );
  }
}
