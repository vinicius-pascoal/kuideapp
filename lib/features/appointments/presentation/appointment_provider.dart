import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/appointment.dart';

final appointmentsProvider = NotifierProvider<AppointmentController, List<Appointment>>(AppointmentController.new);

class AppointmentController extends Notifier<List<Appointment>> {
  @override
  List<Appointment> build() => [
        Appointment(id: 'cardio', type: AppointmentType.consultation, title: 'Consulta com cardiologista', clinic: 'Clínica Vida', doctor: 'Dr. Roberto Silva', dateTime: DateTime.now().add(const Duration(days: 2, hours: 10))),
        Appointment(id: 'blood', type: AppointmentType.exam, title: 'Exame de sangue', clinic: 'Laboratório Central', dateTime: DateTime.now().add(const Duration(days: 7, hours: 8))),
      ];

  void add(Appointment appointment) => state = [...state, appointment]..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}
