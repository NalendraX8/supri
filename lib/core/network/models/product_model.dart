import 'dart:convert';

/// Product model for API responses.
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  factory ProductModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
  };
}

/// Category model.
class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}
