enum AppointmentType { consultation, exam, other }

extension AppointmentTypeLabel on AppointmentType {
  String get label => switch (this) {
    AppointmentType.consultation => 'Consulta',
    AppointmentType.exam => 'Exame',
    AppointmentType.other => 'Outro',
  };
}

class Appointment {
  const Appointment({required this.id, required this.type, required this.title, required this.clinic, required this.dateTime, this.doctor, this.reminder = '1 dia antes'});

  final String id;
  final AppointmentType type;
  final String title;
  final String clinic;
  final DateTime dateTime;
  final String? doctor;
  final String reminder;
}
