import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../features/contacts/domain/contact.dart';
import '../../../features/contacts/presentation/contact_provider.dart';
import '../../../features/profile/presentation/profile_provider.dart';
import '../../../features/profile/domain/profile.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';

class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider).where((contact) => contact.category == ContactCategory.family || contact.category == ContactCategory.doctor).take(2).toList();
    final profile = ref.watch(profileProvider);
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onDestinationSelected: (index) => context.go(['/home', '/health', '/routine', '/profile'][index]),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, AppSpacing.lg),
          children: [
            Row(children: [IconButton.filled(onPressed: () => context.pop(), style: IconButton.styleFrom(backgroundColor: AppColors.wine, foregroundColor: AppColors.white), icon: const Icon(Icons.arrow_back, size: 18)), const SizedBox(width: 8), Text('Central de Emergência', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.wine, fontWeight: FontWeight.w800))]),
            const SizedBox(height: 14),
            _SamuCard(onCall: () => context.push('/mock-call/samu')),
            const SizedBox(height: 10),
            const _EmergencyHeading('Contatos de Emergência'),
            const SizedBox(height: 6),
            for (final contact in contacts) Padding(padding: const EdgeInsets.only(bottom: 7), child: _EmergencyContact(contact: contact, onCall: () => context.push('/mock-call/${contact.id}'))),
            const SizedBox(height: 8),
            const _EmergencyHeading('Suas Informações de Saúde'),
            const SizedBox(height: 6),
            _HealthSummary(profile: profile),
          ],
        ),
      ),
    );
  }
}

class _SamuCard extends StatelessWidget {
  const _SamuCard({required this.onCall});
  final VoidCallback onCall;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    decoration: BoxDecoration(color: AppColors.wine, borderRadius: BorderRadius.circular(20)),
    child: Column(children: [
      const CircleAvatar(radius: 14, backgroundColor: AppColors.white, foregroundColor: AppColors.wine, child: Icon(Icons.warning_amber_rounded, size: 19)),
      const SizedBox(height: 5),
      const Text('Precisa de Ajuda Médica?', style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w800)),
      const Text('Ligação direta para o SAMU (192)', style: TextStyle(color: AppColors.lightText, fontSize: 10)),
      const SizedBox(height: 9),
      SizedBox(width: double.infinity, height: 34, child: FilledButton(onPressed: onCall, style: FilledButton.styleFrom(backgroundColor: AppColors.lightText, foregroundColor: AppColors.wine), child: const Text('LIGAR AGORA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)))),
    ]),
  );
}

class _EmergencyHeading extends StatelessWidget {
  const _EmergencyHeading(this.text); final String text;
  @override Widget build(BuildContext context) => Text(text, style: const TextStyle(color: AppColors.wine, fontSize: 12, fontWeight: FontWeight.w800));
}

class _EmergencyContact extends StatelessWidget {
  const _EmergencyContact({required this.contact, required this.onCall});
  final Contact contact; final VoidCallback onCall;
  @override
  Widget build(BuildContext context) => Container(
    height: 47, padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: AppColors.formField, border: Border.all(color: AppColors.cardBorder), borderRadius: BorderRadius.circular(11)),
    child: Row(children: [
      CircleAvatar(radius: 14, backgroundColor: AppColors.wine, foregroundColor: AppColors.white, child: Text(contact.name.substring(0, 1), style: const TextStyle(fontSize: 11))),
      const SizedBox(width: 9), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(contact.name, style: const TextStyle(color: AppColors.wine, fontSize: 11, fontWeight: FontWeight.w800)), Text(contact.relationship, style: const TextStyle(color: AppColors.wineText, fontSize: 9))])),
      SizedBox(
        height: 28,
        child: FilledButton(
          onPressed: onCall,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.wine,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Ligar', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ),
    ]),
  );
}

class _HealthSummary extends StatelessWidget {
  const _HealthSummary({required this.profile}); final UserProfile profile;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: AppColors.wine, borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Tipo Sanguíneo: ${profile.bloodType}', style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      const SizedBox(height: 5), Text('Alergias: ${profile.allergies}', style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      const SizedBox(height: 5), const Text('Condições: Hipertensão (Usa Losartana 50mg)', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      const SizedBox(height: 7), const Text('* Exibido para facilitar o atendimento de emergência.', style: TextStyle(color: AppColors.lightText, fontSize: 8)),
    ]),
  );
}
