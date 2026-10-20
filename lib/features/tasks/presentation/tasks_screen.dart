import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_fields.dart';
import '../../../shared/widgets/app_header.dart';
import '../domain/task.dart';
import 'task_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final pending = tasks.where((task) => !task.completed).toList();
    final complete = tasks.where((task) => task.completed).toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: AppHeader(title: 'Tarefas', onBack: () => context.pop()),
              ),
              TabBar(
                labelColor: AppColors.wine,
                tabs: [Tab(text: 'Pendentes (${pending.length})'), Tab(text: 'Concluídas (${complete.length})')],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _TaskList(tasks: pending, emptyMessage: 'Nenhuma tarefa pendente.'),
                    _TaskList(tasks: complete, emptyMessage: 'Nenhuma tarefa concluída.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddTask(context),
          icon: const Icon(Icons.add),
          label: const Text('Nova tarefa'),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.tasks, required this.emptyMessage});

  final List<Task> tasks;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) => tasks.isEmpty
      ? Center(child: Text(emptyMessage))
      : ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final period in TaskPeriod.values) ...[
              if (tasks.where((task) => task.period == period).isNotEmpty) ...[
                Text(period.label, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                for (final task in tasks.where((task) => task.period == period)) _TaskTile(task: task),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],
        );
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: AppCard(
          tint: false,
          child: Row(
            children: [
              Checkbox(
                value: task.completed,
                onChanged: (_) => ref.read(tasksProvider.notifier).toggleCompleted(task.id),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(decoration: task.completed ? TextDecoration.lineThrough : null)),
                    if (task.description.isNotEmpty) Text(task.description),
                  ],
                ),
              ),
              if (task.completed)
                IconButton(
                  tooltip: 'Remover ${task.title}',
                  onPressed: () => ref.read(tasksProvider.notifier).remove(task.id),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
        ),
      );
}

Future<void> _showAddTask(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddTaskSheet(),
    );

class _AddTaskSheet extends ConsumerStatefulWidget {
  const _AddTaskSheet();

  @override
  ConsumerState<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<_AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _period = TaskPeriod.morning;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nova tarefa', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            AppTextField(label: 'Título', controller: _titleController),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(label: 'Descrição (opcional)', controller: _descriptionController),
            const SizedBox(height: AppSpacing.sm),
            AppDropdown<TaskPeriod>(
              label: 'Período do dia',
              value: _period,
              onChanged: (value) => setState(() => _period = value ?? _period),
              items: TaskPeriod.values.map((period) => DropdownMenuItem(value: period, child: Text(period.label))).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Adicionar tarefa',
              onPressed: () async {
                final title = _titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o título da tarefa.')));
                  return;
                }
                await ref.read(tasksProvider.notifier).add(
                      Task(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: title,
                        description: _descriptionController.text.trim(),
                        period: _period,
                        date: DateTime.now(),
                      ),
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
