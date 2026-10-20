import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class FilterTabBar extends StatelessWidget {
  const FilterTabBar({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            labels.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : AppSpacing.xs),
              child: ChoiceChip(
                label: Text(labels[index]),
                selected: index == selectedIndex,
                onSelected: (_) => onSelected(index),
                selectedColor: AppColors.wine,
                labelStyle: TextStyle(
                  color: index == selectedIndex ? AppColors.white : AppColors.darkText,
                ),
              ),
            ),
          ),
        ),
      );
}

class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
        avatar: Icon(Icons.circle, size: 10, color: color),
        label: Text(label),
        side: BorderSide(color: color),
      );
}
