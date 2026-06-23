import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../sales/domain/entities/product_entity.dart';
import 'transaction_detail_page.dart';

/// Transaction history page.
class HistoryPage extends StatelessWidget {
  final VoidCallback? onNavigateToSales;
  final VoidCallback? onNavigateToKas;
  final VoidCallback? onNavigateToRekap;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onLogout;

  const HistoryPage({
    super.key,
    this.onNavigateToSales,
    this.onNavigateToKas,
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync in progress...')),
              );
            },
          ),
        ],
      ),
      body: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    final transactions = [
      _TransactionItem(
        date: '17 Mar 2026',
        time: '09:29',
        invoice: 'INV-20260317-18f343',
        customer: 'NN',
        amount: 5500,
        isSynced: true,
      ),
      _TransactionItem(
        date: '17 Mar 2026',
        time: '09:15',
        invoice: 'INV-20260317-18f342',
        customer: 'Ekasa',
        amount: 28500,
        isSynced: false,
      ),
      _TransactionItem(
        date: '16 Mar 2026',
        time: '18:45',
        invoice: 'INV-20260316-17x729',
        customer: 'NN',
        amount: 12000,
        isSynced: true,
      ),
    ];

    return Builder(
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _DateHeader(date: '17 Mar 2026'),
          _TransactionCard(
            transaction: transactions[0],
            onTap: () => _navigateToDetail(ctx, transactions[0]),
          ),
          _TransactionCard(
            transaction: transactions[1],
            onTap: () => _navigateToDetail(ctx, transactions[1]),
          ),
          const SizedBox(height: 16),
          const _DateHeader(date: '16 Mar 2026'),
          _TransactionCard(
            transaction: transactions[2],
            onTap: () => _navigateToDetail(ctx, transactions[2]),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, _TransactionItem transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionDetailPage(
          invoiceId: transaction.invoice,
          cashierName: 'Kasir Demo',
          dateTime: DateTime.now(),
          paymentMethod: 'QRIS',
          orderType: 'Dine In',
          items: [
            CartItemEntity(
              product: ProductEntity(id: '1', name: 'Es Teh Manis', price: 5000, category: 'Minuman'),
              quantity: 1,
            ),
          ],
          subtotal: 5000,
          tax: 500,
          total: 5500,
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.calendar_today,
              size: 14,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final _TransactionItem transaction;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              transaction.time,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.invoice,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: transaction.isSynced
                            ? AppColors.synced.withValues(alpha: 0.1)
                            : AppColors.pending.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            transaction.isSynced ? Icons.check_circle : Icons.sync,
                            size: 12,
                            color: transaction.isSynced
                                ? AppColors.synced
                                : AppColors.pending,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transaction.isSynced ? 'Synced' : 'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: transaction.isSynced
                                  ? AppColors.synced
                                  : AppColors.pending,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    Text(
                      transaction.customer,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatPrice(transaction.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: AppColors.grey400,
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

class _TransactionItem {
  final String date;
  final String time;
  final String invoice;
  final String customer;
  final double amount;
  final bool isSynced;

  _TransactionItem({
    required this.date,
    required this.time,
    required this.invoice,
    required this.customer,
    required this.amount,
    required this.isSynced,
  });
}
