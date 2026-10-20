import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/health_measurement.dart';

final healthMeasurementsProvider = NotifierProvider<HealthMeasurementsController, List<HealthMeasurement>>(
  HealthMeasurementsController.new,
);

class HealthMeasurementsController extends Notifier<List<HealthMeasurement>> {
  @override
  List<HealthMeasurement> build() => [
        HealthMeasurement(id: 'pressure-1', metric: HealthMetric.pressure, value: '120/80', recordedAt: DateTime(2026, 10, 20, 8)),
        HealthMeasurement(id: 'pressure-2', metric: HealthMetric.pressure, value: '122/82', recordedAt: DateTime(2026, 10, 18, 8)),
        HealthMeasurement(id: 'glucose-1', metric: HealthMetric.glucose, value: '98', recordedAt: DateTime(2026, 10, 19, 7)),
        HealthMeasurement(id: 'weight-1', metric: HealthMetric.weight, value: '68,4', recordedAt: DateTime(2026, 10, 17, 9)),
      ];

  void add({required HealthMetric metric, required String value}) {
    state = [
      HealthMeasurement(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        metric: metric,
        value: value,
        recordedAt: DateTime.now(),
      ),
      ...state,
    ];
  }
}
