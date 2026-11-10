import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/models/home_models.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerItem> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.banners.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 188,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: widget.banners.length,
        itemBuilder: (context, index) {
          final banner = widget.banners[index];
          final isPrimaryPurple = index % 2 == 0;
          final cardBgColor = isPrimaryPurple
              ? const Color(0xFF5D56BC)
              : const Color(0xFF47C3E8);
          final waveColor = isPrimaryPurple
              ? const Color(0xFF6E67CA)
              : const Color(0xFF66D1F0);

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? AppSpacing.lg : 12,
              right: index == widget.banners.length - 1 ? AppSpacing.lg : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                color: cardBgColor,
                child: Stack(
                  children: [
                    // Decorative background wave arch matching PDF Screen 8
                    Positioned(
                      right: -30,
                      bottom: -20,
                      child: Container(
                        width: 190,
                        height: 150,
                        decoration: BoxDecoration(
                          color: waveColor,
                          borderRadius: BorderRadius.circular(95),
                        ),
                      ),
                    ),

                    // Content + Framed Bottom Shop Image
                    Column(
                      children: [
                        const SizedBox(height: 14),
                        if (banner.subtitle.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7941D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              banner.subtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            banner.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(14),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: AppCachedImage(
                                  imageUrl: banner.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
