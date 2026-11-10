import 'package:flutter/material.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/models/home_models.dart';

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onTap;
  final String heroTag;
  final bool isLargeCard;
  final int cardIndex;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.heroTag,
    this.isLargeCard = false,
    this.cardIndex = 0,
  });

  static const List<String> _boxDonutAssets = [
    'assets/images/1.png',
    'assets/images/7.png',
    'assets/images/2.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/3.png',
  ];

  Widget _buildSeasonalBoxVisual() {
    final isGreenBox = cardIndex % 2 == 1;
    final boxBgColor =
        isGreenBox ? const Color(0xFFB5DFC3) : const Color(0xFFFDF3EA);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: boxBgColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isGreenBox)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 36,
                child: Container(
                  color: const Color(0xFF81C796),
                ),
              ),
            // 3x2 Assorted Donut Box Grid matching PDF "Seasonal specials" wide card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: Hero(
                              tag: heroTag,
                              child: AppCachedImage(
                                imageUrl: product.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: AppCachedImage(
                              imageUrl: _boxDonutAssets[1],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: AppCachedImage(
                              imageUrl: _boxDonutAssets[2],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: AppCachedImage(
                              imageUrl: _boxDonutAssets[3],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: AppCachedImage(
                              imageUrl: _boxDonutAssets[4],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Transform.scale(
                            scale: 1.28,
                            child: AppCachedImage(
                              imageUrl: _boxDonutAssets[5],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = isLargeCard ? 226.0 : 148.0;
    final imageHeight = isLargeCard ? 138.0 : 152.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Container with Badges
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (isLargeCard)
                    _buildSeasonalBoxVisual()
                  else
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Hero(
                        tag: heroTag,
                        child: AppCachedImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                  // Discount badge (e.g. "50% off", "20% off")
                  if (product.discountPercent != null)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7941D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${product.discountPercent}% off',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Name
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF1F1F29),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
