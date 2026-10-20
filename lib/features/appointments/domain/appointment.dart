enum AppointmentType { consultation, exam }

extension AppointmentTypeLabel on AppointmentType {
  String get label => this == AppointmentType.consultation ? 'Consulta' : 'Exame';
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
