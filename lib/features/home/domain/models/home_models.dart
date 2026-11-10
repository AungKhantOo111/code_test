class ProductItem {
  final String id;
  final String code;
  final String name;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;
  final String imageUrl;
  final String description;
  final String section;

  const ProductItem({
    required this.id,
    required this.code,
    required this.name,
    required this.priceMmk,
    this.isNew = false,
    this.discountPercent,
    required this.imageUrl,
    required this.description,
    required this.section,
  });

  String get formattedPrice {
    final str = priceMmk.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write(',');
      }
    }
    return '${buffer.toString().split('').reversed.join()} MMK';
  }
}

class BannerItem {
  final String id;
  final String title;
  final String subtitle;
  final String actionUrl;
  final String imageUrl;

  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.actionUrl,
    required this.imageUrl,
  });
}

class ShopItem {
  final String id;
  final String name;
  final String address;
  final String imageUrl;

  const ShopItem({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
  });
}

class MemberProfile {
  final String id;
  final String name;
  final String photoUrl;
  final String tier;
  final int points;
  final String nextTier;
  final int pointsToNextTier;
  final int totalPoints;
  final int unreadNotifications;

  const MemberProfile({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.tier,
    required this.points,
    required this.nextTier,
    required this.pointsToNextTier,
    required this.totalPoints,
    required this.unreadNotifications,
  });
}

class HomeData {
  final MemberProfile member;
  final List<BannerItem> banners;
  final List<ProductItem> seasonalSpecials;
  final List<ProductItem> popular;
  final List<ProductItem> orderAgain;
  final List<ShopItem> shops;

  const HomeData({
    required this.member,
    required this.banners,
    required this.seasonalSpecials,
    required this.popular,
    required this.orderAgain,
    required this.shops,
  });
}
