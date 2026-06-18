import 'package:equatable/equatable.dart';

/// Product entity for POS items.
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String category;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, price, imageUrl, category, isAvailable];
}

/// Cart item entity.
class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}

/// Cart entity containing all cart items.
class CartEntity extends Equatable {
  final List<CartItemEntity> items;
  final String? customerName;
  final double? discountPercent;
  final double? discountValue;
  final bool isDiscountPercent;
  final String priceType; // 'Dine In' or 'Take Away'

  const CartEntity({
    this.items = const [],
    this.customerName,
    this.discountPercent,
    this.discountValue,
    this.isDiscountPercent = true,
    this.priceType = 'Dine In',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (isDiscountPercent) {
      return subtotal * (discountPercent ?? 0) / 100;
    }
    return discountValue ?? 0;
  }

  double get tax => (subtotal - discountAmount) * 0.10;

  double get total => subtotal - discountAmount + tax;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartEntity copyWith({
    List<CartItemEntity>? items,
    String? customerName,
    double? discountPercent,
    double? discountValue,
    bool? isDiscountPercent,
    String? priceType,
  }) {
    return CartEntity(
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      discountPercent: discountPercent ?? this.discountPercent,
      discountValue: discountValue ?? this.discountValue,
      isDiscountPercent: isDiscountPercent ?? this.isDiscountPercent,
      priceType: priceType ?? this.priceType,
    );
  }

  @override
  List<Object?> get props => [items, customerName, discountPercent, discountValue, isDiscountPercent, priceType];
}
