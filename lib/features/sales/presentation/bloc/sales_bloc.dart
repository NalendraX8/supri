import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import 'sales_event.dart';
import 'sales_state.dart';

/// Sales BLoC for managing POS/sales state.
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final ProductRepository repository;
  CartEntity _cart = const CartEntity();
  List<ProductEntity> _products = [];
  String _searchQuery = '';
  String? _selectedCategory;

  SalesBloc({required this.repository}) : super(SalesInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterCategoryEvent>(_onFilterCategory);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<SetCustomerEvent>(_onSetCustomer);
    on<HoldTransactionEvent>(_onHoldTransaction);
  }

  List<ProductEntity> _getFilteredProducts() {
    final query = _searchQuery.toLowerCase();
    return _products.where((p) {
      if (_selectedCategory != null && p.category != _selectedCategory) return false;
      return query.isEmpty || p.name.toLowerCase().contains(query);
    }).toList();
  }

  void _emitLoaded(Emitter<SalesState> emit) {
    emit(SalesLoaded(
      products: _products,
      filteredProducts: _getFilteredProducts(),
      cart: _cart,
    ));
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<SalesState> emit) async {
    emit(SalesLoading());
    try {
      _products = await repository.getProducts();
      _emitLoaded(emit);
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      _searchQuery = event.query;
      _emitLoaded(emit);
    }
  }

  void _onFilterCategory(FilterCategoryEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      _selectedCategory = event.category;
      _emitLoaded(emit);
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final existingIndex = _cart.items.indexWhere((i) => i.product.id == event.productId);

      List<CartItemEntity> newItems;
      if (existingIndex >= 0) {
        // Merge: increment quantity of existing item
        newItems = [..._cart.items];
        final existingItem = newItems[existingIndex];
        newItems[existingIndex] = CartItemEntity(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        );
      } else {
        // Find product and add new item
        final product = _products.firstWhere(
          (p) => p.id == event.productId,
          orElse: () => ProductEntity(
            id: event.productId,
            name: 'Unknown',
            price: 0,
            category: 'Other',
          ),
        );
        newItems = [
          ..._cart.items,
          CartItemEntity(product: product, quantity: 1),
        ];
      }

      _cart = _cart.copyWith(items: newItems);
      _emitLoaded(emit);
    }
  }

  void _onUpdateCartQuantity(UpdateCartQuantityEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final existingIndex = _cart.items.indexWhere((i) => i.product.id == event.productId);

      if (existingIndex >= 0) {
        final newItems = [..._cart.items];
        final existingItem = newItems[existingIndex];
        if (event.quantity <= 0) {
          newItems.removeAt(existingIndex);
        } else {
          newItems[existingIndex] = CartItemEntity(
            product: existingItem.product,
            quantity: event.quantity,
          );
        }
        _cart = _cart.copyWith(items: newItems);
        _emitLoaded(emit);
      }
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final newItems = _cart.items.where((i) => i.product.id != event.productId).toList();
      _cart = _cart.copyWith(items: newItems);
      _emitLoaded(emit);
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      _cart = const CartEntity();
      _emitLoaded(emit);
    }
  }

  void _onApplyDiscount(ApplyDiscountEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      _cart = _cart.copyWith(
        discountPercent: event.isPercent ? event.percent : null,
        discountValue: !event.isPercent ? event.value : null,
        isDiscountPercent: event.isPercent,
      );
      _emitLoaded(emit);
    }
  }

  void _onSetCustomer(SetCustomerEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      _cart = _cart.copyWith(customerName: event.customerName);
      _emitLoaded(emit);
    }
  }

  void _onHoldTransaction(HoldTransactionEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      // Emit SalesHeld state to notify UI that transaction was held
      emit(SalesHeld(_cart));
      // Clear cart for new transaction
      _cart = const CartEntity();
      // Re-emit loaded state with empty cart
      _emitLoaded(emit);
    }
  }
}
