sealed class ProductDetailEvent {
  const ProductDetailEvent();
}

class LoadProductDetailEvent extends ProductDetailEvent {
  final String id;
  const LoadProductDetailEvent(this.id);
}

class IncrementQuantityEvent extends ProductDetailEvent {
  const IncrementQuantityEvent();
}

class DecrementQuantityEvent extends ProductDetailEvent {
  const DecrementQuantityEvent();
}

class AddToCartEvent extends ProductDetailEvent {
  const AddToCartEvent();
}
