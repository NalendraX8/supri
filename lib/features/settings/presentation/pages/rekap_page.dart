import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../main.dart';

/// Rekap (Summary) page.
class RekapPage extends StatefulWidget {
  final VoidCallback? onNavigateToSales;
  final VoidCallback? onNavigateToHistory;
  final VoidCallback? onNavigateToKas;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onLogout;

  const RekapPage({
    super.key,
    this.onNavigateToSales,
    this.onNavigateToHistory,
    this.onNavigateToKas,
    this.onNavigateToSettings,
    this.onLogout,
  });

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Rekap'),
      ),
      drawer: AppDrawer(
        currentRoute: 'rekap',
        onNavigateToSales: () => context.navigateToSales(),
        onNavigateToKas: () => context.navigateToKas(),
        onNavigateToRekap: () => context.navigateToRekap(),
        onNavigateToHistory: () => context.navigateToHistory(),
        onNavigateToSettings: () => context.navigateToSettings(),
        onLogout: () => context.logout(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cash Summary Card
            AppCard(
              backgroundColor: AppColors.success.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Ringkasan Kas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  const _SummaryRow(label: 'Saldo Awal', value: 'IDR 0'),
                  const _SummaryRow(label: 'Penjualan Tunai', value: 'IDR 0'),
                  const _SummaryRow(label: 'Kas', value: 'IDR 0'),
                  const _SummaryRow(label: 'Aktual', value: 'IDR 0'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  const _SummaryRow(
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
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.point_of_sale,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Ringkasan Penjualan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  const _SummaryRow(label: 'Void', value: '0'),
                  const _SummaryRow(label: 'Total Penjualan', value: 'IDR 0'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sales By Category Card
            AppCard(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.category,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Penjualan Per Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  const _CategoryRow(category: 'Makanan', count: 0, amount: 0),
                  const _CategoryRow(category: 'Minuman', count: 0, amount: 0),
                  const _CategoryRow(category: 'Nasi', count: 0, amount: 0),
                  const _CategoryRow(category: 'Bahan Baku', count: 0, amount: 0),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.grey700,
                ),
              ),
              if (note != null)
                Text(
                  note!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey500,
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(category),
          ),
          Text(
            '$count items',
            style: const TextStyle(
              color: AppColors.grey600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatPrice(amount),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
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
