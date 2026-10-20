import '../domain/medication.dart';

abstract interface class MedicationRepository {
  Future<List<Medication>> findAll();
  Future<Medication> add(Medication medication);
  Future<void> update(Medication medication);
}

class MockMedicationRepository implements MedicationRepository {
  final List<Medication> _items = [
    const Medication(
      id: 'losartana',
      name: 'Losartana',
      dosage: '50 mg',
      form: 'Comprimido',
      period: 'Uso contínuo',
      time: '08:00',
      recurrence: 'Diariamente',
      stock: 8,
      lowStockAlertAt: 10,
    ),
    const Medication(
      id: 'atorvastatina',
      name: 'Atorvastatina',
      dosage: '20 mg',
      form: 'Comprimido',
      period: 'Uso contínuo',
      time: '20:00',
      recurrence: 'Diariamente',
      stock: 24,
      lowStockAlertAt: 8,
    ),
  ];

  @override
  Future<Medication> add(Medication medication) async {
    _items.add(medication);
    return medication;
  }

  @override
  Future<List<Medication>> findAll() async => List.unmodifiable(_items);

  @override
  Future<void> update(Medication medication) async {
    final index = _items.indexWhere((item) => item.id == medication.id);
    if (index >= 0) _items[index] = medication;
  }
}
