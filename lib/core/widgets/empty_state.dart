import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Empty state widget for various scenarios.
class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.type,
    this.customTitle,
    this.customMessage,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            Text(
              customTitle ?? _getTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              customMessage ?? _getMessage(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getIconColor().withValues(alpha: 0.1),
            _getIconColor().withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(),
        size: 64,
        color: _getIconColor(),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case EmptyStateType.emptyCart:
        return Icons.shopping_cart_outlined;
      case EmptyStateType.noProducts:
        return Icons.inventory_2_outlined;
      case EmptyStateType.noSearchResults:
        return Icons.search_off;
      case EmptyStateType.noTransactions:
        return Icons.receipt_long_outlined;
      case EmptyStateType.noKas:
        return Icons.account_balance_wallet_outlined;
      case EmptyStateType.noConnection:
        return Icons.wifi_off;
      case EmptyStateType.error:
        return Icons.error_outline;
      case EmptyStateType.noHistory:
        return Icons.history_outlined;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case EmptyStateType.emptyCart:
        return AppColors.primary;
      case EmptyStateType.noProducts:
        return AppColors.secondary;
      case EmptyStateType.noSearchResults:
        return AppColors.warning;
      case EmptyStateType.noTransactions:
        return AppColors.info;
      case EmptyStateType.noKas:
        return AppColors.kasMasuk;
      case EmptyStateType.noConnection:
        return AppColors.error;
      case EmptyStateType.error:
        return AppColors.error;
      case EmptyStateType.noHistory:
        return AppColors.grey600;
    }
  }

  String _getTitle() {
    switch (type) {
      case EmptyStateType.emptyCart:
        return 'Keranjang Kosong';
      case EmptyStateType.noProducts:
        return 'Tidak Ada Produk';
      case EmptyStateType.noSearchResults:
        return 'Tidak Ditemukan';
      case EmptyStateType.noTransactions:
        return 'Belum Ada Transaksi';
      case EmptyStateType.noKas:
        return 'Belum Ada Kas';
      case EmptyStateType.noConnection:
        return 'Tidak Ada Koneksi';
      case EmptyStateType.error:
        return 'Terjadi Kesalahan';
      case EmptyStateType.noHistory:
        return 'Belum Ada Riwayat';
    }
  }

  String _getMessage() {
    switch (type) {
      case EmptyStateType.emptyCart:
        return 'Pilih produk untuk menambahkan ke keranjang';
      case EmptyStateType.noProducts:
        return 'Produk tidak tersedia saat ini.\nSilakan tambahkan produk terlebih dahulu.';
      case EmptyStateType.noSearchResults:
        return 'Pastikan kata kunci yang Anda masukkan benar';
      case EmptyStateType.noTransactions:
        return 'Transaksi akan muncul di sini setelah\npembayaran berhasil';
      case EmptyStateType.noKas:
        return 'Kas masuk dan keluar akan ditampilkan di sini';
      case EmptyStateType.noConnection:
        return 'Periksa koneksi internet Anda dan\ncoba lagi';
      case EmptyStateType.error:
        return 'Terjadi kesalahan. Silakan coba lagi.';
      case EmptyStateType.noHistory:
        return 'Riwayat transaksi akan muncul di sini';
    }
  }
}

enum EmptyStateType {
  emptyCart,
  noProducts,
  noSearchResults,
  noTransactions,
  noKas,
  noConnection,
  error,
  noHistory,
}
