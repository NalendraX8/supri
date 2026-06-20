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
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Cash Management',
                  style: TextStyle(
                    fontSize: 18,
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
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
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
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToHistory?.call();
                  },
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
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Date
          Column(
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
          const Spacer(),
          // Amount
          Row(
            children: [
              Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                size: 16,
                color: isIncome ? AppColors.success : AppColors.error,
              ),
              Text(
                _formatPrice(amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppColors.success : AppColors.error,
                ),
              ),
            ],
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
