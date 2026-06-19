import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const _selectedLabelStyle = TextStyle(
  color: AppColors.textOnPrimary,
  fontWeight: FontWeight.w500,
);

const _unselectedLabelStyle = TextStyle(
  color: AppColors.textPrimary,
  fontWeight: FontWeight.w500,
);

/// Category filter chips widget.
class CategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, String>> categories = [
    {'id': '', 'name': 'All'},
    {'id': 'Rice', 'name': 'Rice'},
    {'id': 'Bahan Baku', 'name': 'Bahan Baku'},
    {'id': 'Drinks', 'name': 'Drinks'},
    {'id': 'Food', 'name': 'Food'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['id'] ||
              (selectedCategory == null && category['id'] == '');

          return FilterChip(
            label: Text(category['name']!),
            selected: isSelected,
            onSelected: (_) {
              onCategorySelected(category['id'] == '' ? null : category['id']);
            },
            backgroundColor: AppColors.grey100,
            selectedColor: AppColors.primary,
            labelStyle: isSelected ? _selectedLabelStyle : _unselectedLabelStyle,
            checkmarkColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.grey300,
              ),
            ),
          );
        },
      ),
    );
  }
}
