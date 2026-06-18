import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Outlet selection page after login.
class OutletSelectionPage extends StatelessWidget {
  const OutletSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Outlet'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Mengoperasikan banyak outlet hanya 1 aplikasi',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Outlet List
                Expanded(
                  child: ListView(
                    children: [
                      _OutletCard(
                        name: 'Solo Baru',
                        onTap: () => _selectOutlet(context, 'outlet_001', 'Solo Baru'),
                      ),
                      const SizedBox(height: 12),
                      _OutletCard(
                        name: 'Banjarsani',
                        onTap: () => _selectOutlet(context, 'outlet_002', 'Banjarsani'),
                      ),
                      const SizedBox(height: 12),
                      _OutletCard(
                        name: 'Honggowongso',
                        onTap: () => _selectOutlet(context, 'outlet_003', 'Honggowongso'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectOutlet(BuildContext context, String outletId, String outletName) {
    context.read<AuthBloc>().add(
          SelectOutletEvent(outletId: outletId, outletName: outletName),
        );
  }
}

class _OutletCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _OutletCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.store_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.grey400,
          ),
        ],
      ),
    );
  }
}
