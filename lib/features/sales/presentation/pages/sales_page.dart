import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Load products from API
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
                _showSuccessDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash'),
              onTap: () {
                Navigator.pop(ctx);
                _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: const Text('Payment completed successfully!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SalesBloc>().add(const ClearCartEvent());
            },
            child: const Text('DONE'),
          ),
        ],
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
              context
                  .read<SalesBloc>()
                  .add(SetCustomerEvent(controller.text));
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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('SUPRI'),
        actions: [
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
      drawer: _buildDrawer(),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          // Handle loading state
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
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

          // Handle initial state
          if (state is SalesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle SalesLoaded and SalesHeld states
          final products = state is SalesLoaded ? state.filteredProducts : <ProductEntity>[];
          final cart = state is SalesLoaded ? state.cart : const CartEntity();

          return Column(
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
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
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
              CategoryChips(
                selectedCategory: state is SalesLoaded ? _getSelectedCategory(state) : null,
                onCategorySelected: (category) {
                  context.read<SalesBloc>().add(FilterCategoryEvent(category));
                },
              ),
              const SizedBox(height: 16),
              // Product grid
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
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
                          return ProductCard(
                            product: product,
                            onTap: () => context.read<SalesBloc>().add(AddToCartEvent(product.id)),
                          );
                        },
                      ),
              ),
              // Cart bar
              CartBar(
                cart: cart,
                onChargeTap: cart.isEmpty ? () {} : () => _showCartDetail(cart),
                onCartTap: cart.isEmpty ? () {} : () => _showCartDetail(cart),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _getSelectedCategory(SalesLoaded state) {
    // Find which category is selected by checking filteredProducts
    // If filtered products are fewer than all products, a category is selected
    if (state.products.length != state.filteredProducts.length) {
      return state.filteredProducts.isNotEmpty
          ? state.filteredProducts.first.category
          : null;
    }
    return null;
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Supri',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'demo@supri.id',
                  style: TextStyle(color: AppColors.textOnPrimary, fontSize: 12),
                ),
                const Text(
                  'Toko Utama',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.shopping_cart,
                  label: 'Sales',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Kas',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToKas?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart,
                  label: 'Rekap',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToRekap?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToHistory?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  label: 'Setting',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToSettings?.call();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Log Out',
            textColor: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              widget.onLogout?.call();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color? textColor;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : (textColor ?? AppColors.grey700),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? (isSelected ? AppColors.primary : AppColors.textPrimary),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: onTap,
    );
  }
}
