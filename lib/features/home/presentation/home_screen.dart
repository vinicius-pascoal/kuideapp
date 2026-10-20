import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../features/onboarding/presentation/onboarding_provider.dart';
import '../../../features/medications/presentation/medication_provider.dart';
import '../../../features/tasks/domain/task.dart';
import '../../../features/tasks/presentation/task_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/home_mock_data.dart';
import '../domain/quick_access_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final onboarding = ref.watch(onboardingProvider);
    final medications = ref.watch(medicationsProvider);
    final pendingTasks = ref.watch(tasksProvider).where((task) => !task.completed).toList();
    final name = session.displayName?.trim().isNotEmpty == true ? session.displayName! : 'Maria Santos';
    final pendingMedications = medications.where((medication) => !medication.taken).toList();
    final nextMedication = pendingMedications.isEmpty ? medications.first : pendingMedications.first;
    final medication = '${nextMedication.name} ${nextMedication.dosage}';
    final medicationTime = nextMedication.time;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_greeting(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.darkText)),
                  Text(name, style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: 'Abrir central de emergência',
              child: IconButton.filled(
                onPressed: () => context.push('/emergency'),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.wine,
                  foregroundColor: AppColors.lightText,
                  minimumSize: const Size(64, 64),
                ),
                icon: const Text('SOS', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _TodayCard(
          medication: medication,
          medicationTime: medicationTime,
          onMedicationTap: () => context.push('/medications'),
          onAppointmentTap: () => context.push('/appointments'),
          onRoutineTap: () => context.go('/routine'),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: 'Acesso rápido', onViewAll: () => context.push('/quick-access')),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: HomeMockData.quickAccess.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: .9,
          ),
          itemBuilder: (context, index) => _HomeShortcut(item: HomeMockData.quickAccess[index]),
        ),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(title: 'Ainda falta hoje'),
        const SizedBox(height: AppSpacing.sm),
        if (pendingMedications.isNotEmpty)
          _OutstandingItem(icon: Icons.medication_outlined, title: medication, detail: 'Tomar às $medicationTime', onTap: () => context.push('/medications')),
        for (final task in pendingTasks.take(2))
          _OutstandingItem(icon: Icons.check_circle_outline, title: task.title, detail: task.period.label, onTap: () => context.push('/tasks')),
        if (pendingMedications.isEmpty && pendingTasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Text('Tudo certo por hoje!'),
          ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: 'Próximos compromissos', onViewAll: () => context.push('/appointments')),
        const SizedBox(height: AppSpacing.sm),
        _OutstandingItem(
          icon: Icons.calendar_month_outlined,
          title: onboarding.nextAppointment.isEmpty ? 'Consulta com cardiologista' : onboarding.nextAppointment,
          detail: onboarding.primaryDoctor.isEmpty ? 'Dr. Roberto Silva • Clínica Vida' : onboarding.primaryDoctor,
          onTap: () => context.push('/appointments'),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'BOM DIA';
    if (hour < 18) return 'BOA TARDE';
    return 'BOA NOITE';
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.medication,
    required this.medicationTime,
    required this.onMedicationTap,
    required this.onAppointmentTap,
    required this.onRoutineTap,
  });

  final String medication;
  final String medicationTime;
  final VoidCallback onMedicationTap;
  final VoidCallback onAppointmentTap;
  final VoidCallback onRoutineTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.wine,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [Icon(Icons.today_outlined, color: AppColors.lightText), SizedBox(width: AppSpacing.xs), Text('Seus compromissos', style: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w700))],
            ),
            const SizedBox(height: AppSpacing.md),
            _TodayAction(icon: Icons.medication_outlined, title: medication, subtitle: 'Tomar às $medicationTime', onTap: onMedicationTap),
            const Divider(color: AppColors.lightText),
            _TodayAction(icon: Icons.calendar_month_outlined, title: 'Consulta com cardiologista', subtitle: 'Dr. Roberto Silva • Clínica Vida', onTap: onAppointmentTap),
            const SizedBox(height: AppSpacing.sm),
            TextButton(onPressed: onRoutineTap, child: const Text('Ver rotina completa', style: TextStyle(color: AppColors.lightText))),
          ],
        ),
      );
}

class _TodayAction extends StatelessWidget {
  const _TodayAction({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Icon(icon, color: AppColors.lightText),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: const TextStyle(color: AppColors.lightText)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.lightText),
            ],
          ),
        ),
      );
}

class _HomeShortcut extends StatelessWidget {
  const _HomeShortcut({required this.item});

  final QuickAccessItem item;

  @override
  Widget build(BuildContext context) => AppCard(
        onTap: () => item.route == '/health' || item.route == '/routine' ? context.go(item.route) : context.push(item.route),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 30, color: AppColors.wine),
            const SizedBox(height: AppSpacing.xs),
            Text(item.label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _OutstandingItem extends StatelessWidget {
  const _OutstandingItem({required this.icon, required this.title, required this.detail, required this.onTap});

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: AppCard(
          onTap: onTap,
          tint: false,
          child: Row(
            children: [
              Icon(icon, color: AppColors.wine),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), Text(detail)])),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
}
