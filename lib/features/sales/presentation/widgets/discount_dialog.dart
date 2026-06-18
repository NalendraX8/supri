import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/sales_bloc.dart';
import '../bloc/sales_event.dart';

/// Discount dialog for applying discounts.
class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

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
    final amount = double.tryParse(_amountController.text) ?? 0;

    context.read<SalesBloc>().add(
          ApplyDiscountEvent(
            percent: _isPercent ? amount : null,
            value: !_isPercent ? amount : null,
            isPercent: _isPercent,
          ),
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
          AppTextField(
            controller: _amountController,
            hintText: 'Amount',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.attach_money,
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
