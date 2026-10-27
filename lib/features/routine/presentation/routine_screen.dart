import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../features/medications/presentation/medication_provider.dart';
import '../../../features/tasks/domain/task.dart';
import '../../../features/tasks/presentation/task_provider.dart';
import '../../../features/appointments/presentation/appointment_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_header.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  const RoutineScreen({super.key});

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  var _selectedOffset = 0;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = today.add(Duration(days: _selectedOffset));
    final medications = ref.watch(medicationsProvider);
    final tasks = ref.watch(tasksProvider).where((task) => DateUtils.isSameDay(task.date, selectedDate)).toList();
    final appointments = ref.watch(appointmentsProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            AppHeader(title: 'Rotina completa', onBack: () => context.go('/home')),
            const SizedBox(height: AppSpacing.md),
            _DaySelector(selectedOffset: _selectedOffset, onSelected: (offset) => setState(() => _selectedOffset = offset)),
            const SizedBox(height: AppSpacing.lg),
            Text(_dateTitle(selectedDate), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            const Text('Compromissos'),
            const SizedBox(height: AppSpacing.xs),
            for (final appointment in appointments)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppCard(child: ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.calendar_month_outlined, color: AppColors.wine), title: Text(appointment.title), subtitle: Text('${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')} • ${appointment.doctor ?? appointment.clinic}'))),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Medicamentos', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            for (final medication in medications)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppCard(
                  tint: false,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(medication.taken ? Icons.check_circle : Icons.medication_outlined, color: AppColors.wine),
                    title: Text('${medication.name} ${medication.dosage}'),
                    subtitle: Text('${medication.time} • ${medication.taken ? 'Tomado' : 'Pendente'}'),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Tarefas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            if (tasks.isEmpty)
              const Text('Nenhuma tarefa para este dia.')
            else
              for (final task in tasks)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: AppCard(
                    tint: false,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(task.completed ? Icons.check_circle : Icons.check_circle_outline, color: AppColors.wine),
                      title: Text(task.title),
                      subtitle: Text(task.period.label),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _dateTitle(DateTime date) => '${_weekday(date.weekday)}, ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  String _weekday(int weekday) => const ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'][weekday - 1];
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selectedOffset, required this.onSelected});

  final int selectedOffset;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final selectedDate = today.add(Duration(days: selectedOffset));
    final visibleDates = List.generate(
      4,
      (index) => selectedDate.add(Duration(days: index - 2)),
    );

    return Container(
      // The app lets people increase the font size, so the selector scales
      // vertically with the active text scale instead of clipping its labels.
      height: 66 * textScale,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.lightText.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.wine.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          _DaySelectorArrow(
            icon: Icons.arrow_back,
            onTap: () => onSelected(selectedOffset - 1),
          ),
          const SizedBox(width: 4),
          for (var index = 0; index < visibleDates.length; index++)
            Expanded(
              child: _DaySelectorDate(
                date: visibleDates[index],
                selected: index == 2,
                onTap: () => onSelected(selectedOffset + index - 2),
              ),
            ),
          const SizedBox(width: 4),
          _DaySelectorArrow(
            icon: Icons.arrow_forward,
            onTap: () => onSelected(selectedOffset + 1),
          ),
        ],
      ),
    );
  }
}

class _DaySelectorArrow extends StatelessWidget {
  const _DaySelectorArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.lightText.withValues(alpha: .52),
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 30,
        child: Icon(icon, size: 18, color: AppColors.wine),
      ),
    ),
  );
}

class _DaySelectorDate extends StatelessWidget {
  const _DaySelectorDate({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final textColor = selected ? AppColors.white : AppColors.wine;
    final weekday = const ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'][date.weekday - 1];

    return Material(
      color: selected ? AppColors.wine : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.w600),
            ),
            Text(
              '${date.day}',
              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 8,
              child: Text(
                isToday ? 'HOJE' : '',
                style: TextStyle(color: textColor, fontSize: 6, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
