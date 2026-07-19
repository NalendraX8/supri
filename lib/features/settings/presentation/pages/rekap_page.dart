import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

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
  final double _saldoAwal = 200000;
  final double _penjualanTunai = 1450000;
  final double _kasMasuk = 100000;
  final double _kasKeluar = 520000;

  late final TextEditingController _aktualController;
  double _aktualAmount = 0;

  @override
  void initState() {
    super.initState();
    _aktualController = TextEditingController();
    _aktualController.addListener(_onAktualChanged);
  }

  @override
  void dispose() {
    _aktualController.dispose();
    super.dispose();
  }

  void _onAktualChanged() {
    final text = _aktualController.text.replaceAll('.', '');
    setState(() {
      _aktualAmount = double.tryParse(text) ?? 0;
    });
  }

  double get _expectedCash => _saldoAwal + _penjualanTunai + _kasMasuk - _kasKeluar;
  double get _selisih => _aktualAmount - _expectedCash;

  String _formatPrice(double price) {
    final isNegative = price < 0;
    final absPrice = price.abs();
    final formatted = 'Rp ${absPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
    return isNegative ? '-$formatted' : formatted;
  }

  void _showClosingConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.primary, size: 28),
            SizedBox(width: 8),
            Text('Tutup Kasir'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin menutup kasir sekarang?\n\n'
          'Sesi kasir Anda akan ditutup dan data shift akan dikirimkan ke Zales ERP.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Shift berhasil ditutup. Menutup sesi...'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('TUTUP KASIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap Shift'),
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
                  _SummaryRow(label: 'Saldo Awal', value: _formatPrice(_saldoAwal)),
                  _SummaryRow(label: 'Penjualan Tunai', value: _formatPrice(_penjualanTunai)),
                  _SummaryRow(label: 'Kas Masuk (+)', value: _formatPrice(_kasMasuk)),
                  _SummaryRow(label: 'Kas Keluar (-)', value: _formatPrice(_kasKeluar)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _SummaryRow(
                    label: 'Ekspektasi Kas Laci',
                    value: _formatPrice(_expectedCash),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Reconciliation Form
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rekonsiliasi Kas Laci',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _aktualController,
                    decoration: const InputDecoration(
                      labelText: 'Uang Aktual di Laci (Rp)',
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan jumlah uang fisik di laci',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selisih Kas',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '(Aktual - Ekspektasi)',
                            style: TextStyle(fontSize: 10, color: AppColors.grey500),
                          ),
                        ],
                      ),
                      Text(
                        _formatPrice(_selisih),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selisih == 0
                              ? AppColors.success
                              : (_selisih > 0 ? AppColors.success : AppColors.error),
                        ),
                      ),
                    ],
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
                  const _SummaryRow(label: 'Total Transaksi', value: '4'),
                  _SummaryRow(label: 'Total Omset', value: _formatPrice(_penjualanTunai)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            AppButton(
              text: 'TUTUP KASIR',
              variant: AppButtonVariant.primary,
              onPressed: _showClosingConfirmation,
              isFullWidth: true,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'BATAL',
                style: TextStyle(color: AppColors.grey600),
              ),
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
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? AppColors.textPrimary : AppColors.grey700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
