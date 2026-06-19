import '../../../../core/network/api_remote_datasource.dart';
import '../../domain/entities/product_entity.dart';

/// Remote data source for products.
class ProductRemoteDataSource {
  final ApiRemoteDataSource api;

  ProductRemoteDataSource({required this.api});

  Future<List<ProductEntity>> getProducts() async {
    final models = await api.getProducts();
    return models.map((m) => ProductEntity(
      id: m.id,
      name: m.name,
      price: m.price,
      category: m.category,
    )).toList();
  }

  Future<ProductEntity?> getProduct(String id) async {
    try {
      final model = await api.getProduct(id);
      return ProductEntity(
        id: model.id,
        name: model.name,
        price: model.price,
        category: model.category,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final products = await getProducts();
    return products.where((p) => p.category == category).toList();
  }

  Future<List<ProductEntity>> searchProducts(String query) async {
    final products = await getProducts();
    return products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
