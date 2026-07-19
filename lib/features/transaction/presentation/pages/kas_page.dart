import 'package:flutter/material.dart';

import '../../../../core/storage/settings_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/demo_badge.dart';
import '../../../../injection_container.dart';

class KasTransaction {
  final String date;
  final String type;
  final String category;
  final double amount;
  final bool isIncome;

  KasTransaction({
    required this.date,
    required this.type,
    required this.category,
    required this.amount,
    required this.isIncome,
  });
}

/// Kas (Cash Management) page.
class KasPage extends StatefulWidget {
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
  State<KasPage> createState() => _KasPageState();
}

class _KasPageState extends State<KasPage> {
  final List<KasTransaction> _transactions = [
    KasTransaction(
      date: '18 May 2025 19:16',
      type: 'donasi',
      category: 'Pendapatan Komisi',
      amount: 50000,
      isIncome: true,
    ),
    KasTransaction(
      date: '18 May 2025 18:05',
      type: 'uang tips',
      category: 'Pendapatan Komisi',
      amount: 50000,
      isIncome: true,
    ),
    KasTransaction(
      date: '18 May 2025 18:05',
      type: 'bayar listrik',
      category: 'Biaya Listrik',
      amount: 120000,
      isIncome: false,
    ),
    KasTransaction(
      date: '18 May 2025 17:45',
      type: 'bayar listrik',
      category: 'Biaya Listrik',
      amount: 400000,
      isIncome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPRI'),
        actions: [
          FutureBuilder<String>(
            future: sl<SettingsStorage>().getMode(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == 'demo') {
                return const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: DemoBadge(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final item = _transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _KasItemWidget(transaction: item),
                );
              },
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCashDialog(true),
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
                    onPressed: () => _showCashDialog(false),
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

  void _showCashDialog(bool isIncome) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = isIncome ? 'Pendapatan Komisi' : 'Biaya Operasional';
    
    final categories = isIncome
        ? ['Pendapatan Komisi', 'Pendapatan Bunga', 'Pendapatan Lain']
        : ['Biaya Listrik', 'Biaya Air', 'Biaya Operasional', 'Biaya Bahan Baku'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isIncome ? 'Kas Masuk' : 'Kas Keluar'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Nominal (Rp)',
                    hintText: 'Masukkan jumlah uang',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedCategory = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    hintText: 'Keterangan transaksi (opsional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nominal harus lebih dari 0')),
                  );
                  return;
                }
                
                final now = DateTime.now();
                final formattedDate =
                    '${now.day.toString().padLeft(2, '0')} ${_getMonthName(now.month)} ${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                
                setState(() {
                  _transactions.insert(
                    0,
                    KasTransaction(
                      date: formattedDate,
                      type: noteController.text.isNotEmpty 
                          ? noteController.text 
                          : (isIncome ? 'Kas Masuk' : 'Kas Keluar'),
                      category: selectedCategory,
                      amount: amount,
                      isIncome: isIncome,
                    ),
                  );
                });
                
                Navigator.pop(ctx);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kas ${isIncome ? "Masuk" : "Keluar"} berhasil disimpan'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

class _KasItemWidget extends StatelessWidget {
  final KasTransaction transaction;

  const _KasItemWidget({required this.transaction});

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
              color: (transaction.isIncome ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.isIncome ? AppColors.success : AppColors.error,
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
                      transaction.date,
                      style: const TextStyle(fontSize: 12, color: AppColors.grey600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.type,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: transaction.isIncome ? AppColors.success : AppColors.error,
                  ),
                ),
                Text(
                  transaction.category,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey500),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            _formatPrice(transaction.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: transaction.isIncome ? AppColors.success : AppColors.error,
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
