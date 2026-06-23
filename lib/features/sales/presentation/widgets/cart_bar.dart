import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import 'product_card.dart';

/// Enhanced cart bottom bar with polished design.
class CartBar extends StatelessWidget {
  final CartEntity cart;
  final VoidCallback onChargeTap;
  final VoidCallback onCartTap;
  final bool hasHeldItems;

  const CartBar({
    super.key,
    required this.cart,
    required this.onChargeTap,
    required this.onCartTap,
    this.hasHeldItems = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cart icon with badge and tap
            GestureDetector(
              onTap: onCartTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x40E53935),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Held items indicator
                    if (hasHeldItems)
                      Positioned(
                        left: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pause,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Total amount - enhanced visibility
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.isEmpty ? 'Keranjang Kosong' : 'Total',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!cart.isEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(cart.total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Charge button - prominent CTA
            GestureDetector(
              onTap: cart.isEmpty
                  ? null
                  : () {
                      HapticFeedback.mediumImpact();
                      onChargeTap();
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: cart.isEmpty
                      ? null
                      : const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: cart.isEmpty ? AppColors.grey300 : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: cart.isEmpty
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!cart.isEmpty) ...[
                      const Icon(
                        Icons.payment,
                        color: AppColors.textOnPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      'BAYAR',
                      style: TextStyle(
                        color: cart.isEmpty
                            ? AppColors.grey600
                            : AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
