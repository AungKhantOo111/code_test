import '../../../../core/errors/result.dart';
import '../../../home/domain/models/home_models.dart';

abstract interface class ProductRepository {
  Future<Result<ProductItem, Failure>> getProductById(String id);
}
