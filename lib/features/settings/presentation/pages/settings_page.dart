import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

/// Settings page.
class SettingsPage extends StatelessWidget {
  final VoidCallback? onNavigateToSales;
  final VoidCallback? onNavigateToHistory;
  final VoidCallback? onNavigateToKas;
  final VoidCallback? onNavigateToRekap;
  final VoidCallback? onLogout;

  const SettingsPage({
    super.key,
    this.onNavigateToSales,
    this.onNavigateToHistory,
    this.onNavigateToKas,
    this.onNavigateToRekap,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Printers section
          AppCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printers settings coming soon')),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.print, color: AppColors.primary),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'PRINTERS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.grey400),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Mode section
          AppCard(
            onTap: () {
              _showModeDialog(context);
            },
            child: const Row(
              children: [
                Icon(Icons.developer_mode, color: AppColors.primary),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'MODE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Production'),
              leading: Radio<String>(
                value: 'production',
                groupValue: 'production',
                onChanged: (_) {},
              ),
            ),
            ListTile(
              title: const Text('Demo'),
              leading: Radio<String>(
                value: 'demo',
                groupValue: 'production',
                onChanged: (_) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('SAVE'),
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
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToHistory?.call();
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  label: 'Setting',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
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
