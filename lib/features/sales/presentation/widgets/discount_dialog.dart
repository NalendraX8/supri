import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Discount dialog for applying discounts.
class DiscountDialog extends StatefulWidget {
  final Function(double? percent, double? value, bool isPercent) onApply;

  const DiscountDialog({super.key, required this.onApply});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  bool _isPercent = true;
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onSave() {
    final amount = double.tryParse(_amountController.text);

    // Validate amount
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate percentage (max 100%)
    if (_isPercent && amount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Percentage cannot exceed 100%')),
      );
      return;
    }

    // Skip if no amount entered
    if (amount == 0) {
      Navigator.pop(context);
      return;
    }

    widget.onApply(
      _isPercent ? amount : null,
      !_isPercent ? amount : null,
      _isPercent,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Discount'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Radio buttons
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: _isPercent,
                onChanged: (value) => setState(() => _isPercent = value ?? true),
              ),
              const Text('Percent'),
              const SizedBox(width: 24),
              Radio<bool>(
                value: false,
                groupValue: _isPercent,
                onChanged: (value) => setState(() => _isPercent = value ?? false),
              ),
              const Text('Value'),
            ],
          ),
          const SizedBox(height: 16),
          // Amount input
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              hintText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
          ),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
