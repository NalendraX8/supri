import 'package:equatable/equatable.dart';

/// Sales event definitions.
abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

/// Load products event.
class LoadProductsEvent extends SalesEvent {
  const LoadProductsEvent();
}

/// Search products event.
class SearchProductsEvent extends SalesEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Filter by category event.
class FilterCategoryEvent extends SalesEvent {
  final String? category;

  const FilterCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Add product to cart event.
class AddToCartEvent extends SalesEvent {
  final String productId;

  const AddToCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Remove product from cart event.
class RemoveFromCartEvent extends SalesEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Update cart item quantity event.
class UpdateCartQuantityEvent extends SalesEvent {
  final String productId;
  final int quantity;

  const UpdateCartQuantityEvent(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

/// Clear cart event.
class ClearCartEvent extends SalesEvent {
  const ClearCartEvent();
}

/// Apply discount event.
class ApplyDiscountEvent extends SalesEvent {
  final double? percent;
  final double? value;
  final bool isPercent;

  const ApplyDiscountEvent({this.percent, this.value, required this.isPercent});

  @override
  List<Object?> get props => [percent, value, isPercent];
}

/// Set customer event.
class SetCustomerEvent extends SalesEvent {
  final String? customerName;

  const SetCustomerEvent(this.customerName);

  @override
  List<Object?> get props => [customerName];
}

/// Set price type event.
class SetPriceTypeEvent extends SalesEvent {
  final String priceType;

  const SetPriceTypeEvent(this.priceType);

  @override
  List<Object?> get props => [priceType];
}

/// Hold transaction event.
class HoldTransactionEvent extends SalesEvent {
  const HoldTransactionEvent();
}
