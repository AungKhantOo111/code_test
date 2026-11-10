import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.borderRadiusSm,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class HomeSkeletonLoading extends StatelessWidget {
  const HomeSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Skeleton
          Row(
            children: [
              SkeletonBox(width: 48, height: 48, borderRadius: 24),
              SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 100, height: 16),
                  SizedBox(height: 6),
                  SkeletonBox(width: 140, height: 12),
                ],
              ),
              Spacer(),
              SkeletonBox(width: 36, height: 36, borderRadius: 18),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          // Banner Skeleton
          SkeletonBox(width: double.infinity, height: 160, borderRadius: 16),
          SizedBox(height: AppSpacing.xl),

          // Section 1 Skeleton
          SkeletonBox(width: 160, height: 20),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SkeletonBox(width: 140, height: 150, borderRadius: 12),
              SizedBox(width: AppSpacing.md),
              SkeletonBox(width: 140, height: 150, borderRadius: 12),
            ],
          ),
          SizedBox(height: AppSpacing.xl),

          // Section 2 Skeleton
          SkeletonBox(width: 120, height: 20),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              SkeletonBox(width: 140, height: 150, borderRadius: 12),
              SizedBox(width: AppSpacing.md),
              SkeletonBox(width: 140, height: 150, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }
}
