import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';

/// Cart detail bottom sheet.
class CartDetailSheet extends StatelessWidget {
  final CartEntity cart;
  final Function(String productId) onUpdateQuantity;
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header with actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCustomerTap,
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
                    onPressed: onDiscountTap,
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
          // Price type dropdown
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
                    value: 'Dine In',
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'Dine In', child: Text('Dine In')),
                      DropdownMenuItem(value: 'Take Away', child: Text('Take Away')),
                    ],
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          // Cart items
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return _CartItemRow(
                  item: item,
                  onIncrement: () => onUpdateQuantity(item.product.id),
                  onRemove: () => onRemoveItem(item.product.id),
                );
              },
            ),
          ),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.grey50,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Sub Total', value: cart.subtotal),
                const SizedBox(height: 4),
                _SummaryRow(label: 'Tax (10%)', value: cart.tax),
                if (cart.discountAmount > 0)
                  _SummaryRow(label: 'Discount', value: -cart.discountAmount, isDiscount: true),
                const Divider(),
                _SummaryRow(label: 'TOTAL', value: cart.total, isTotal: true),
              ],
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Clear button
                IconButton(
                  onPressed: onClearCart,
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                // Hold button
                IconButton(
                  onPressed: onHold,
                  icon: const Icon(Icons.pause),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                // Payment button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'PAYMENT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.onIncrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Quantity controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.remove, size: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.add, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Item name
          Expanded(
            child: Text(
              item.product.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          // Price
          Text(
            _formatPrice(item.totalPrice),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

final _currencyPattern = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

String _formatPrice(double price) {
  return 'IDR ${price.toStringAsFixed(0).replaceAllMapped(
        _currencyPattern,
        (Match m) => '${m[1]}.',
      )}';
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
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}${_formatPrice(value.abs())}',
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
            color: isDiscount ? AppColors.success : null,
          ),
        ),
      ],
    );
  }
}
