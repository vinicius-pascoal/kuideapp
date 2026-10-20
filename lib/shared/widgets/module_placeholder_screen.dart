import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_spacing.dart';
import 'app_header.dart';

class ModulePlaceholderScreen extends StatelessWidget {
  const ModulePlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(title: title, onBack: () => context.pop()),
                const SizedBox(height: AppSpacing.xl),
                Text('$title será detalhado na próxima etapa.', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      );
}
