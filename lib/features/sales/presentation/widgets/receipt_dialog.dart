import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import 'product_card.dart'; // For CurrencyFormatter

/// Interactive Dialog simulating a physical thermal paper receipt with print/share action controls.
class ReceiptDialog extends StatelessWidget {
  final CartEntity cart;
  final VoidCallback onNewTransaction;

  const ReceiptDialog({
    super.key,
    required this.cart,
    required this.onNewTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Simulated Thermal Paper Roll
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Store info)
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 8),
                  child: Column(
                    children: [
                      // Mini logo
                      Image.asset(
                        AppConstants.logoBlackLandscape,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Usaha Mulia, Transaksi Bahagia',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, thickness: 1, color: AppColors.grey300),
                    ],
                  ),
                ),

                // Metadata (Date, Shift, Cashier)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReceiptRow('Tanggal', _getFormattedDate(), isLabel: true),
                      _buildReceiptRow('Kasir', 'Demo Cashier', isLabel: true),
                      if (cart.customerName != null && cart.customerName!.isNotEmpty)
                        _buildReceiptRow('Pelanggan', cart.customerName!, isLabel: true),
                      const SizedBox(height: 6),
                      _buildDashedLine(),
                    ],
                  ),
                ),

                // Items list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      ...cart.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey800,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.quantity}x ${CurrencyFormatter.formatValue(item.product.price)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatValue(item.totalPrice),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.grey800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                      _buildDashedLine(),
                    ],
                  ),
                ),

                // Total calculations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      _buildReceiptRow('Subtotal', CurrencyFormatter.formatValue(cart.subtotal)),
                      if (cart.discountAmount > 0)
                        _buildReceiptRow(
                          'Diskon',
                          '-${CurrencyFormatter.formatValue(cart.discountAmount)}',
                          isDiscount: true,
                        ),
                      _buildReceiptRow('PPN (10%)', CurrencyFormatter.formatValue(cart.tax)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(cart.total),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDashedLine(),
                    ],
                  ),
                ),

                // Footer Thank you message
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 24, left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        'TERIMA KASIH',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: AppColors.grey800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Silakan berkunjung kembali',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Receipt Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.print_outlined,
                label: 'Cetak',
                onTap: (ctx) => _showSimulationSnackbar(ctx, 'Menghubungkan ke printer & mencetak...'),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Bagikan',
                onTap: (ctx) => _showSimulationSnackbar(ctx, 'Membagikan struk via WhatsApp...'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onNewTransaction,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Baru'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isLabel = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isLabel ? AppColors.grey500 : AppColors.grey700,
              fontWeight: isLabel ? FontWeight.normal : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: isDiscount ? AppColors.success : (isLabel ? AppColors.grey700 : AppColors.grey900),
              fontWeight: isLabel ? FontWeight.normal : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : AppColors.grey300,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required void Function(BuildContext) onTap,
  }) {
    return Builder(
      builder: (context) => ElevatedButton.icon(
        onPressed: () => onTap(context),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  void _showSimulationSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.sync, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
