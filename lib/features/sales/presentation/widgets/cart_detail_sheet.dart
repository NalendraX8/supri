import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import 'product_card.dart';

/// Enhanced cart detail bottom sheet with swipe gestures and animations.
class CartDetailSheet extends StatefulWidget {
  final CartEntity cart;
  final Function(String productId, int newQuantity) onUpdateQuantity;
  final Function(String productId) onRemoveItem;
  final VoidCallback onClearCart;
  final VoidCallback onHold;
  final VoidCallback onPayment;
  final VoidCallback onCustomerTap;
  final VoidCallback onDiscountTap;

  const CartDetailSheet({
    super.key,
    required this.cart,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onClearCart,
    required this.onHold,
    required this.onPayment,
    required this.onCustomerTap,
    required this.onDiscountTap,
  });

  @override
  State<CartDetailSheet> createState() => _CartDetailSheetState();
}

class _CartDetailSheetState extends State<CartDetailSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(),
            _buildPriceTypeDropdown(),
            Expanded(child: _buildCartItems()),
            _buildSummary(),
            _buildActionButtons(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.person_outline,
              label: 'CUSTOMER',
              onTap: widget.onCustomerTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.discount_outlined,
              label: 'DISCOUNT',
              onTap: widget.onDiscountTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.receipt_long, size: 16, color: AppColors.grey600),
                const SizedBox(width: 8),
                const Text(
                  'Price List:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _PriceTypeChip(label: 'Dine In', isSelected: true),
          const SizedBox(width: 8),
          _PriceTypeChip(label: 'Take Away', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    if (widget.cart.items.isEmpty) {
      return _buildEmptyCart();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.cart.items.length,
      itemBuilder: (context, index) {
        final item = widget.cart.items[index];
        return Dismissible(
          key: Key(item.product.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            HapticFeedback.mediumImpact();
            widget.onRemoveItem(item.product.id);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.delete_outline, color: Colors.white),
              ],
            ),
          ),
          child: _CartItemCard(
            item: item,
            onIncrement: () {
              HapticFeedback.selectionClick();
              widget.onUpdateQuantity(item.product.id, item.quantity + 1);
            },
            onDecrement: () {
              HapticFeedback.selectionClick();
              if (item.quantity > 1) {
                widget.onUpdateQuantity(item.product.id, item.quantity - 1);
              } else {
                HapticFeedback.mediumImpact();
                widget.onRemoveItem(item.product.id);
              }
            },
            onRemove: () {
              HapticFeedback.heavyImpact();
              widget.onRemoveItem(item.product.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap produk untuk menambahkan ke keranjang',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Sub Total', value: widget.cart.subtotal),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Pajak (10%)', value: widget.cart.tax),
          if (widget.cart.discountAmount > 0) ...[
            const SizedBox(height: 6),
            _SummaryRow(
              label: 'Diskon',
              value: -widget.cart.discountAmount,
              isDiscount: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'TOTAL',
            value: widget.cart.total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Clear button
          _IconActionButton(
            icon: Icons.close,
            color: AppColors.error,
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.onClearCart();
            },
          ),
          const SizedBox(width: 8),
          // Hold button
          _IconActionButton(
            icon: Icons.pause,
            color: AppColors.warning,
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onHold();
            },
          ),
          const SizedBox(width: 8),
          // Payment button
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                widget.onPayment();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.success, Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'BAYAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button with icon and label.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Price type chip widget.
class _PriceTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PriceTypeChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.grey600,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Cart item card with enhanced quantity controls.
class _CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = getCategoryGradient(item.product.category);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product icon with category gradient
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              getCategoryIcon(item.product.category),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(item.product.price),
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls - large touch targets
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrement button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrement,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                        size: 18,
                        color: item.quantity > 1 ? AppColors.primary : AppColors.error,
                      ),
                    ),
                  ),
                ),
                // Quantity display
                Container(
                  constraints: const BoxConstraints(minWidth: 36),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Increment button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Total price for this item
          SizedBox(
            width: 90,
            child: Text(
              CurrencyFormatter.format(item.totalPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Summary row widget.
class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? AppColors.textPrimary : AppColors.grey700,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}${CurrencyFormatter.format(value.abs())}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            fontSize: isTotal ? 20 : 14,
            color: isDiscount
                ? AppColors.success
                : isTotal
                    ? AppColors.primary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Icon action button for cart actions.
class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}
