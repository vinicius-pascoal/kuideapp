enum HealthMetric { pressure, glucose, weight }

extension HealthMetricLabel on HealthMetric {
  String get label => switch (this) {
        HealthMetric.pressure => 'Pressão',
        HealthMetric.glucose => 'Glicemia',
        HealthMetric.weight => 'Peso',
      };

  String get unit => switch (this) {
        HealthMetric.pressure => 'mmHg',
        HealthMetric.glucose => 'mg/dL',
        HealthMetric.weight => 'kg',
      };
}

class HealthMeasurement {
  const HealthMeasurement({
    required this.id,
    required this.metric,
    required this.value,
    required this.recordedAt,
  });

  final String id;
  final HealthMetric metric;
  final String value;
  final DateTime recordedAt;
}
