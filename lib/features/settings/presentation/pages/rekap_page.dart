import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

/// Rekap (Summary) page.
class RekapPage extends StatelessWidget {
  const RekapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  _SummaryRow(label: 'Saldo Awal', value: 'IDR 0'),
                  _SummaryRow(label: 'Penjualan Tunai', value: 'IDR 0'),
                  _SummaryRow(label: 'Kas', value: 'IDR 0'),
                  _SummaryRow(label: 'Aktual', value: 'IDR 0'),
                  const Divider(height: 16),
                  _SummaryRow(
                    label: 'Selisih',
                    value: 'IDR 0',
                    note: '(Aktual - (Saldo Awal + Penjualan))',
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
                  _SummaryRow(label: 'Void', value: '0'),
                  _SummaryRow(label: 'Total Penjualan', value: 'IDR 0'),
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
                  _CategoryRow(category: 'Food', count: 0, amount: 0),
                  _CategoryRow(category: 'Drinks', count: 0, amount: 0),
                  _CategoryRow(category: 'Rice', count: 0, amount: 0),
                  _CategoryRow(category: 'Bahan Baku', count: 0, amount: 0),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'CLOSE',
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.pop(context),
              isFullWidth: true,
            ),
          ],
        ),
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
