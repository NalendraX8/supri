import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

/// Implementation of product repository.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<ProductEntity> getProduct(String id) async {
    return await remoteDataSource.getProduct(id);
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    return await remoteDataSource.getProductsByCategory(category);
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    return await remoteDataSource.searchProducts(query);
  }
}
