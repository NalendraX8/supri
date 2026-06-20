import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

/// Shift Detail page.
class ShiftDetailPage extends StatefulWidget {
  final String shiftId;
  final DateTime createdAt;
  final String status;
  final String outletName;

  const ShiftDetailPage({
    super.key,
    required this.shiftId,
    required this.createdAt,
    required this.status,
    required this.outletName,
  });

  @override
  State<ShiftDetailPage> createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends State<ShiftDetailPage> {
  bool get _isOpen => widget.status == 'OPEN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Shift'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Shift Info Card
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shiftId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.outletName,
                        style: const TextStyle(color: AppColors.grey600),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isOpen ? AppColors.success.withValues(alpha: 0.1) : AppColors.grey300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: _isOpen ? AppColors.success : AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Cash Summary Card
            AppCard(
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(
                        'Cash Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _SummaryRow(label: 'Saldo Awal', value: 'IDR 500.000'),
                  const _SummaryRow(label: 'Penjualan Tunai', value: 'IDR 0'),
                  const _SummaryRow(label: 'Kas', value: 'IDR 0'),
                  const _SummaryRow(label: 'Kas Masuk', value: 'IDR 0'),
                  const _SummaryRow(label: 'Kas Keluar', value: 'IDR 0'),
                  const _SummaryRow(label: 'Aktual', value: 'IDR 500.000'),
                  const Divider(height: 16),
                  const _SummaryRow(
                    label: 'Selisih',
                    value: 'IDR 0',
                    note: '(Aktual - (Saldo Awal + Penjualan + Kas Masuk - Kas Keluar))',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sales Summary Card
            AppCard(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.point_of_sale, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Sales Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _SummaryRow(label: 'Void', value: '0'),
                  const _SummaryRow(label: 'Total Penjualan', value: 'IDR 0'),
                  const _SummaryRow(label: 'Transaksi Berhasil', value: '0'),
                  const _SummaryRow(label: 'Transaksi Void', value: '0'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sales By Category Card
            AppCard(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.category, color: AppColors.secondary),
                      SizedBox(width: 8),
                      Text(
                        'Sales By Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _CategoryRow(category: 'Makanan', count: 0, amount: 0),
                  const _CategoryRow(category: 'Minuman', count: 0, amount: 0),
                  const _CategoryRow(category: 'Nasi', count: 0, amount: 0),
                  const _CategoryRow(category: 'Bahan Baku', count: 0, amount: 0),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: _isOpen ? 'CLOSE SHIFT' : 'CLOSE',
              variant: _isOpen ? AppButtonVariant.primary : AppButtonVariant.secondary,
              onPressed: _isOpen ? () => _showCloseShiftDialog(context) : () => Navigator.pop(context),
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showCloseShiftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close Shift'),
        content: const Text('Are you sure you want to close this shift?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shift closed successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final String? note;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              if (note != null)
                Text(
                  note!,
                  style: const TextStyle(fontSize: 10, color: AppColors.grey500),
                ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final int count;
  final double amount;

  const _CategoryRow({
    required this.category,
    required this.count,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category),
          Text(
            '$count items',
            style: const TextStyle(color: AppColors.grey600),
          ),
          Text(
            _formatPrice(amount),
            style: const TextStyle(fontWeight: FontWeight.w600),
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
