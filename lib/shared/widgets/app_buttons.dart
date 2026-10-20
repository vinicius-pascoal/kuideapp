import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: enabled ? onPressed : null,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : icon == null
              ? const SizedBox.shrink()
              : Icon(icon),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.wine,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.wine.withValues(alpha: 0.4),
            shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon == null ? const SizedBox.shrink() : Icon(icon),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.wine,
            side: const BorderSide(color: AppColors.wine),
            shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
          ),
        ),
      );
}

class DangerButton extends StatelessWidget {
  const DangerButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
          ),
          child: Text(label),
        ),
      );
}

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticLabel,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          tooltip: semanticLabel,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          padding: const EdgeInsets.all(AppSpacing.sm),
        ),
      );
}
