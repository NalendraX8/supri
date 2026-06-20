import '../../../../core/network/mock_product_datasource.dart';
import '../../domain/entities/product_entity.dart';

/// Remote data source for products.
class ProductRemoteDataSource {
  final MockProductDataSource mockDataSource;

  ProductRemoteDataSource({required this.mockDataSource});

  Future<List<ProductEntity>> getProducts() async {
    return await mockDataSource.getProducts();
  }

  Future<ProductEntity> getProduct(String id) async {
    final products = await mockDataSource.getProducts();
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final products = await mockDataSource.getProducts();
    return products.where((p) => p.category == category).toList();
  }

  Future<List<ProductEntity>> searchProducts(String query) async {
    final products = await mockDataSource.getProducts();
    return products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<String> getCategories() {
    return mockDataSource.getCategories();
  }
}
