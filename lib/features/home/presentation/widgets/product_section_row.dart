import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/home_models.dart';
import 'product_card.dart';

class ProductSectionRow extends StatelessWidget {
  final String title;
  final List<ProductItem> products;
  final void Function(ProductItem product, String heroTag) onProductTap;
  final bool isLargeCard;

  const ProductSectionRow({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    this.isLargeCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row with White Circular Chevron Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F29),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF1F1F29),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Empty state vs Horizontal List
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'No items available in this section',
                  style: AppTypography.bodySmall,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: isLargeCard ? 192 : 206,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final heroTag = '${title}_${product.id}';
                return ProductCard(
                  product: product,
                  heroTag: heroTag,
                  isLargeCard: isLargeCard,
                  cardIndex: index,
                  onTap: () => onProductTap(product, heroTag),
                );
              },
            ),
          ),
      ],
    );
  }
}
