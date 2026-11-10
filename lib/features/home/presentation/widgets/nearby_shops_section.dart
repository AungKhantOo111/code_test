import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/models/home_models.dart';

class NearbyShopsSection extends StatelessWidget {
  final List<ShopItem> shops;

  const NearbyShopsSection({super.key, required this.shops});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF56C8EB),
              Color(0xFF6AD0EE),
              Color(0xFF83CE79),
            ],
            stops: [0.0, 0.72, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Soft Cream/Peach Clouds on top-right (matching PDF Screen 8/9)
            Positioned(
              right: -25,
              top: 22,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEBD8).withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 45,
              top: 55,
              child: Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF1E4).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 105,
              top: 85,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Green grass/foliage hills at the bottom
            Positioned(
              left: -30,
              right: -30,
              bottom: -25,
              child: Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF7CC66E),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(240, 60),
                  ),
                ),
              ),
            ),

            // Section Content
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "There are ${shops.length} J'Donut shops\nnear you. 😋",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4AC0E4),
                            elevation: 0,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'EXPLORE NOW',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Shop Cards Horizontal Scroll inside the scenic container
                  SizedBox(
                    height: 232,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return Container(
                          width: 215,
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Shop Photo with all-around rounded corners
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: AppCachedImage(
                                  imageUrl: shop.imageUrl,
                                  height: 112,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1F1F29),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      shop.address,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A7E8A),
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'Order Online',
                                        style: TextStyle(
                                          color: Color(0xFFE95383),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
}
