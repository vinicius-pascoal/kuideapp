import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuideapp/features/onboarding/presentation/onboarding_provider.dart';

void main() {
  test('rascunho do onboarding preserva os dados entre etapas', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(onboardingProvider.notifier);

    await controller.addMedication(name: 'Losartana 50 mg', time: '08:00');
    await controller.saveDoctorDetails(doctor: 'Dr. Roberto', appointment: '15/10 às 10:00');
    await controller.saveEmergencyDetails(
      bloodType: 'O+',
      allergies: 'Penicilina',
      familyContact: 'Ana Santos',
      completed: true,
    );

    final draft = container.read(onboardingProvider);
    expect(draft.medications.single.name, 'Losartana 50 mg');
    expect(draft.primaryDoctor, 'Dr. Roberto');
    expect(draft.bloodType, 'O+');
    expect(draft.completed, isTrue);
  });
}
