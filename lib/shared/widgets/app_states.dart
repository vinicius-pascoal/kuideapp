import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class LoadingStateView extends StatelessWidget {
  const LoadingStateView({super.key, this.message = 'Carregando...'});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.wine),
            const SizedBox(height: AppSpacing.sm),
            Text(message),
          ],
        ),
      );
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({required this.message, super.key, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(message, textAlign: TextAlign.center), if (action != null) action!],
          ),
        ),
      );
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => EmptyStateView(
        message: message,
        action: TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
      );
}

class SuccessFeedback extends StatelessWidget {
  const SuccessFeedback({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.wine),
            const SizedBox(width: AppSpacing.xs),
            Text(message),
          ],
        ),
      );
}
