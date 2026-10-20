import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/task_mock_repository.dart';
import '../domain/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => MockTaskRepository());

final tasksProvider = NotifierProvider<TaskController, List<Task>>(TaskController.new);

class TaskController extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    final today = DateTime.now();
    return [
      Task(id: 'buy-fruit', title: 'Comprar frutas', period: TaskPeriod.morning, date: today),
      Task(id: 'water-plants', title: 'Regar as plantas', period: TaskPeriod.afternoon, date: today),
      Task(id: 'check-locks', title: 'Conferir trancas', period: TaskPeriod.evening, date: today),
      Task(id: 'pressure', title: 'Medir a pressão', period: TaskPeriod.morning, date: today.subtract(const Duration(days: 1)), completed: true),
    ];
  }

  Future<void> add(Task task) async {
    final saved = await ref.read(taskRepositoryProvider).add(task);
    state = [...state, saved];
  }

  Future<void> toggleCompleted(String id) async {
    final task = state.firstWhere((item) => item.id == id);
    final updated = task.copyWith(completed: !task.completed);
    await ref.read(taskRepositoryProvider).update(updated);
    state = [for (final item in state) if (item.id == id) updated else item];
  }

  Future<void> remove(String id) async {
    await ref.read(taskRepositoryProvider).remove(id);
    state = state.where((item) => item.id != id).toList();
  }
}
