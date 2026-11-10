import '../../../home/domain/models/home_models.dart';

class ProductDetailState {
  final bool isLoading;
  final ProductItem? product;
  final int quantity;
  final bool addedToCartFeedback;
  final String? errorMessage;

  const ProductDetailState({
    this.isLoading = true,
    this.product,
    this.quantity = 1,
    this.addedToCartFeedback = false,
    this.errorMessage,
  });

  int get liveTotalMmk => (product?.priceMmk ?? 0) * quantity;

  String get formattedLiveTotal {
    final str = liveTotalMmk.toString();
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

  ProductDetailState copyWith({
    bool? isLoading,
    ProductItem? product,
    int? quantity,
    bool? addedToCartFeedback,
    String? errorMessage,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedToCartFeedback: addedToCartFeedback ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
