import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/product_entity.dart';

/// Remote data source for products querying Zales REST API.
class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource({required this.apiClient});

  /// Get all active products from Zales ERP.
  Future<List<ProductEntity>> getProducts() async {
    try {
      final response = await apiClient.get(
        '/api/resource/Item?fields=["item_code","item_name","standard_rate","description"]&filters=[["disabled","=",0],["is_sales_item","=",1]]',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> itemsList = data['data'] ?? [];
        return itemsList.map((item) {
          final String itemCode = item['item_code'] ?? '';
          final String itemName = item['item_name'] ?? '';
          final double standardRate = (item['standard_rate'] as num?)?.toDouble() ?? 0.0;

          // Categorize based on item name naming keywords
          String category = 'Makanan';
          final lowerName = itemName.toLowerCase();
          if (lowerName.contains('es') ||
              lowerName.contains('teh') ||
              lowerName.contains('kopi') ||
              lowerName.contains('jeruk') ||
              lowerName.contains('susu') ||
              lowerName.contains('cincau') ||
              lowerName.contains('hangat')) {
            category = 'Minuman';
          } else if (lowerName.contains('nasi')) {
            category = 'Nasi';
          } else if (lowerName.contains('beras') ||
              lowerName.contains('minyak') ||
              lowerName.contains('gula') ||
              lowerName.contains('mie instan')) {
            category = 'Bahan Baku';
          }

          return ProductEntity(
            id: itemCode,
            name: itemName,
            price: standardRate,
            category: category,
          );
        }).toList();
      }
      
      if (response.statusCode == 401) {
        throw const ServerException('Sesi masuk Anda telah kedaluwarsa. Silakan masuk kembali (Status: 401).');
      } else if (response.statusCode == 403) {
        throw const ServerException('Anda tidak memiliki izin untuk melihat produk (Status: 403).');
      } else {
        throw ServerException('Gagal mengambil produk dari server (Status: ${response.statusCode}).');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memuat produk. Periksa koneksi internet Anda (Detail: ${e.toString()}).');
    }
  }

  /// Get single product.
  Future<ProductEntity> getProduct(String id) async {
    final products = await getProducts();
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  /// Get products by category.
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final products = await getProducts();
    if (category.toLowerCase() == 'all') return products;
    return products.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Search products.
  Future<List<ProductEntity>> searchProducts(String query) async {
    final products = await getProducts();
    if (query.isEmpty) return products;
    return products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get product categories.
  List<String> getCategories() {
    return ['All', 'Makanan', 'Minuman', 'Nasi', 'Bahan Baku'];
  }
}
