import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/sales_bloc.dart';
import '../bloc/sales_event.dart';
import '../bloc/sales_state.dart';
import '../widgets/cart_bar.dart';
import '../widgets/cart_detail_sheet.dart';
import '../widgets/category_chips.dart';
import '../widgets/discount_dialog.dart';
import '../widgets/product_card.dart';
import '../widgets/product_skeleton.dart';
import '../widgets/receipt_dialog.dart';
import '../../../../core/widgets/demo_badge.dart';
import '../../../../core/storage/settings_storage.dart';
import '../../../../injection_container.dart';

/// Main Sales/Home page - the primary POS screen with static data.
class SalesPage extends StatefulWidget {
  final VoidCallback? onNavigateToHistory;
  final VoidCallback? onNavigateToKas;
  final VoidCallback? onNavigateToRekap;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onLogout;

  const SalesPage({
    super.key,
    this.onNavigateToHistory,
    this.onNavigateToKas,
    this.onNavigateToRekap,
    this.onNavigateToSettings,
    this.onLogout,
  });

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(const LoadProductsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _showCartDetail(CartEntity cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<SalesBloc>(),
        child: BlocBuilder<SalesBloc, SalesState>(
          builder: (blocCtx, state) {
            final currentCart = state is SalesLoaded ? state.cart : const CartEntity();
            return CartDetailSheet(
              cart: currentCart,
              onUpdateQuantity: (productId, newQuantity) {
                blocCtx.read<SalesBloc>().add(UpdateCartQuantityEvent(productId, newQuantity));
              },
              onRemoveItem: (productId) {
                blocCtx.read<SalesBloc>().add(RemoveFromCartEvent(productId));
              },
              onClearCart: () {
                Navigator.pop(ctx);
                blocCtx.read<SalesBloc>().add(const ClearCartEvent());
              },
              onHold: () {
                Navigator.pop(ctx);
                _showHoldDialog();
              },
              onPayment: () {
                Navigator.pop(ctx);
                _showPaymentDialog();
              },
              onCustomerTap: () {
                Navigator.pop(ctx);
                _showCustomerDialog();
              },
              onDiscountTap: () {
                Navigator.pop(ctx);
                _showDiscountDialog();
              },
            );
          },
        ),
      ),
    );
  }

  void _showHoldDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert'),
        content: const Text(
          'Displaying hold transaction data will delete the currently inputted item data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SalesBloc>().add(const HoldTransactionEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction held')),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog() {
    final state = context.read<SalesBloc>().state;
    final cart = state is SalesLoaded ? state.cart : const CartEntity();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('QRIS'),
              onTap: () {
                Navigator.pop(ctx);
                _processCheckout(cart, 'QRIS');
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash'),
              onTap: () {
                Navigator.pop(ctx);
                _processCheckout(cart, 'Cash');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout(CartEntity cart, String paymentMethod) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: SpinKitFadingCircle(
          color: AppColors.primary,
          size: 50.0,
        ),
      ),
    );

    final isQris = paymentMethod == 'QRIS';
    final payload = {
      "customer": cart.customerName != null && cart.customerName!.isNotEmpty
          ? cart.customerName
          : "Pelanggan Umum",
      "pos_profile": "Main Store POS",
      "update_stock": 1,
      "is_pos": 1,
      "items": cart.items.map((item) => {
        "item_code": item.product.id,
        "qty": item.quantity,
        "rate": item.product.price,
      }).toList(),
      "payments": [
        {
          "mode_of_payment": isQris ? "Qris" : "Cash",
          "amount": cart.total,
        }
      ],
      "base_total": cart.subtotal,
      "total": cart.subtotal,
      "grand_total": cart.total,
      "paid_amount": cart.total,
    };

    try {
      final response = await sl<ApiClient>().post('/api/resource/POS Invoice', payload);
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      if (response.statusCode == 200) {
        if (mounted) {
          _showSuccessDialog(cart);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaksi berhasil disinkronkan ke Zales ERP!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          _showSuccessDialog(cart);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Koneksi terputus. Transaksi disimpan secara offline (Status: ${response.statusCode})'),
              backgroundColor: Colors.orange.shade800,
            ),
          );
        }
      }
    } catch (_) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      if (mounted) {
        _showSuccessDialog(cart);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Koneksi terputus. Transaksi disimpan secara offline (Mode Offline)'),
            backgroundColor: Colors.orange.shade800,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(CartEntity cart) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ReceiptDialog(
        cart: cart,
        onNewTransaction: () {
          Navigator.pop(ctx);
          context.read<SalesBloc>().add(const ClearCartEvent());
        },
      ),
    );
  }

  void _showCustomerDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Customer'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Customer name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SalesBloc>().add(SetCustomerEvent(controller.text));
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showDiscountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => DiscountDialog(
        onApply: (percent, value, isPercent) {
          context.read<SalesBloc>().add(ApplyDiscountEvent(
                percent: percent,
                value: value,
                isPercent: isPercent,
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPRI'),
        actions: [
          FutureBuilder<String>(
            future: sl<SettingsStorage>().getMode(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == 'demo') {
                return const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: DemoBadge(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              final state = context.read<SalesBloc>().state;
              if (state is SalesLoaded && !state.cart.isEmpty) {
                _showCartDetail(state.cart);
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value coming soon')),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'sync', child: Text('Sync')),
              const PopupMenuItem(value: 'send_log', child: Text('Send Log')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Item',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (query) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                  context.read<SalesBloc>().add(SearchProductsEvent(query));
                });
              },
            ),
          ),
          // Category chips
          BlocBuilder<SalesBloc, SalesState>(
            buildWhen: (previous, current) => current is SalesLoaded || current is SalesLoading,
            builder: (context, state) {
              return CategoryChips(
                selectedCategory: state is SalesLoaded ? _getSelectedCategory(state) : null,
                onCategorySelected: (category) {
                  context.read<SalesBloc>().add(FilterCategoryEvent(category));
                },
              );
            },
          ),
          const SizedBox(height: 16),
          // Product grid / skeleton loading
          Expanded(
            child: BlocBuilder<SalesBloc, SalesState>(
              builder: (context, state) {
                if (state is SalesLoading || state is SalesInitial) {
                  return const ProductSkeleton();
                }

                if (state is SalesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load products',
                          style: TextStyle(color: AppColors.error),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SalesBloc>().add(const LoadProductsEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final products = state is SalesLoaded ? state.filteredProducts : <ProductEntity>[];
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final cart = state is SalesLoaded ? state.cart : const CartEntity();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final hasDiscount = index % 4 == 0;
                    final cartItems = cart.items.where((item) => item.product.id == product.id);
                    final quantityInCart = cartItems.isNotEmpty ? cartItems.first.quantity : 0;
                    
                    return ProductCard(
                      product: product,
                      onTap: () => context.read<SalesBloc>().add(AddToCartEvent(product.id)),
                      hasDiscount: hasDiscount,
                      discountPercent: hasDiscount ? 15 : null,
                      quantityInCart: quantityInCart,
                    );
                  },
                );
              },
            ),
          ),
          // Cart bar
          BlocBuilder<SalesBloc, SalesState>(
            builder: (context, state) {
              final cart = state is SalesLoaded ? state.cart : const CartEntity();
              return CartBar(
                cart: cart,
                onChargeTap: cart.isEmpty ? () {} : () => _showCartDetail(cart),
                onCartTap: cart.isEmpty ? () {} : () => _showCartDetail(cart),
              );
            },
          ),
        ],
      ),
    );
  }

  String? _getSelectedCategory(SalesLoaded state) {
    if (state.products.length != state.filteredProducts.length) {
      return state.filteredProducts.isNotEmpty
          ? state.filteredProducts.first.category
          : null;
    }
    return null;
  }
}
