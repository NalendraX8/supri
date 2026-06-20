import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/product_entity.dart';

/// Full-screen Cart page.
class CartPage extends StatefulWidget {
  final CartEntity cart;
  final Function(String productId, int newQuantity) onUpdateQuantity;
  final Function(String productId) onRemoveItem;
  final VoidCallback onClearCart;
  final VoidCallback onHold;
  final VoidCallback onPayment;
  final VoidCallback onCustomerTap;
  final VoidCallback onDiscountTap;

  const CartPage({
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
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _priceType = 'Dine In';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearCartDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Action Buttons Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onCustomerTap,
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: const Text('CUSTOMER'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onDiscountTap,
                    icon: const Icon(Icons.discount_outlined, size: 18),
                    label: const Text('DISCOUNT'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Price Type Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Price List:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _priceType,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'Dine In', child: Text('Dine In')),
                      DropdownMenuItem(value: 'Take Away', child: Text('Take Away')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _priceType = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          // Cart Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                final item = widget.cart.items[index];
                return _CartItemRow(
                  item: item,
                  onIncrement: () {
                    widget.onUpdateQuantity(item.product.id, item.quantity + 1);
                  },
                  onDecrement: () {
                    if (item.quantity > 1) {
                      widget.onUpdateQuantity(item.product.id, item.quantity - 1);
                    } else {
                      widget.onRemoveItem(item.product.id);
                    }
                  },
                );
              },
            ),
          ),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Sub Total', value: widget.cart.subtotal),
                const SizedBox(height: 4),
                _SummaryRow(label: 'Tax (10%)', value: widget.cart.tax),
                if (widget.cart.discountAmount > 0)
                  _SummaryRow(label: 'Discount', value: -widget.cart.discountAmount, isDiscount: true),
                const Divider(),
                _SummaryRow(label: 'TOTAL', value: widget.cart.total, isTotal: true),
              ],
            ),
          ),
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Clear Button
                IconButton(
                  onPressed: () => _showClearCartDialog(context),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 8),
                // Hold Button
                IconButton(
                  onPressed: widget.onHold,
                  icon: const Icon(Icons.pause),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 16),
                // Payment Button
                Expanded(
                  child: AppButton(
                    text: 'PAYMENT',
                    variant: AppButtonVariant.success,
                    onPressed: widget.cart.isEmpty ? null : widget.onPayment,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to clear all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onClearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Quantity controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onDecrement,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.remove, size: 18),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.add, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatPrice(item.product.price),
                  style: const TextStyle(color: AppColors.grey600, fontSize: 13),
                ),
              ],
            ),
          ),
          // Total price
          Text(
            _formatPrice(item.totalPrice),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return 'IDR ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}

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
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}${_formatPrice(value.abs())}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
            color: isDiscount ? AppColors.success : (isTotal ? AppColors.primary : null),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return 'IDR ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
