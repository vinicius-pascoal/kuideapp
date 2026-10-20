enum TaskPeriod { morning, afternoon, evening }

extension TaskPeriodLabel on TaskPeriod {
  String get label => switch (this) {
        TaskPeriod.morning => 'Manhã',
        TaskPeriod.afternoon => 'Tarde',
        TaskPeriod.evening => 'Noite',
      };
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.period,
    required this.date,
    this.description = '',
    this.completed = false,
  });

  final String id;
  final String title;
  final TaskPeriod period;
  final DateTime date;
  final String description;
  final bool completed;

  Task copyWith({bool? completed}) => Task(
        id: id,
        title: title,
        period: period,
        date: date,
        description: description,
        completed: completed ?? this.completed,
      );
}
