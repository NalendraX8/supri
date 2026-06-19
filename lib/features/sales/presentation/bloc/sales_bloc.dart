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

  SalesBloc({required this.repository}) : super(SalesInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<ApplyDiscountEvent>(_onApplyDiscount);
    on<SetCustomerEvent>(_onSetCustomer);
    on<HoldTransactionEvent>(_onHoldTransaction);
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<SalesState> emit) async {
    emit(SalesLoading());
    try {
      _products = await repository.getProducts();
      emit(SalesLoaded(
        products: _products,
        filteredProducts: _products,
        cart: _cart,
      ));
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
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
      emit(currentState.copyWith(cart: _cart));
    }
  }

  void _onUpdateCartQuantity(UpdateCartQuantityEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
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
        emit(currentState.copyWith(cart: _cart));
      }
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

  void _onHoldTransaction(HoldTransactionEvent event, Emitter<SalesState> emit) {
    if (state is SalesLoaded) {
      final currentState = state as SalesLoaded;
      emit(SalesHeld(_cart));
      _cart = const CartEntity();
      emit(currentState.copyWith(cart: _cart));
    }
  }
}
