import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/models/home_models.dart';

class HomeHeader extends StatelessWidget {
  final MemberProfile member;
  final String? displayNameOverride;
  final VoidCallback? onLogout;

  const HomeHeader({
    super.key,
    required this.member,
    this.displayNameOverride,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        (displayNameOverride != null && displayNameOverride!.isNotEmpty)
            ? displayNameOverride!
            : member.name;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Decorative Bronze Star Shield graphic on the right (matching PDF Screen 8)
        Positioned(
          right: -8,
          top: 10,
          child: Transform.rotate(
            angle: math.pi / 18,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE7B98A).withValues(alpha: 0.45),
                    const Color(0xFFD19660).withValues(alpha: 0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                  width: 3,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.star_rounded,
                  size: 48,
                  color: const Color(0xFF9C7248).withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ),

        // Main Header Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Member Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AppCachedImage(
                    imageUrl: member.photoUrl,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(width: 12),

                // Member Name & Tier info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F29),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${member.tier} member',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D6B5D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Notification Bell Orange Pill with White Circle Counter
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 6, 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7941D),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF7941D).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${member.unreadNotifications > 0 ? member.unreadNotifications : 12}',
                          style: const TextStyle(
                            color: Color(0xFFF7941D),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // White Translucent Pill: "1290 points left to become Gold Member"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${member.points} points left to become ${member.nextTier} Member',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A5A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
