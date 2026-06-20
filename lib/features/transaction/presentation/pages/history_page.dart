import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

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
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
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
      drawer: _buildDrawer(context),
      body: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    // Mock transaction data
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DateHeader(date: '17 Mar 2026'),
        _TransactionCard(
          transaction: transactions[0],
          onTap: () {},
        ),
        _TransactionCard(
          transaction: transactions[1],
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _DateHeader(date: '16 Mar 2026'),
        _TransactionCard(
          transaction: transactions[2],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Supri',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Usaha Mulia, Transaksi Bahagia',
                  style: TextStyle(color: AppColors.textOnPrimary, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.shopping_cart,
                  label: 'Sales',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToSales?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Kas',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToKas?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart,
                  label: 'Rekap',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToRekap?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  label: 'History',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  label: 'Setting',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToSettings?.call();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Log Out',
            textColor: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              onLogout?.call();
            },
          ),
          const SizedBox(height: 8),
        ],
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: AppColors.grey600),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.grey600,
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
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            transaction.time,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.invoice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      transaction.customer,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatPrice(transaction.amount),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            transaction.isSynced ? Icons.check_circle : Icons.sync,
            size: 16,
            color: transaction.isSynced ? AppColors.synced : AppColors.pending,
          ),
          const SizedBox(width: 4),
          Text(
            transaction.isSynced ? 'Synced' : 'Pending',
            style: TextStyle(
              fontSize: 10,
              color: transaction.isSynced ? AppColors.synced : AppColors.pending,
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color? textColor;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : (textColor ?? AppColors.grey700)),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? (isSelected ? AppColors.primary : AppColors.textPrimary),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: onTap,
    );
  }
}
