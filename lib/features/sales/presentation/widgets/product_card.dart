import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';

/// Currency formatter utility.
class CurrencyFormatter {
  static final _currencyPattern = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  /// Format price with IDR prefix and thousand separators.
  static String format(double price) {
    return 'IDR ${price.toStringAsFixed(0).replaceAllMapped(
          _currencyPattern,
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Format price without IDR prefix.
  static String formatValue(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          _currencyPattern,
          (Match m) => '${m[1]}.',
        );
  }
}

/// Category icon mapper.
IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
    case 'makanan':
      return Icons.restaurant;
    case 'drinks':
    case 'minuman':
      return Icons.local_cafe;
    case 'rice':
    case 'nasi':
      return Icons.rice_bowl;
    case 'snack':
    case 'snacks':
    case 'camilan':
      return Icons.cookie;
    case 'dessert':
    case 'desserts':
    case 'pencuci mulut':
      return Icons.icecream;
    case 'coffee':
    case 'kopi':
      return Icons.coffee;
    case 'tea':
    case 'teh':
      return Icons.emoji_food_beverage;
    case 'juice':
    case 'jus':
      return Icons.local_bar;
    default:
      return Icons.inventory_2;
  }
}

/// Gradient colors for category-based product cards.
List<Color> getCategoryGradient(String category) {
  switch (category.toLowerCase()) {
    case 'food':
    case 'makanan':
      return [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)]; // Warm orange-red
    case 'drinks':
    case 'minuman':
      return [const Color(0xFF4ECDC4), const Color(0xFF45B7D1)]; // Teal-blue
    case 'rice':
    case 'nasi':
      return [const Color(0xFFFFE66D), const Color(0xFFF4D03F)]; // Golden yellow
    case 'snack':
    case 'snacks':
    case 'camilan':
      return [const Color(0xFFA8E6CF), const Color(0xFF88D8B0)]; // Mint green
    case 'dessert':
    case 'desserts':
    case 'pencuci mulut':
      return [const Color(0xFFFFB6C1), const Color(0xFFFF69B4)]; // Pink
    case 'coffee':
    case 'kopi':
      return [const Color(0xFF8B4513), const Color(0xFFA0522D)]; // Brown
    case 'tea':
    case 'teh':
      return [const Color(0xFF98D8C8), const Color(0xFF7FCDCD)]; // Sage green
    case 'juice':
    case 'jus':
      return [const Color(0xFFFFA07A), const Color(0xFFFF6347)]; // Orange-red
    default:
      return [AppColors.primary, AppColors.primaryLight]; // Default brand gradient
  }
}

/// Product card widget with modern design - gradient placeholders, badges, and animations.
class ProductCard extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  final bool hasDiscount;
  final int? discountPercent;
  final bool isOutOfStock;
  final int quantityInCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.hasDiscount = false,
    this.discountPercent,
    this.isOutOfStock = false,
    this.quantityInCart = 0,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.isOutOfStock) {
      HapticFeedback.lightImpact();
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = getCategoryGradient(widget.product.category);
    final categoryIcon = getCategoryIcon(widget.product.category);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Main card content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product image/icon area with gradient
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Centered category icon
                            Center(
                              child: Icon(
                                categoryIcon,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            // Out of stock overlay
                            if (widget.isOutOfStock)
                              Container(
                                color: Colors.black.withValues(alpha: 0.5),
                                child: const Center(
                                  child: Text(
                                    'STOK HABIS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Product info area - flexible height
                    Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      color: AppColors.surface,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Product name - flexible with ellipsis
                          Flexible(
                            child: Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.isOutOfStock
                                    ? AppColors.grey500
                                    : AppColors.textPrimary,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Price
                          if (widget.hasDiscount && widget.discountPercent != null) ...[
                            Text(
                              CurrencyFormatter.format(
                                widget.product.price *
                                    (100 - widget.discountPercent!) /
                                    100,
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ] else
                            Text(
                              CurrencyFormatter.format(widget.product.price),
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.isOutOfStock
                                    ? AppColors.grey500
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Discount badge
                if (widget.hasDiscount && widget.discountPercent != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '-${widget.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Quantity badge
                if (widget.quantityInCart > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 22,
                        minHeight: 22,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.quantityInCart}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Add to cart indicator
                if (!widget.isOutOfStock)
                  Positioned(
                    bottom: 60,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: gradientColors[0],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
