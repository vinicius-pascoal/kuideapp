import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/tasks/domain/task.dart';
import 'package:kuideapp/features/tasks/presentation/task_provider.dart';

void main() {
  test('tarefas podem ser incluídas, concluídas, reabertas e removidas', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(tasksProvider.notifier);

    await controller.add(
      Task(id: 'teste', title: 'Tarefa de teste', period: TaskPeriod.afternoon, date: DateTime.now()),
    );
    await controller.toggleCompleted('teste');
    expect(container.read(tasksProvider).where((task) => task.id == 'teste').single.completed, isTrue);

    await controller.toggleCompleted('teste');
    expect(container.read(tasksProvider).where((task) => task.id == 'teste').single.completed, isFalse);

    await controller.remove('teste');
    expect(container.read(tasksProvider).where((task) => task.id == 'teste'), isEmpty);
  });
}
