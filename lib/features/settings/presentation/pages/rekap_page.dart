import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

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
      drawer: _buildDrawer(context),
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
                        'Ringkasan Kas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _SummaryRow(label: 'Saldo Awal', value: 'IDR 0'),
                  const _SummaryRow(label: 'Penjualan Tunai', value: 'IDR 0'),
                  const _SummaryRow(label: 'Kas', value: 'IDR 0'),
                  const _SummaryRow(label: 'Aktual', value: 'IDR 0'),
                  const Divider(height: 16),
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
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.point_of_sale, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Ringkasan Penjualan',
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
                        'Penjualan Per Kategori',
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
                _NavDrawerItem(
                  icon: Icons.shopping_cart,
                  label: 'Sales',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToSales?.call();
                  },
                ),
                _NavDrawerItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Kas',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToKas?.call();
                  },
                ),
                _NavDrawerItem(
                  icon: Icons.bar_chart,
                  label: 'Rekap',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _NavDrawerItem(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToHistory?.call();
                  },
                ),
                _NavDrawerItem(
                  icon: Icons.settings,
                  label: 'Setting',
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigateToSettings?.call();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _NavDrawerItem(
            icon: Icons.logout,
            label: 'Log Out',
            textColor: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              widget.onLogout?.call();
            },
          ),
          const SizedBox(height: 8),
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

class _NavDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color? textColor;
  final VoidCallback onTap;

  const _NavDrawerItem({
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
