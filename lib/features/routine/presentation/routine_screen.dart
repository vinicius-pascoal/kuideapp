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
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final offset = index - 3;
          final date = today.add(Duration(days: offset));
          final selected = offset == selectedOffset;
          return ChoiceChip(
            selected: selected,
            onSelected: (_) => onSelected(offset),
            selectedColor: AppColors.wine,
            labelStyle: TextStyle(color: selected ? AppColors.white : AppColors.darkText),
            label: SizedBox(
              width: 42,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(const ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'][date.weekday - 1]),
                  Text('${date.day}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
