import '../../features/sales/domain/entities/product_entity.dart';

/// Mock data source for products.
/// In production, replace with real API calls.
class MockProductDataSource {
  /// Get all products (menu items).
  Future<List<ProductEntity>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _menuProducts;
  }

  /// Get all categories.
  List<String> getCategories() {
    return ['All', 'Makanan', 'Minuman', 'Nasi', 'Bahan Baku'];
  }
}

/// Mock menu products for Supri POS.
const List<ProductEntity> _menuProducts = [
  // Makanan
  ProductEntity(id: '1', name: 'Ayam Geprek', price: 15000, category: 'Makanan'),
  ProductEntity(id: '2', name: 'Bakso Goreng', price: 12000, category: 'Makanan'),
  ProductEntity(id: '3', name: 'Mie Goreng', price: 13000, category: 'Makanan'),
  ProductEntity(id: '4', name: 'Mie Rebus', price: 13000, category: 'Makanan'),
  ProductEntity(id: '5', name: 'Soto Ayam', price: 14000, category: 'Makanan'),
  ProductEntity(id: '6', name: 'Gado-Gado', price: 15000, category: 'Makanan'),
  ProductEntity(id: '7', name: 'Nasi Campur', price: 18000, category: 'Makanan'),
  ProductEntity(id: '8', name: 'Sate Ayam', price: 20000, category: 'Makanan'),
  ProductEntity(id: '9', name: 'Pempek', price: 15000, category: 'Makanan'),
  ProductEntity(id: '10', name: 'Tahu Tempe Goreng', price: 8000, category: 'Makanan'),

  // Minuman
  ProductEntity(id: '11', name: 'Es Teh Manis', price: 4000, category: 'Minuman'),
  ProductEntity(id: '12', name: 'Es Jeruk', price: 6000, category: 'Minuman'),
  ProductEntity(id: '13', name: 'Es Teh', price: 3000, category: 'Minuman'),
  ProductEntity(id: '14', name: 'Es Podjok', price: 5000, category: 'Minuman'),
  ProductEntity(id: '15', name: 'Es Degan', price: 8000, category: 'Minuman'),
  ProductEntity(id: '16', name: 'Es Susu', price: 7000, category: 'Minuman'),
  ProductEntity(id: '17', name: 'Es Cincau', price: 5000, category: 'Minuman'),
  ProductEntity(id: '18', name: 'Teh Hangat', price: 3000, category: 'Minuman'),
  ProductEntity(id: '19', name: 'Jeruk Hangat', price: 5000, category: 'Minuman'),
  ProductEntity(id: '20', name: 'Kopi Hitam', price: 5000, category: 'Minuman'),

  // Nasi
  ProductEntity(id: '21', name: 'Nasi Putih', price: 5000, category: 'Nasi'),
  ProductEntity(id: '22', name: 'Nasi Goreng', price: 15000, category: 'Nasi'),
  ProductEntity(id: '23', name: 'Nasi Uduk', price: 14000, category: 'Nasi'),
  ProductEntity(id: '24', name: 'Nasi Rendang', price: 18000, category: 'Nasi'),
  ProductEntity(id: '25', name: 'Nasi Kuning', price: 12000, category: 'Nasi'),

  // Bahan Baku
  ProductEntity(id: '26', name: 'Beras 5kg', price: 75000, category: 'Bahan Baku'),
  ProductEntity(id: '27', name: 'Beras 10kg', price: 145000, category: 'Bahan Baku'),
  ProductEntity(id: '28', name: 'Minyak Goreng 1L', price: 18000, category: 'Bahan Baku'),
  ProductEntity(id: '29', name: 'Gula 1kg', price: 15000, category: 'Bahan Baku'),
  ProductEntity(id: '30', name: 'Mie Instan', price: 3500, category: 'Bahan Baku'),
];
