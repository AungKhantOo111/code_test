import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductDetailState()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _productRepository.getProductById(event.id);
    result.fold(
      onSuccess: (product) {
        emit(state.copyWith(
          isLoading: false,
          product: product,
          quantity: 1,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
    );
  }

  void _onIncrementQuantity(
    IncrementQuantityEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(addedToCartFeedback: true));
  }
}
