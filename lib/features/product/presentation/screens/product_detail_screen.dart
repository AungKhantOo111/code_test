import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';
import 'product_hero_args.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final ProductHeroArgs? heroArgs;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.heroArgs,
  });

  /// While loading, the destination Hero already exists so the image can fly
  /// in from the tapped tile instead of popping in after the data arrives.
  Widget _buildLoading() {
    final args = heroArgs;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: BackButton(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 120),
            if (args != null)
              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Hero(
                    tag: args.tag,
                    child: AppCachedImage(
                      imageUrl: args.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailBloc, ProductDetailState>(
      listenWhen: (prev, curr) =>
          curr.addedToCartFeedback && !prev.addedToCartFeedback,
      listener: (context, state) {
        final product = state.product;
        if (product != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added ${state.quantity}x ${product.name} (${state.formattedLiveTotal}) to cart!',
              ),
              backgroundColor: AppColors.primaryDark,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoading();
        }

        final product = state.product;
        if (product == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F4F6),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Center(
              child: Text(
                state.errorMessage ?? 'Product not found',
                style: AppTypography.error,
              ),
            ),
          );
        }

        final bloc = context.read<ProductDetailBloc>();

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          body: SafeArea(
            child: Column(
              children: [
                // Top Back Arrow Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1F1F29),
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),

                // Main Details Scrollable View matching PDF Screen 9
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // White Product Card with overlapping bottom Quantity Stepper
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Code & Orange "New" Badge
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.code,
                                        style: const TextStyle(
                                          color: Color(0xFFB0B4C0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      if (product.isNew)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF7941D),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'New',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),

                                  // Product Name
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F1F29),
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Price in MMK
                                  Text(
                                    product.formattedPrice,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF4A4E5A),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Large Product Image with Hero Transition
                                  Center(
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Hero(
                                        tag: heroArgs?.tag ??
                                            ProductHeroArgs.defaultTag(
                                                product.id),
                                        child: AppCachedImage(
                                          imageUrl: product.imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),

                            // Quantity Stepper Pill overlapping bottom edge of White Card
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFFECEEF2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Minus button (sky-blue circle with white minus)
                                    InkWell(
                                      onTap: state.quantity > 1
                                          ? () => bloc.add(
                                              const DecrementQuantityEvent())
                                          : null,
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: state.quantity > 1
                                              ? const Color(0xFF67CBE8)
                                              : const Color(0xFF9ADDF0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Animated Quantity Number
                                    SizedBox(
                                      width: 24,
                                      child: AnimatedSwitcher(
                                        duration: AppDurations.getDuration(
                                          context,
                                          AppDurations.quick,
                                        ),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: Text(
                                          '${state.quantity}',
                                          key: ValueKey<int>(state.quantity),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1F1F29),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Plus button (sky-blue circle with white plus)
                                    InkWell(
                                      onTap: () => bloc
                                          .add(const IncrementQuantityEvent()),
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF67CBE8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // "What's this?" Two-Column Section matching PDF Screen 9
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column: Green '?' icon + "What's\nthis?" label
                            SizedBox(
                              width: 72,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8CD77E),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "What's\nthis?",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F1F29),
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right Column: Description Text
                            Expanded(
                              child: Text(
                                product.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8C909E),
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),

                // Bottom Pill Add To Cart Button matching PDF Screen 9
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    8,
                    AppSpacing.lg,
                    20,
                  ),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusPill),
                    onTap: () => bloc.add(const AddToCartEvent()),
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF62CBE9),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusPill),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF62CBE9).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ADD TO CART',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 16),
                          AnimatedSwitcher(
                            duration: AppDurations.getDuration(
                              context,
                              AppDurations.quick,
                            ),
                            child: Text(
                              state.formattedLiveTotal,
                              key: ValueKey<int>(state.liveTotalMmk),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
