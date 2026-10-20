class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.period,
    required this.time,
    required this.recurrence,
    required this.stock,
    required this.lowStockAlertAt,
    this.taken = false,
  });

  final String id;
  final String name;
  final String dosage;
  final String form;
  final String period;
  final String time;
  final String recurrence;
  final int stock;
  final int lowStockAlertAt;
  final bool taken;

  bool get hasLowStock => stock <= lowStockAlertAt;

  Medication copyWith({bool? taken}) => Medication(
        id: id,
        name: name,
        dosage: dosage,
        form: form,
        period: period,
        time: time,
        recurrence: recurrence,
        stock: stock,
        lowStockAlertAt: lowStockAlertAt,
        taken: taken ?? this.taken,
      );
}
