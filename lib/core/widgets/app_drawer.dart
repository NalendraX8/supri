import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Shared navigation drawer widget for consistent app navigation.
class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final String userEmail;
  final String outletName;
  final VoidCallback onNavigateToSales;
  final VoidCallback onNavigateToKas;
  final VoidCallback onNavigateToRekap;
  final VoidCallback onNavigateToHistory;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.userEmail = 'demo@supri.id',
    this.outletName = 'Toko Utama',
    required this.onNavigateToSales,
    required this.onNavigateToKas,
    required this.onNavigateToRekap,
    required this.onNavigateToHistory,
    required this.onNavigateToSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.shopping_cart,
                  label: 'Sales',
                  isSelected: currentRoute == 'sales',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToSales();
                  },
                ),
                _DrawerItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Kas',
                  isSelected: currentRoute == 'kas',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToKas();
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart,
                  label: 'Rekap',
                  isSelected: currentRoute == 'rekap',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToRekap();
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  label: 'History',
                  isSelected: currentRoute == 'history',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToHistory();
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  label: 'Setting',
                  isSelected: currentRoute == 'settings',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigateToSettings();
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
              onLogout();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              AppConstants.logoBlackLandscape,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            userEmail,
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.store,
                color: AppColors.textOnPrimary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                outletName,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : (textColor ?? AppColors.grey700),
      ),
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
