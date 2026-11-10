/// Data handed from a product tile to the detail route so the shared
/// [Hero] animation has a unique tag and an image to show while loading.
class ProductHeroArgs {
  final String tag;
  final String imageUrl;

  const ProductHeroArgs({required this.tag, required this.imageUrl});

  static String defaultTag(String productId) => 'product_image_$productId';
}
