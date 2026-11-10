import '../../../../core/errors/result.dart';
import '../../../home/domain/models/home_models.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final HomeRepository _homeRepository;

  ProductRepositoryImpl({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Result<ProductItem, Failure>> getProductById(String id) {
    return _homeRepository.getProductById(id);
  }
}
