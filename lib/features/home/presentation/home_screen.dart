import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../features/appointments/presentation/appointment_provider.dart';
import '../../../features/medications/presentation/medication_provider.dart';
import '../../../features/profile/presentation/profile_provider.dart';
import '../../../features/tasks/domain/task.dart';
import '../../../features/tasks/presentation/task_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/home_mock_data.dart';
import '../domain/quick_access_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationsProvider);
    final pendingTasks = ref
        .watch(tasksProvider)
        .where((task) => !task.completed)
        .toList();
    final appointments = ref.watch(appointmentsProvider);
    final profile = ref.watch(profileProvider);
    final nextAppointment = appointments.first;
    final pendingMedications = medications
        .where((medication) => !medication.taken)
        .toList();
    final nextMedication = pendingMedications.isEmpty
        ? medications.first
        : pendingMedications.first;

    return ColoredBox(
      color: AppColors.cream,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 42, 30, AppSpacing.xl),
        children: [
          _HomeGreeting(name: profile.name, greeting: _greeting()),
          const SizedBox(height: 28),
          _TodayCard(
            medication: '${nextMedication.name} ${nextMedication.dosage}',
            medicationTime: nextMedication.time,
            appointmentTitle: nextAppointment.title,
            appointmentDetail: nextAppointment.doctor ?? nextAppointment.clinic,
            onMedicationTap: () => context.push('/medications'),
            onAppointmentTap: () => context.push('/appointments'),
            onRoutineTap: () => context.go('/routine'),
          ),
          const SizedBox(height: 30),
          SectionHeader(
            title: 'Acesso rápido',
            onViewAll: () => context.push('/quick-access'),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: HomeMockData.quickAccess.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.09,
            ),
            itemBuilder: (context, index) =>
                _HomeShortcut(item: HomeMockData.quickAccess[index]),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Ainda falta hoje'),
          const SizedBox(height: AppSpacing.sm),
          if (pendingMedications.isNotEmpty)
            _OutstandingItem(
              icon: Icons.medication_outlined,
              title: '${nextMedication.name} ${nextMedication.dosage}',
              detail: 'Tomar às ${nextMedication.time}',
              onTap: () => context.push('/medications'),
            ),
          for (final task in pendingTasks.take(2))
            _OutstandingItem(
              icon: Icons.check_circle_outline,
              title: task.title,
              detail: task.period.label,
              onTap: () => context.push('/tasks'),
            ),
          if (pendingMedications.isEmpty && pendingTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Text('Tudo certo por hoje!'),
            ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: 'Próximos compromissos',
            onViewAll: () => context.push('/appointments'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _OutstandingItem(
            icon: Icons.calendar_month_outlined,
            title: nextAppointment.title,
            detail: nextAppointment.doctor ?? nextAppointment.clinic,
            onTap: () => context.push('/appointments'),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia,';
    if (hour < 18) return 'Boa tarde,';
    return 'Boa noite,';
  }
}

class _HomeGreeting extends StatelessWidget {
  const _HomeGreeting({required this.name, required this.greeting});

  final String name;
  final String greeting;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.wine,
                fontWeight: FontWeight.w700,
              ),
            ),
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
            minimumSize: const Size(52, 52),
            shape: const CircleBorder(),
          ),
          icon: const Text(
            'SOS',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    ],
  );
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.medication,
    required this.medicationTime,
    required this.appointmentTitle,
    required this.appointmentDetail,
    required this.onMedicationTap,
    required this.onAppointmentTap,
    required this.onRoutineTap,
  });

  final String medication;
  final String medicationTime;
  final String appointmentTitle;
  final String appointmentDetail;
  final VoidCallback onMedicationTap;
  final VoidCallback onAppointmentTap;
  final VoidCallback onRoutineTap;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 256),
    padding: const EdgeInsets.fromLTRB(22, 21, 22, 18),
    decoration: BoxDecoration(
      color: AppColors.wine,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.lightText.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.today_outlined, color: AppColors.lightText, size: 18),
              SizedBox(width: AppSpacing.xs),
              Text(
                'Sua rotina de hoje',
                style: TextStyle(
                  color: AppColors.lightText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Seus compromissos',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        _TodayAction(
          icon: Icons.medication_outlined,
          title: medication,
          subtitle: 'Tomar às $medicationTime',
          onTap: onMedicationTap,
        ),
        const Divider(color: AppColors.lightText),
        _TodayAction(
          icon: Icons.calendar_month_outlined,
          title: appointmentTitle,
          subtitle: appointmentDetail,
          onTap: onAppointmentTap,
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onRoutineTap,
            icon: const Text(
              'Ver rotina completa',
              style: TextStyle(color: AppColors.lightText),
            ),
            label: const Icon(
              Icons.arrow_forward,
              color: AppColors.lightText,
              size: 18,
            ),
            iconAlignment: IconAlignment.end,
          ),
        ),
      ],
    ),
  );
}

class _TodayAction extends StatelessWidget {
  const _TodayAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
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
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.lightText),
                ),
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
  Widget build(BuildContext context) => Material(
    color: AppColors.cardTint,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: () => item.route == '/health' || item.route == '/routine'
          ? context.go(item.route)
          : context.push(item.route),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.wine,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 27, color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _OutstandingItem extends StatelessWidget {
  const _OutstandingItem({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(detail),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}
