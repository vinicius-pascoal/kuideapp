import '../domain/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> findAll();
  Future<Task> add(Task task);
  Future<void> update(Task task);
  Future<void> remove(String id);
}

class MockTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<Task> add(Task task) async {
    _tasks.add(task);
    return task;
  }

  @override
  Future<List<Task>> findAll() async => List.unmodifiable(_tasks);

  @override
  Future<void> remove(String id) async => _tasks.removeWhere((task) => task.id == id);

  @override
  Future<void> update(Task task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index >= 0) _tasks[index] = task;
  }
}
