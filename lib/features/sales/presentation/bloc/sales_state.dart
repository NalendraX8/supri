import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

/// Sales state definitions.
abstract class SalesState extends Equatable {
  const SalesState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class SalesInitial extends SalesState {
  const SalesInitial();
}

/// Loading products state.
class SalesLoading extends SalesState {
  const SalesLoading();
}

/// Products loaded state.
class SalesLoaded extends SalesState {
  final List<ProductEntity> products;
  final List<ProductEntity> filteredProducts;
  final CartEntity cart;
  final String? selectedCategory;
  final String searchQuery;

  const SalesLoaded({
    required this.products,
    required this.filteredProducts,
    required this.cart,
    this.selectedCategory,
    this.searchQuery = '',
  });

  SalesLoaded copyWith({
    List<ProductEntity>? products,
    List<ProductEntity>? filteredProducts,
    CartEntity? cart,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return SalesLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      cart: cart ?? this.cart,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [products, filteredProducts, cart, selectedCategory, searchQuery];
}

/// Error state.
class SalesError extends SalesState {
  final String message;

  const SalesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Transaction held state.
class SalesHeld extends SalesState {
  final CartEntity cart;

  const SalesHeld(this.cart);

  @override
  List<Object?> get props => [cart];
}
