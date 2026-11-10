import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/core/errors/result.dart';
import 'package:code_test/features/home/domain/models/home_models.dart';
import 'package:code_test/features/product/domain/repositories/product_repository.dart';
import 'package:code_test/features/product/presentation/bloc/product_detail_bloc.dart';
import 'package:code_test/features/product/presentation/bloc/product_detail_event.dart';

class FakeProductRepository implements ProductRepository {
  static const testProduct = ProductItem(
    id: 'p_coconut',
    code: 'JD022123',
    name: 'Coconut Donut',
    priceMmk: 3200,
    isNew: true,
    imageUrl: 'assets/images/5.png',
    description: 'Delicious coconut donut',
    section: 'popular',
  );

  @override
  Future<Result<ProductItem, Failure>> getProductById(String id) async {
    return const Success(testProduct);
  }
}

void main() {
  late ProductDetailBloc bloc;
  late FakeProductRepository repository;

  setUp(() {
    repository = FakeProductRepository();
    bloc = ProductDetailBloc(productRepository: repository);
  });

  tearDown(() {
    bloc.close();
  });

  test('loads product details and starts with quantity 1', () async {
    bloc.add(const LoadProductDetailEvent('p_coconut'));
    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<dynamic>((state) => state.isLoading == true),
        predicate<dynamic>((state) =>
            state.isLoading == false &&
            state.product?.name == 'Coconut Donut' &&
            state.quantity == 1 &&
            state.liveTotalMmk == 3200),
      ]),
    );
  });

  test('increments quantity and updates live total (quantity * price)', () async {
    bloc.add(const LoadProductDetailEvent('p_coconut'));
    await bloc.stream.firstWhere((s) => !s.isLoading);

    bloc.add(const IncrementQuantityEvent());
    await expectLater(
      bloc.stream,
      emits(predicate<dynamic>(
        (state) => state.quantity == 2 && state.liveTotalMmk == 6400,
      )),
    );
  });

  test('decrement cannot go below minimum 1', () async {
    bloc.add(const LoadProductDetailEvent('p_coconut'));
    await bloc.stream.firstWhere((s) => !s.isLoading);

    bloc.add(const DecrementQuantityEvent());
    // Quantity should remain 1
    expect(bloc.state.quantity, equals(1));
    expect(bloc.state.liveTotalMmk, equals(3200));
  });

  test('add to cart triggers visual feedback flag', () async {
    bloc.add(const LoadProductDetailEvent('p_coconut'));
    await bloc.stream.firstWhere((s) => !s.isLoading);

    bloc.add(const AddToCartEvent());
    await expectLater(
      bloc.stream,
      emits(predicate<dynamic>((state) => state.addedToCartFeedback == true)),
    );
  });
}
