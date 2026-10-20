import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/medication_mock_repository.dart';
import '../domain/medication.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) => MockMedicationRepository());

final medicationsProvider = NotifierProvider<MedicationController, List<Medication>>(
  MedicationController.new,
);

class MedicationController extends Notifier<List<Medication>> {
  @override
  List<Medication> build() => const [
        Medication(
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
        Medication(
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

  Future<void> add(Medication medication) async {
    final saved = await ref.read(medicationRepositoryProvider).add(medication);
    state = [...state, saved]..sort((a, b) => a.time.compareTo(b.time));
  }

  Future<void> toggleTaken(String id) async {
    final medication = state.firstWhere((item) => item.id == id);
    final updated = medication.copyWith(taken: !medication.taken);
    await ref.read(medicationRepositoryProvider).update(updated);
    state = [for (final item in state) if (item.id == id) updated else item];
  }
}
