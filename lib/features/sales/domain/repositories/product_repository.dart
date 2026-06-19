import '../entities/product_entity.dart';

/// Repository interface for product operations.
abstract class ProductRepository {
  /// Get all products.
  Future<List<ProductEntity>> getProducts();

  /// Get product by ID.
  Future<ProductEntity?> getProduct(String id);

  /// Get products by category.
  Future<List<ProductEntity>> getProductsByCategory(String category);

  /// Search products.
  Future<List<ProductEntity>> searchProducts(String query);
}
