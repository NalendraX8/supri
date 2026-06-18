import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import 'sales_event.dart';
import 'sales_state.dart';

/// Sales BLoC for managing POS/sales state.
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  List<ProductEntity> _products = [];
  CartEntity _cart = const CartEntity();

  SalesBloc() : super(const SalesInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterCategoryEvent>(_onFilterCategory);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<SetCustomerEvent>(_onSetCustomer);
    on<SetPriceTypeEvent>(_onSetPriceType);
    on<HoldTransactionEvent>(_onHoldTransaction);
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<SalesState> emit) async {
    emit(const SalesLoading());

    // Mock products data
    _products = [
      const ProductEntity(id: '1', name: 'Ayam Geprek', price: 15000, category: 'Food'),
      const ProductEntity(id: '2', name: 'Bakso Goreng', price: 12000, category: 'Food'),
      const ProductEntity(id: '3', name: 'Es Jeruk', price: 6000, category: 'Drinks'),
      const ProductEntity(id: '4', name: 'Es Podjok', price: 5000, category: 'Drinks'),
      const ProductEntity(id: '5', name: 'Es Teh Manis', price: 4000, category: 'Drinks'),
      const ProductEntity(id: '6', name: 'Es Teh', price: 3000, category: 'Drinks'),
      const ProductEntity(id: '7', name: 'Nasi Putih', price: 5000, category: 'Rice'),
      const ProductEntity(id: '8', name: 'Nasi Goreng', price: 15000, category: 'Rice'),
      const ProductEntity(id: '9', name: 'Beras 5kg', price: 75000, category: 'Bahan Baku'),
      const ProductEntity(id: '10', name: 'Adonan Martabak', price: 10000, category: 'Bahan Baku'),
      const ProductEntity(id: '11', name: 'Es Degan', price: 8000, category: 'Drinks'),
      const ProductEntity(id: '12', name: 'Es Podjok', price: 5000, category: 'Drinks'),
    ];

    _cart = const CartEntity();

    emit(SalesLoaded(
      products: _products,
      filteredProducts: _products,
      cart: _cart,
    ));
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      final query = event.query.toLowerCase();

      final filtered = _products.where((p) {
        final matchesSearch = p.name.toLowerCase().contains(query);
        final matchesCategory = currentState.selectedCategory == null ||
            p.category == currentState.selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

      emit(currentState.copyWith(
        filteredProducts: filtered,
        searchQuery: event.query,
      ));
    }
  }

  void _onFilterCategory(FilterCategoryEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      final query = currentState.searchQuery.toLowerCase();

      final filtered = _products.where((p) {
        final matchesSearch = query.isEmpty || p.name.toLowerCase().contains(query);
        final matchesCategory = event.category == null || p.category == event.category;
        return matchesSearch && matchesCategory;
      }).toList();

      emit(currentState.copyWith(
        filteredProducts: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      final product = _products.firstWhere((p) => p.id == event.productId);

      final existingIndex = _cart.items.indexWhere((i) => i.product.id == event.productId);

      List<CartItemEntity> newItems;
      if (existingIndex >= 0) {
        newItems = List.from(_cart.items);
        final existing = newItems[existingIndex];
        newItems[existingIndex] = existing.copyWith(quantity: existing.quantity + 1);
      } else {
        newItems = [..._cart.items, CartItemEntity(product: product, quantity: 1)];
      }

      _cart = _cart.copyWith(items: newItems);
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      final newItems = _cart.items.where((i) => i.product.id != event.productId).toList();
      _cart = _cart.copyWith(items: newItems);
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;

      if (event.quantity <= 0) {
        add(RemoveFromCartEvent(event.productId));
        return;
      }

      final newItems = _cart.items.map((item) {
        if (item.product.id == event.productId) {
          return item.copyWith(quantity: event.quantity);
        }
        return item;
      }).toList();

      _cart = _cart.copyWith(items: newItems);
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      _cart = const CartEntity();
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onApplyDiscount(ApplyDiscountEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      _cart = _cart.copyWith(
        discountPercent: event.isPercent ? event.percent : null,
        discountValue: !event.isPercent ? event.value : null,
        isDiscountPercent: event.isPercent,
      );
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onSetCustomer(SetCustomerEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      _cart = _cart.copyWith(customerName: event.customerName);
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onSetPriceType(SetPriceTypeEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      _cart = _cart.copyWith(priceType: event.priceType);
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onHoldTransaction(HoldTransactionEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      emit(SalesHeld(_cart));
      // Reset to loaded state with empty cart
      _cart = const CartEntity();
      emit(currentState.copyWith(cart: _cart));
    }
  }
}
