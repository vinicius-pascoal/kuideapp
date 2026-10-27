import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_header.dart';
import '../domain/medication.dart';
import 'medication_provider.dart';

class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationsProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppHeader(title: 'Medicamentos', onBack: () => context.pop()),
            const SizedBox(height: AppSpacing.sm),
            const Text('Acompanhamento local e demonstrativo. Não substitui orientação profissional.'),
            const SizedBox(height: AppSpacing.lg),
            for (final medication in medications) _MedicationTile(medication: medication),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(label: 'Adicionar medicamento', icon: Icons.add, onPressed: () => context.push('/medications/add')),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: 'Ver receita médica',
              icon: Icons.description_outlined,
              onPressed: () => context.push('/medications/prescription'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationTile extends ConsumerWidget {
  const _MedicationTile({required this.medication});

  final Medication medication;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: AppCard(
          tint: false,
          child: Row(
            children: [
              Icon(medication.taken ? Icons.check_circle : Icons.medication_outlined, color: AppColors.wine),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${medication.name} ${medication.dosage}', style: Theme.of(context).textTheme.titleMedium),
                    Text('${medication.form} • ${medication.period} • ${medication.time}'),
                    if (medication.hasLowStock)
                      const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.xxs),
                        child: Text('Estoque baixo', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => ref.read(medicationsProvider.notifier).toggleTaken(medication.id),
                child: Text(medication.taken ? 'Tomado' : 'Tomar'),
              ),
            ],
          ),
        ),
      );
}
