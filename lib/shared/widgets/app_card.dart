import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.tint = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool tint;

  @override
  Widget build(BuildContext context) => Material(
        color: tint ? AppColors.cardTint : AppColors.white,
        borderRadius: AppRadii.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.card,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: AppRadii.card,
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: AppShadows.card,
            ),
            child: child,
          ),
        ),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (onViewAll != null)
            TextButton.icon(
              onPressed: onViewAll,
              label: const Text('Ver todos'),
              icon: const Icon(Icons.chevron_right, size: 18),
              iconAlignment: IconAlignment.end,
            ),
        ],
      );
}
