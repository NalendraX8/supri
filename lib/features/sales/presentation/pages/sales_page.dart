import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/sales_bloc.dart';
import '../bloc/sales_event.dart';
import '../bloc/sales_state.dart';
import '../widgets/cart_bar.dart';
import '../widgets/cart_detail_sheet.dart';
import '../widgets/category_chips.dart';
import '../widgets/discount_dialog.dart';
import '../widgets/product_card.dart';

/// Main Sales/Home page - the primary POS screen.
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

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(const LoadProductsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<SalesBloc>().add(SearchProductsEvent(query));
  }

  void _onCategorySelected(String? category) {
    context.read<SalesBloc>().add(FilterCategoryEvent(category));
  }

  void _onProductTap(String productId) {
    context.read<SalesBloc>().add(AddToCartEvent(productId));
  }

  void _showCartDetail(CartEntity cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => CartDetailSheet(
          cart: cart,
          onUpdateQuantity: (id) {
            final item = cart.items.firstWhere((i) => i.product.id == id);
            context.read<SalesBloc>().add(UpdateQuantityEvent(id, item.quantity + 1));
          },
          onRemoveItem: (id) {
            context.read<SalesBloc>().add(RemoveFromCartEvent(id));
          },
          onClearCart: () {
            Navigator.pop(context);
            _showClearConfirmDialog();
          },
          onHold: () {
            Navigator.pop(context);
            _showHoldConfirmDialog();
          },
          onPayment: () {
            Navigator.pop(context);
            // TODO: Navigate to payment screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment screen coming soon')),
            );
          },
          onCustomerTap: () {
            Navigator.pop(context);
            _showCustomerDialog();
          },
          onDiscountTap: () {
            Navigator.pop(context);
            _showDiscountDialog();
          },
        ),
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Clear all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SalesBloc>().add(const ClearCartEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHoldConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text(
          'Displaying hold transaction data will delete the currently inputted item data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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

  void _showCustomerDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer'),
        content: AppTextField(
          controller: controller,
          hintText: 'Customer name',
          prefixIcon: Icons.person_outline,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
      builder: (context) => const DiscountDialog(),
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
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SalesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<SalesBloc>().add(const LoadProductsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SalesLoaded) {
            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppTextField(
                    controller: _searchController,
                    hintText: 'Search Item',
                    prefixIcon: Icons.search,
                    onChanged: _onSearch,
                  ),
                ),
                // Category chips
                CategoryChips(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),
                const SizedBox(height: 16),
                // Product grid
                Expanded(
                  child: state.filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: state.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = state.filteredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () => _onProductTap(product.id),
                            );
                          },
                        ),
                ),
                // Cart bar
                CartBar(
                  cart: state.cart,
                  onChargeTap: () => _showCartDetail(state.cart),
                  onCartTap: () => _showCartDetail(state.cart),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // User info header
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
                  'Usaha Mulia, Transaksi Bahagia',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
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
          // Log out
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
