import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../data/home_mock_data.dart';
import '../domain/quick_access_item.dart';

class QuickAccessScreen extends StatefulWidget {
  const QuickAccessScreen({super.key});

  @override
  State<QuickAccessScreen> createState() => _QuickAccessScreenState();
}

class _QuickAccessScreenState extends State<QuickAccessScreen> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.toLowerCase().trim();
    final items = HomeMockData.expandedQuickAccess
        .where((item) => '${item.label} ${item.description}'.toLowerCase().contains(normalizedQuery))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppHeader(title: 'Acesso rápido', onBack: () => context.pop()),
              const SizedBox(height: AppSpacing.md),
              AppSearchField(onChanged: (value) => setState(() => _query = value)),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Nenhum atalho encontrado.'))
                    : GridView.builder(
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 1.12,
                        ),
                        itemBuilder: (context, index) => _QuickAccessCard(item: items[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({required this.item});

  final QuickAccessItem item;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: () => context.push(item.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 34),
            const SizedBox(height: AppSpacing.xs),
            Text(item.label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xxs),
            Text(item.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}
