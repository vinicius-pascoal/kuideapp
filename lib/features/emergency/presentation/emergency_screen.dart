import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../features/contacts/domain/contact.dart';
import '../../../features/contacts/presentation/contact_provider.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_header.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref
        .watch(contactsProvider)
        .where(
          (contact) =>
              contact.category == ContactCategory.family ||
              contact.category == ContactCategory.doctor,
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppHeader(
              title: 'Central de emergência',
              onBack: () => context.pop(),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Esta central é demonstrativa. Para uma emergência real, procure os serviços oficiais da sua região.',
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Ligar para SAMU 192 (simulação)',
              icon: Icons.sos,
              onPressed: () => context.push('/mock-call/samu'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Contatos prioritários',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final contact in contacts)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppCard(
                  tint: false,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.person_outline,
                      color: AppColors.wine,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.relationship),
                    trailing: IconButton(
                      onPressed: () => context.push('/mock-call/${contact.id}'),
                      tooltip: 'Chamada simulada para ${contact.name}',
                      icon: const Icon(Icons.call_outlined),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Ficha de saúde de emergência',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo sanguíneo: O+'),
                  Text('Alergia: penicilina'),
                  Text('Condição: hipertensão'),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Dados de demonstração; não são prontuário médico.',
                    style: TextStyle(color: AppColors.wine),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
