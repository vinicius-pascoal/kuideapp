import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/health/domain/health_measurement.dart';
import 'package:kuideapp/features/health/presentation/health_provider.dart';
import 'package:kuideapp/features/medications/domain/medication.dart';
import 'package:kuideapp/features/medications/presentation/medication_provider.dart';

void main() {
  test('medicamento pode ser incluído e ter dose marcada como tomada', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(medicationsProvider.notifier);

    await controller.add(
      const Medication(
        id: 'novo',
        name: 'Vitamina D',
        dosage: '1.000 UI',
        form: 'Cápsula',
        period: '30 dias',
        time: '12:00',
        recurrence: 'Diariamente',
        stock: 30,
        lowStockAlertAt: 5,
      ),
    );
    await controller.toggleTaken('novo');

    expect(container.read(medicationsProvider).where((item) => item.id == 'novo').single.taken, isTrue);
  });

  test('registro de saúde é acrescentado à categoria correta', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(healthMeasurementsProvider.notifier).add(metric: HealthMetric.glucose, value: '101');

    expect(
      container.read(healthMeasurementsProvider).where((item) => item.metric == HealthMetric.glucose).first.value,
      '101',
    );
  });
}
