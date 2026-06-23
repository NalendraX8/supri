import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Kas (Cash Management) page.
class KasPage extends StatelessWidget {
  final VoidCallback? onNavigateToSales;
  final VoidCallback? onNavigateToHistory;
  final VoidCallback? onNavigateToRekap;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onLogout;

  const KasPage({
    super.key,
    this.onNavigateToSales,
    this.onNavigateToHistory,
    this.onNavigateToRekap,
    this.onNavigateToSettings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPRI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cash Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Transaction list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _KasItem(
                  date: '18 May 2025 19:16',
                  type: 'donasi',
                  category: 'Pendapatan Komisi',
                  amount: 50000,
                  isIncome: true,
                ),
                const SizedBox(height: 8),
                _KasItem(
                  date: '18 May 2025 18:05',
                  type: 'uang tips',
                  category: 'Pendapatan Komisi',
                  amount: 50000,
                  isIncome: true,
                ),
                const SizedBox(height: 8),
                _KasItem(
                  date: '18 May 2025 18:05',
                  type: 'bayar listrik',
                  category: 'Biaya Listrik',
                  amount: 120000,
                  isIncome: false,
                ),
                const SizedBox(height: 8),
                _KasItem(
                  date: '18 May 2025 17:45',
                  type: 'bayar listrik',
                  category: 'Biaya Listrik',
                  amount: 400000,
                  isIncome: false,
                ),
              ],
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kas Masuk coming soon')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('KAS MASUK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kas Keluar coming soon')),
                      );
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('KAS KELUAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kasKeluar,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

class _KasItem extends StatelessWidget {
  final String date;
  final String type;
  final String category;
  final double amount;
  final bool isIncome;

  const _KasItem({
    required this.date,
    required this.type,
    required this.category,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon indicator
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isIncome ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Date and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: AppColors.grey600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isIncome ? AppColors.success : AppColors.error,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey500),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            _formatPrice(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
